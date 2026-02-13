import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'lib/services/dropdown_service.dart';
import 'lib/widgets/searchable_dropdown.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ExistingDropdownTestApp());
}

class ExistingDropdownTestApp extends StatelessWidget {
  const ExistingDropdownTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Existing Dropdown Structure',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ExistingDropdownTestScreen(),
    );
  }
}

class ExistingDropdownTestScreen extends StatefulWidget {
  const ExistingDropdownTestScreen({super.key});

  @override
  State<ExistingDropdownTestScreen> createState() =>
      _ExistingDropdownTestScreenState();
}

class _ExistingDropdownTestScreenState
    extends State<ExistingDropdownTestScreen> {
  List<String> _companyTypes = [];
  String? _selectedCompanyType;
  bool _isLoading = true;
  String _status = 'Loading...';
  Map<String, List<String>> _allDropdowns = {};

  @override
  void initState() {
    super.initState();
    _testExistingStructure();
  }

  Future<void> _testExistingStructure() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing existing dropdown structure...';
    });

    try {
      print(
        '🔍 Testing updated DropdownService with existing Firebase structure...',
      );

      // Test 1: Load all dropdown options (should handle existing structure)
      print('\n📊 Test 1: Loading all dropdown options...');
      final allOptions = await DropdownService.getAllDropdownOptions();

      setState(() {
        _allDropdowns = allOptions;
      });

      print('✅ Loaded ${allOptions.length} dropdown categories:');
      allOptions.forEach((key, value) {
        print('   $key: ${value.length} items');
      });

      // Test 2: Specifically check for company_types
      if (allOptions.containsKey('company_types')) {
        setState(() {
          _companyTypes = allOptions['company_types']!;
          _status =
              'SUCCESS: Found ${_companyTypes.length} company types from existing structure!';
        });
        print(
          '✅ Company types loaded successfully: ${_companyTypes.length} items',
        );
        print('📋 First 5 company types: ${_companyTypes.take(5).toList()}');
      } else {
        print('⚠️ No company_types found in getAllDropdownOptions result');

        // Test 3: Try direct loading
        print('\n📊 Test 3: Direct company type loading...');
        final directCompanyTypes = await DropdownService.getDropdownOptions(
          'company_types',
        );

        setState(() {
          _companyTypes = directCompanyTypes;
          _status = directCompanyTypes.isNotEmpty
              ? 'Found ${directCompanyTypes.length} company types via direct loading'
              : 'No company types found - using defaults';
        });

        print('📋 Direct loading result: ${directCompanyTypes.length} items');
      }
    } catch (e) {
      print('❌ Error testing existing structure: $e');
      setState(() {
        _status = 'Error: $e';
        _companyTypes = DropdownService.getDefaultOptions('company_types');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Existing Dropdown Structure'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              color: _isLoading
                  ? Colors.orange.shade50
                  : _companyTypes.isNotEmpty
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isLoading
                              ? Icons.hourglass_empty
                              : _companyTypes.isNotEmpty
                              ? Icons.check_circle
                              : Icons.error,
                          color: _isLoading
                              ? Colors.orange
                              : _companyTypes.isNotEmpty
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _status,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Test Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _testExistingStructure,
                icon: const Icon(Icons.refresh),
                label: const Text('Re-test Structure'),
              ),
            ),

            const SizedBox(height: 24),

            // All Dropdowns Summary
            if (_allDropdowns.isNotEmpty) ...[
              const Text(
                'All Loaded Dropdowns:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _allDropdowns.entries.map((entry) {
                      final isCompanyType = entry.key == 'company_types';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              isCompanyType ? Icons.star : Icons.check,
                              size: 16,
                              color: isCompanyType
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${entry.key}: ${entry.value.length} items',
                                style: TextStyle(
                                  fontWeight: isCompanyType
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isCompanyType
                                      ? Colors.orange.shade700
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Company Type Dropdown Test
            const Text(
              'Company Type Dropdown Test:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (_companyTypes.isNotEmpty) ...[
              SearchableDropdown(
                value: _selectedCompanyType,
                items: _companyTypes,
                hintText: 'Select or type company type',
                labelText: 'Company Type',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please select company type';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedCompanyType = value;
                  });
                  print('✅ Selected company type: $value');
                },
              ),

              const SizedBox(height: 16),

              // Selection Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _selectedCompanyType != null
                      ? Colors.green.shade50
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedCompanyType != null
                        ? Colors.green.shade300
                        : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _selectedCompanyType != null
                            ? Colors.green.shade700
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedCompanyType ?? 'None selected',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _selectedCompanyType != null
                            ? Colors.green.shade800
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red),
                    SizedBox(height: 12),
                    Text(
                      'No Company Types Found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Check Firebase structure and field names',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
