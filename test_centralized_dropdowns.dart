import 'package:flutter/material.dart';
import 'lib/services/dropdown_service.dart';
import 'lib/dropdown_options/dropdown_options.dart';

/// Test screen to verify centralized dropdown functionality
class TestCentralizedDropdownsScreen extends StatefulWidget {
  const TestCentralizedDropdownsScreen({super.key});

  @override
  State<TestCentralizedDropdownsScreen> createState() =>
      _TestCentralizedDropdownsScreenState();
}

class _TestCentralizedDropdownsScreenState
    extends State<TestCentralizedDropdownsScreen> {
  Map<String, List<String>> _dropdownOptions = {};
  bool _isLoading = false;
  String _status = 'Ready to test';

  @override
  void initState() {
    super.initState();
    _testDropdowns();
  }

  Future<void> _testDropdowns() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing centralized dropdowns...';
    });

    try {
      // Test 1: Direct access to local options
      print('=== Testing Direct Local Options ===');
      final localQualifications = QualificationOptions.values;
      final localJobCategories = JobCategoryOptions.values;
      final localJobTypes = JobTypeOptions.values;
      final localDesignations = DesignationOptions.values;

      print('✅ Local Qualifications: ${localQualifications.length} items');
      print('✅ Local Job Categories: ${localJobCategories.length} items');
      print('✅ Local Job Types: ${localJobTypes.length} items');
      print('✅ Local Designations: ${localDesignations.length} items');

      // Test 2: Access through DropdownOptions class
      print('\n=== Testing DropdownOptions Class ===');
      final qualifications = DropdownOptions.getOptions('qualification');
      final jobCategories = DropdownOptions.getOptions('jobCategory');
      final jobTypes = DropdownOptions.getOptions('jobType');
      final designations = DropdownOptions.getOptions('designation');

      print('✅ DropdownOptions Qualifications: ${qualifications.length} items');
      print('✅ DropdownOptions Job Categories: ${jobCategories.length} items');
      print('✅ DropdownOptions Job Types: ${jobTypes.length} items');
      print('✅ DropdownOptions Designations: ${designations.length} items');

      // Test 3: Access through DropdownService
      print('\n=== Testing DropdownService ===');
      final serviceQualifications = await DropdownService.getDropdownOptions(
        'qualification',
      );
      final serviceJobCategories = await DropdownService.getDropdownOptions(
        'jobCategory',
      );
      final serviceJobTypes = await DropdownService.getDropdownOptions(
        'jobType',
      );
      final serviceDesignations = await DropdownService.getDropdownOptions(
        'designation',
      );

      print('✅ Service Qualifications: ${serviceQualifications.length} items');
      print('✅ Service Job Categories: ${serviceJobCategories.length} items');
      print('✅ Service Job Types: ${serviceJobTypes.length} items');
      print('✅ Service Designations: ${serviceDesignations.length} items');

      // Test 4: Get all options
      print('\n=== Testing Get All Options ===');
      final allLocalOptions = DropdownOptions.getAllOptions();
      final allServiceOptions = await DropdownService.getAllDropdownOptions();

      print('✅ All Local Options: ${allLocalOptions.length} categories');
      print('✅ All Service Options: ${allServiceOptions.length} categories');

      setState(() {
        _dropdownOptions = {
          'Local Qualifications': localQualifications,
          'Local Job Categories': localJobCategories,
          'Local Job Types': localJobTypes,
          'Local Designations': localDesignations,
          'Service Qualifications': serviceQualifications,
          'Service Job Categories': serviceJobCategories,
          'Service Job Types': serviceJobTypes,
          'Service Designations': serviceDesignations,
        };
        _isLoading = false;
        _status = 'All tests completed successfully!';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error: $e';
      });
      print('❌ Error testing dropdowns: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Centralized Dropdowns'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isLoading ? Colors.orange[100] : Colors.green[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isLoading ? Colors.orange : Colors.green,
                ),
              ),
              child: Text(
                _status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isLoading ? Colors.orange[800] : Colors.green[800],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Loading indicator
            if (_isLoading) const Center(child: CircularProgressIndicator()),

            // Results
            if (!_isLoading && _dropdownOptions.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      'Dropdown Test Results:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._dropdownOptions.entries.map(
                      (entry) => _buildDropdownSection(entry.key, entry.value),
                    ),
                  ],
                ),
              ),

            // Refresh button
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _testDropdowns,
                child: const Text('Refresh Test'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSection(String title, List<String> options) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title (${options.length} items)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: options.take(10).map((option) {
                return Chip(
                  label: Text(option, style: const TextStyle(fontSize: 12)),
                  backgroundColor: Colors.blue[100],
                );
              }).toList(),
            ),
            if (options.length > 10)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '... and ${options.length - 10} more items',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: const TestCentralizedDropdownsScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
