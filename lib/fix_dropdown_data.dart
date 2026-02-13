import 'package:flutter/material.dart';
import 'utils/init_sample_dropdown_data.dart';
import 'services/dropdown_service.dart';

class FixDropdownDataScreen extends StatefulWidget {
  const FixDropdownDataScreen({super.key});

  @override
  State<FixDropdownDataScreen> createState() => _FixDropdownDataScreenState();
}

class _FixDropdownDataScreenState extends State<FixDropdownDataScreen> {
  bool _isLoading = false;
  String _status = 'Ready to fix dropdown data';
  Map<String, List<String>> _testResults = {};

  Future<void> _fixDropdownData() async {
    setState(() {
      _isLoading = true;
      _status = 'Fixing dropdown data...';
    });

    try {
      // Step 1: Reinitialize with correct document names
      setState(() {
        _status = 'Clearing old data and reinitializing...';
      });

      await InitSampleDropdownData.reinitializeWithCorrectNames();

      // Step 2: Test the data
      setState(() {
        _status = 'Testing dropdown data...';
      });

      await _testDropdownData();

      setState(() {
        _status = 'Dropdown data fixed successfully!';
      });
    } catch (e) {
      setState(() {
        _status = 'Error fixing dropdown data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testDropdownData() async {
    final testCategories = [
      'qualifications',
      'departments',
      'designations',
      'company_types',
      'industry_types',
      'job_categories',
      'job_types',
    ];

    final results = <String, List<String>>{};

    for (final category in testCategories) {
      try {
        final options = await DropdownService.getDropdownOptions(category);
        results[category] = options;
      } catch (e) {
        results[category] = ['Error: $e'];
      }
    }

    setState(() {
      _testResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fix Dropdown Data'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dropdown Data Fix',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This will clear all existing dropdown data and reinitialize it with the correct Firebase document names.',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _status,
                      style: TextStyle(
                        color: _status.contains('Error')
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _fixDropdownData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BFF),
                          foregroundColor: Colors.white,
                        ),
                        child: _isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Fixing...'),
                                ],
                              )
                            : const Text('Fix Dropdown Data'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_testResults.isNotEmpty) ...[
              const Text(
                'Test Results:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _testResults.length,
                  itemBuilder: (context, index) {
                    final category = _testResults.keys.elementAt(index);
                    final options = _testResults[category]!;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Count: ${options.length}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              options.join(', '),
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
