import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/dropdown_service.dart';
import 'utils/init_sample_dropdown_data.dart';

class SimpleDropdownTest extends StatefulWidget {
  const SimpleDropdownTest({super.key});

  @override
  State<SimpleDropdownTest> createState() => _SimpleDropdownTestState();
}

class _SimpleDropdownTestState extends State<SimpleDropdownTest> {
  List<String> _departments = [];
  List<String> _categories = [];
  List<String> _industries = [];
  List<String> _jobTypes = [];

  bool _isLoading = false;
  String _status = 'Ready to test';

  @override
  void initState() {
    super.initState();
    // Auto-run the test when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runFullTest();
    });
  }

  Future<void> _runFullTest() async {
    // First initialize data, then test
    await _initializeData();
    await Future.delayed(const Duration(seconds: 1));
    await _testDropdowns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Dropdown Test'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: $_status'),
            const SizedBox(height: 20),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              ElevatedButton(
                onPressed: _initializeData,
                child: const Text('Initialize Sample Data'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _testDropdowns,
                child: const Text('Test All Dropdowns'),
              ),
              const SizedBox(height: 20),

              _buildDropdownSection('Departments', _departments),
              _buildDropdownSection('Categories', _categories),
              _buildDropdownSection('Industries', _industries),
              _buildDropdownSection('Job Types', _jobTypes),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSection(String title, List<String> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title (${items.length} items)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Text('No items loaded')
            else
              Text(items.join(', ')),
          ],
        ),
      ),
    );
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
      _status = 'Initializing sample data...';
    });

    try {
      await InitSampleDropdownData.initializeSampleData();
      setState(() {
        _status = 'Sample data initialized successfully';
      });
    } catch (e) {
      setState(() {
        _status = 'Error initializing data: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testDropdowns() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing dropdown data loading...';
    });

    try {
      // First, let's check what documents exist
      final firestore = FirebaseFirestore.instance;
      final allDocs = await firestore.collection('dropdown_options').get();

      setState(() {
        _status =
            'Found ${allDocs.docs.length} documents: ${allDocs.docs.map((d) => d.id).join(', ')}';
      });

      await Future.delayed(
        const Duration(seconds: 1),
      ); // Let user see the message

      // Test each dropdown category
      final departments = await DropdownService.getDropdownOptions(
        'job_departments',
      );
      final categories = await DropdownService.getDropdownOptions(
        'job_categories',
      );
      final industries = await DropdownService.getDropdownOptions(
        'industry_types',
      );
      final jobTypes = await DropdownService.getDropdownOptions('job_types');

      setState(() {
        _departments = departments;
        _categories = categories;
        _industries = industries;
        _jobTypes = jobTypes;
        _status =
            'Loaded: Depts(${departments.length}), Cats(${categories.length}), Inds(${industries.length}), Types(${jobTypes.length})';
      });
    } catch (e) {
      setState(() {
        _status = 'Error loading dropdowns: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }
}
