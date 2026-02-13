import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// This screen will check Firebase dropdown content and convert empty dropdowns to text fields
class FixEmptyDropdownsScreen extends StatefulWidget {
  const FixEmptyDropdownsScreen({super.key});

  @override
  State<FixEmptyDropdownsScreen> createState() =>
      _FixEmptyDropdownsScreenState();
}

class _FixEmptyDropdownsScreenState extends State<FixEmptyDropdownsScreen> {
  Map<String, DropdownStatus> _dropdownStatus = {};
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _checkAllDropdowns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fix Empty Dropdowns'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dropdown Status Analysis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._dropdownStatus.entries.map((entry) {
                        final status = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                status.hasContent
                                    ? Icons.check_circle
                                    : Icons.error,
                                color: status.hasContent
                                    ? Colors.green
                                    : Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      status.hasContent
                                          ? 'Has ${status.itemCount} items - Keep as dropdown'
                                          : 'Empty - Convert to text field',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: status.hasContent
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _populateEmptyDropdowns,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Populate Empty Dropdowns'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _generateCodeFix,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Generate Code Fix'),
              ),
              const SizedBox(height: 16),
              if (_statusMessage.isNotEmpty)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        _statusMessage,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _checkAllDropdowns() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Checking dropdown content...';
    });

    final dropdownsToCheck = {
      'Job Category': 'jobCategory',
      'Job Type': 'jobType',
      'Designation': 'designation',
      'Company Type': 'companyType',
      'Location': 'location',
    };

    Map<String, DropdownStatus> status = {};

    for (var entry in dropdownsToCheck.entries) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('dropdown_options')
            .doc(entry.value)
            .get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          final options = List<String>.from(data['options'] ?? []);
          status[entry.key] = DropdownStatus(
            hasContent: options.isNotEmpty,
            itemCount: options.length,
            firebaseDoc: entry.value,
          );
        } else {
          status[entry.key] = DropdownStatus(
            hasContent: false,
            itemCount: 0,
            firebaseDoc: entry.value,
          );
        }
      } catch (e) {
        status[entry.key] = DropdownStatus(
          hasContent: false,
          itemCount: 0,
          firebaseDoc: entry.value,
          error: e.toString(),
        );
      }
    }

    // Add static data dropdowns (these always have content)
    status['State/Location'] = DropdownStatus(
      hasContent: true,
      itemCount: 36, // Indian states
      firebaseDoc: 'Static data in locations_data.dart',
    );

    status['District'] = DropdownStatus(
      hasContent: true,
      itemCount: 700, // Approximate districts
      firebaseDoc: 'Static data in locations_data.dart',
    );

    setState(() {
      _dropdownStatus = status;
      _isLoading = false;
      _statusMessage = 'Analysis complete. Check results above.';
    });
  }

  Future<void> _populateEmptyDropdowns() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Populating empty dropdowns...';
    });

    final defaultData = {
      'jobCategory': [
        'Software Development',
        'Web Development',
        'Mobile Development',
        'Data Science',
        'Machine Learning',
        'DevOps',
        'Quality Assurance',
        'UI/UX Design',
        'Product Management',
        'Project Management',
        'Business Analysis',
        'Digital Marketing',
        'Content Writing',
        'Sales',
        'Customer Support',
        'Human Resources',
        'Finance & Accounting',
        'Operations',
        'Consulting',
        'Research & Development',
      ],
      'jobType': [
        'Full Time',
        'Part Time',
        'Contract',
        'Freelance',
        'Internship',
        'Remote',
        'Hybrid',
      ],
      'designation': [
        'Software Engineer',
        'Senior Software Engineer',
        'Lead Software Engineer',
        'Software Architect',
        'Full Stack Developer',
        'Frontend Developer',
        'Backend Developer',
        'Mobile Developer',
        'DevOps Engineer',
        'Data Scientist',
        'Data Analyst',
        'Machine Learning Engineer',
        'QA Engineer',
        'Test Engineer',
        'UI/UX Designer',
        'Product Manager',
        'Project Manager',
        'Business Analyst',
        'Technical Lead',
        'Team Lead',
        'Manager',
        'Senior Manager',
        'Director',
        'VP',
        'CTO',
        'CEO',
      ],
      'companyType': [
        'Information Technology (IT)',
        'Software Development',
        'E-commerce',
        'Fintech',
        'Healthcare Technology',
        'EdTech',
        'Gaming',
        'Artificial Intelligence',
        'Blockchain',
        'Cybersecurity',
        'Cloud Computing',
        'SaaS',
        'Mobile App Development',
        'Web Development',
        'Digital Marketing Agency',
        'Consulting',
        'Startup',
        'MNC',
        'Government',
        'Non-Profit',
        'Manufacturing',
        'Automobile',
        'Pharmaceutical',
        'Banking & Finance',
        'Insurance',
        'Retail',
        'Education',
        'Real Estate',
        'Construction',
        'Telecommunications',
        'Media & Entertainment',
        'Food & Beverage',
        'Textile',
        'Chemical',
        'Oil & Gas',
        'Agriculture',
        'Logistics',
        'Other',
      ],
    };

    int populated = 0;
    for (var entry in _dropdownStatus.entries) {
      if (!entry.value.hasContent &&
          defaultData.containsKey(entry.value.firebaseDoc)) {
        try {
          await FirebaseFirestore.instance
              .collection('dropdown_options')
              .doc(entry.value.firebaseDoc)
              .set({'options': defaultData[entry.value.firebaseDoc]!});
          populated++;
        } catch (e) {
          print('Error populating ${entry.key}: $e');
        }
      }
    }

    setState(() {
      _isLoading = false;
      _statusMessage =
          'Populated $populated empty dropdowns. Refresh to see updated status.';
    });

    // Refresh the status
    await Future.delayed(const Duration(seconds: 1));
    await _checkAllDropdowns();
  }

  void _generateCodeFix() {
    final emptyDropdowns = _dropdownStatus.entries
        .where((entry) => !entry.value.hasContent)
        .map((entry) => entry.key)
        .toList();

    if (emptyDropdowns.isEmpty) {
      setState(() {
        _statusMessage = 'All dropdowns have content! No code changes needed.';
      });
      return;
    }

    final codeFix =
        '''
// Code changes needed for empty dropdowns:
// Convert these dropdowns to text fields:

${emptyDropdowns.map((dropdown) => '''
// $dropdown - Convert to TextFormField:
TextFormField(
  controller: _${dropdown.toLowerCase().replaceAll(' ', '')}Controller,
  decoration: InputDecoration(
    labelText: '$dropdown',
    hintText: 'Enter $dropdown',
    border: OutlineInputBorder(),
  ),
  validator: (value) {
    if (value?.isEmpty ?? true) {
      return '$dropdown is required';
    }
    return null;
  },
),
''').join('\n')}

// Keep these as dropdowns (they have content):
${_dropdownStatus.entries.where((entry) => entry.value.hasContent).map((entry) => '// ✅ ${entry.key} - Keep as dropdown (${entry.value.itemCount} items)').join('\n')}
''';

    setState(() {
      _statusMessage = codeFix;
    });
  }
}

class DropdownStatus {
  final bool hasContent;
  final int itemCount;
  final String firebaseDoc;
  final String? error;

  DropdownStatus({
    required this.hasContent,
    required this.itemCount,
    required this.firebaseDoc,
    this.error,
  });
}
