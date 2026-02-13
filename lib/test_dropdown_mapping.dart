import 'package:flutter/material.dart';
import 'services/dropdown_service.dart';

class TestDropdownMapping extends StatefulWidget {
  const TestDropdownMapping({super.key});

  @override
  State<TestDropdownMapping> createState() => _TestDropdownMappingState();
}

class _TestDropdownMappingState extends State<TestDropdownMapping> {
  Map<String, List<String>> _results = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _testMappings();
  }

  Future<void> _testMappings() async {
    setState(() {
      _isLoading = true;
    });

    // Test categories that should map to Firebase documents
    final testCategories = [
      'qualifications', // should map to 'qualification'
      'departments', // should map to 'department'
      'designations', // should map to 'designation'
      'company_types', // should map to 'companyType'
      'industry_types', // should map to 'industryType'
      'job_categories', // should map to 'jobCategory'
      'job_types', // should map to 'jobType'
    ];

    for (final category in testCategories) {
      try {
        final options = await DropdownService.getDropdownOptions(category);
        _results[category] = options;
        print('✅ $category: ${options.length} options loaded');
      } catch (e) {
        _results[category] = ['Error: $e'];
        print('❌ $category: Error - $e');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Dropdown Mapping'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final category = _results.keys.elementAt(index);
                final options = _results[category]!;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Options count: ${options.length}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...options.map(
                          (option) => Padding(
                            padding: const EdgeInsets.only(left: 16, top: 4),
                            child: Text('• $option'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _testMappings,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
