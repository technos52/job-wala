import 'package:flutter/material.dart';
import 'services/dropdown_service.dart';
import 'utils/initialize_dropdown_data.dart';
import 'utils/dropdown_migration_helper.dart';

/// Test screen to verify dropdown service functionality
class TestDropdownServiceScreen extends StatefulWidget {
  const TestDropdownServiceScreen({super.key});

  @override
  State<TestDropdownServiceScreen> createState() =>
      _TestDropdownServiceScreenState();
}

class _TestDropdownServiceScreenState extends State<TestDropdownServiceScreen> {
  Map<String, List<String>> _dropdownOptions = {};
  bool _isLoading = false;
  String _status = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Dropdown Service'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _initializeData,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Initialize Dropdown Data'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _loadDropdownOptions,
              child: const Text('Load Dropdown Options'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _clearCacheAndReload,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear Cache & Reload'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _migrateData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Migrate to New Structure'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _testFirebaseConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Test Firebase Connection'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _createTestData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create Test Data'),
            ),
            const SizedBox(height: 16),
            if (_status.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_status),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _dropdownOptions.entries.map((entry) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...entry.value.map(
                            (option) => Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                bottom: 4,
                              ),
                              child: Text('• $option'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
      _status = 'Initializing dropdown data...';
    });

    try {
      await DropdownDataInitializer.initializeDropdownData();
      setState(() {
        _status = 'Dropdown data initialized successfully!';
      });
    } catch (e) {
      setState(() {
        _status = 'Error initializing data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createTestData() async {
    setState(() {
      _isLoading = true;
      _status = 'Creating test data in dropdown_options collection...';
    });

    try {
      await DropdownMigrationHelper.migrateToNewStructure();

      // Wait a moment for Firebase to propagate
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _status =
            'Test data created successfully! This created the dropdown_options collection with default data. Now try loading the dropdown options.';
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to create test data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testFirebaseConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing Firebase connection and permissions...';
    });

    try {
      final result = await DropdownService.testFirebaseConnection();

      setState(() {
        _status =
            '''Firebase Connection Test Results:

✅ Can read dropdown_options: ${result['canReadDropdownOptions']}
✅ Can read admin_settings: ${result['canReadAdminSettings']}
📄 dropdown_options exists: ${result['dropdownOptionsExists']}
📄 admin_settings exists: ${result['adminSettingsExists']}

${result['error'] != null ? '❌ Errors:\n${result['error']}' : '✅ No errors detected'}

Next steps:
${result['dropdownOptionsExists'] ? '• Your dropdown_options collection exists!' : '• Create dropdown_options collection or run migration'}
${result['adminSettingsExists'] ? '• Your admin_settings exists (can migrate from here)' : '• No admin_settings found'}
''';
      });
    } catch (e) {
      setState(() {
        _status = 'Connection test failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _migrateData() async {
    setState(() {
      _isLoading = true;
      _status = 'Migrating data to new dropdown_options collection...';
    });

    try {
      // Check if migration is needed
      final migrationNeeded = await DropdownMigrationHelper.isMigrationNeeded();

      if (!migrationNeeded) {
        setState(() {
          _status = 'Migration not needed. New structure already exists.';
        });
        return;
      }

      // Perform migration
      await DropdownMigrationHelper.migrateToNewStructure();

      // Wait a moment for Firebase to propagate
      await Future.delayed(const Duration(milliseconds: 500));
      await _loadDropdownOptions();

      setState(() {
        _status =
            'Migration completed successfully! Data moved from admin_settings/dropdown_management to dropdown_options collection.';
      });
    } catch (e) {
      setState(() {
        _status = 'Migration failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearCacheAndReload() async {
    setState(() {
      _isLoading = true;
      _status = 'Reloading dropdown options...';
    });

    try {
      // Wait a moment for any Firebase operations to complete
      await Future.delayed(const Duration(milliseconds: 500));
      await Future.delayed(const Duration(milliseconds: 500));

      // Reload options
      await _loadDropdownOptions();
    } catch (e) {
      setState(() {
        _status = 'Error clearing cache: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDropdownOptions() async {
    setState(() {
      _status = 'Loading dropdown options from new collection...';
    });

    try {
      // Test individual category loading
      final qualifications = await DropdownService.getDropdownOptions(
        'qualifications',
      );
      final departments = await DropdownService.getDropdownOptions(
        'departments',
      );
      final jobTypes = await DropdownService.getDropdownOptions('job_types');

      // Test loading all options
      final options = await DropdownService.getAllDropdownOptions();

      setState(() {
        _dropdownOptions = options;
        _status =
            '''Loaded ${options.length} dropdown categories successfully!

Individual tests:
- Qualifications: ${qualifications.length} items
- Departments: ${departments.length} items  
- Job Types: ${jobTypes.length} items

Collection: dropdown_options
Structure: Each category is a separate document with 'options' array field''';
      });
    } catch (e) {
      setState(() {
        _status =
            'Error loading options: $e\n\nMake sure you have created the "dropdown_options" collection in Firebase with documents for each category (qualifications, departments, job_types, etc.) containing an "options" array field.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
