import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'lib/services/dropdown_service.dart';
import 'lib/widgets/searchable_dropdown.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CompanyTypeRegistrationTestApp());
}

class CompanyTypeRegistrationTestApp extends StatelessWidget {
  const CompanyTypeRegistrationTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Company Type Registration Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CompanyTypeRegistrationTestScreen(),
    );
  }
}

class CompanyTypeRegistrationTestScreen extends StatefulWidget {
  const CompanyTypeRegistrationTestScreen({super.key});

  @override
  State<CompanyTypeRegistrationTestScreen> createState() =>
      _CompanyTypeRegistrationTestScreenState();
}

class _CompanyTypeRegistrationTestScreenState
    extends State<CompanyTypeRegistrationTestScreen> {
  List<String> _companyTypes = [];
  String? _selectedCompanyType;
  bool _isLoading = true;
  String _status = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadCompanyTypes();
  }

  Future<void> _loadCompanyTypes() async {
    setState(() {
      _isLoading = true;
      _status = 'Loading company types from Firebase...';
    });

    try {
      print('🔍 Testing company type loading for candidate registration...');

      // Test 1: Try to load all dropdown options (like in registration screen)
      final allOptions = await DropdownService.getAllDropdownOptions();
      print('📊 All options loaded: ${allOptions.keys.toList()}');

      if (allOptions.containsKey('company_types')) {
        setState(() {
          _companyTypes = allOptions['company_types']!;
          _status =
              'Loaded ${_companyTypes.length} company types from Firebase';
          _isLoading = false;
        });
        print(
          '✅ Company types loaded from Firebase: ${_companyTypes.length} items',
        );
      } else {
        // Test 2: Try direct loading
        print(
          '⚠️ No company_types in getAllDropdownOptions, trying direct load...',
        );
        final directOptions = await DropdownService.getDropdownOptions(
          'company_types',
        );

        setState(() {
          _companyTypes = directOptions;
          _status = directOptions.isNotEmpty
              ? 'Loaded ${directOptions.length} company types (direct)'
              : 'Using default company types';
          _isLoading = false;
        });
        print('📋 Direct load result: ${directOptions.length} items');
      }

      // Test 3: Verify the data matches what registration screen expects
      if (_companyTypes.isNotEmpty) {
        print('✅ Company types available for registration:');
        _companyTypes.take(5).forEach((type) => print('   - $type'));
        if (_companyTypes.length > 5) {
          print('   ... and ${_companyTypes.length - 5} more');
        }
      }
    } catch (e) {
      print('❌ Error loading company types: $e');
      setState(() {
        _companyTypes = DropdownService.getDefaultOptions('company_types');
        _status =
            'Error loading from Firebase, using defaults (${_companyTypes.length} items)';
        _isLoading = false;
      });
    }
  }

  Future<void> _createFirebaseDocument() async {
    setState(() {
      _isLoading = true;
      _status = 'Creating Firebase document...';
    });

    try {
      // This simulates what the setup script would do
      print('🔧 Creating companyType document in Firebase...');

      // For now, just load defaults and show success message
      final defaultTypes = DropdownService.getDefaultOptions('company_types');

      setState(() {
        _companyTypes = defaultTypes;
        _status =
            'Firebase document structure ready! Run setup script to create actual data.';
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'To fix this issue permanently, run:\nnode setup_company_type_firebase.js',
            ),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Type Registration Test'),
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

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _loadCompanyTypes,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Test Loading'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _createFirebaseDocument,
                    icon: const Icon(Icons.add),
                    label: const Text('Setup Guide'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Company Type Dropdown Test (like in registration)
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

              // Selection Status
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
                      'Selected Company Type:',
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
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No Company Types Available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The dropdown is empty because the Firebase document is missing.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Available Options List
            if (_companyTypes.isNotEmpty) ...[
              Text(
                'Available Options (${_companyTypes.length}):',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    itemCount: _companyTypes.length,
                    itemBuilder: (context, index) {
                      final companyType = _companyTypes[index];
                      final isSelected = companyType == _selectedCompanyType;

                      return ListTile(
                        dense: true,
                        title: Text(
                          companyType,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.blue : Colors.black87,
                          ),
                        ),
                        leading: CircleAvatar(
                          radius: 12,
                          backgroundColor: isSelected
                              ? Colors.blue
                              : Colors.grey.shade300,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected ? Colors.white : Colors.black54,
                            ),
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedCompanyType = companyType;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
