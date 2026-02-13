import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lib/services/dropdown_service.dart';
import 'lib/widgets/searchable_dropdown.dart';

void main() {
  runApp(const CompanyTypeDropdownTestApp());
}

class CompanyTypeDropdownTestApp extends StatelessWidget {
  const CompanyTypeDropdownTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Company Type Dropdown Test',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const CompanyTypeDropdownTestScreen(),
    );
  }
}

class CompanyTypeDropdownTestScreen extends StatefulWidget {
  const CompanyTypeDropdownTestScreen({super.key});

  @override
  State<CompanyTypeDropdownTestScreen> createState() =>
      _CompanyTypeDropdownTestScreenState();
}

class _CompanyTypeDropdownTestScreenState
    extends State<CompanyTypeDropdownTestScreen> {
  List<String> _companyTypes = [];
  String? _selectedCompanyType;
  bool _isLoading = true;
  String _debugInfo = '';

  static const primaryBlue = Color(0xFF007BFF);

  @override
  void initState() {
    super.initState();
    _loadCompanyTypes();
  }

  Future<void> _loadCompanyTypes() async {
    setState(() {
      _isLoading = true;
      _debugInfo = 'Loading company types...';
    });

    try {
      // Test 1: Load all dropdown options
      print('🔍 Test 1: Loading all dropdown options...');
      final allOptions = await DropdownService.getAllDropdownOptions();

      setState(() {
        _debugInfo += '\n✅ Loaded ${allOptions.length} dropdown categories';
        _debugInfo += '\nCategories: ${allOptions.keys.toList()}';
      });

      // Test 2: Check company types specifically
      if (allOptions.containsKey('company_types')) {
        _companyTypes = allOptions['company_types']!;
        setState(() {
          _debugInfo +=
              '\n✅ Found ${_companyTypes.length} company types from Firebase';
          _debugInfo +=
              '\nFirst 5 company types: ${_companyTypes.take(5).toList()}';
        });
      } else {
        // Test 3: Try loading default options
        print('⚠️ No company_types in Firebase, loading defaults...');
        _companyTypes = DropdownService.getDefaultOptions('company_types');
        setState(() {
          _debugInfo +=
              '\n⚠️ Using default company types (${_companyTypes.length} items)';
          _debugInfo +=
              '\nFirst 5 default types: ${_companyTypes.take(5).toList()}';
        });
      }

      // Test 4: Test Firebase connection
      print('🔍 Test 4: Testing Firebase connection...');
      final connectionTest = await DropdownService.testFirebaseConnection();
      setState(() {
        _debugInfo += '\n\n📡 Firebase Connection Test:';
        _debugInfo +=
            '\nCan read dropdown_options: ${connectionTest['canReadDropdownOptions']}';
        _debugInfo +=
            '\nDropdown options exist: ${connectionTest['dropdownOptionsExists']}';
        if (connectionTest['error'] != null) {
          _debugInfo += '\nError: ${connectionTest['error']}';
        }
      });
    } catch (e) {
      print('❌ Error loading company types: $e');
      setState(() {
        _debugInfo += '\n❌ Error: $e';
        // Use default options as fallback
        _companyTypes = DropdownService.getDefaultOptions('company_types');
        _debugInfo +=
            '\n🔄 Using fallback default options (${_companyTypes.length} items)';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Company Type Dropdown Test'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Debug Info Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Debug Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _debugInfo.isEmpty ? 'No debug info yet...' : _debugInfo,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Loading Indicator
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading company types...'),
                  ],
                ),
              ),

            // Company Type Dropdown Test
            if (!_isLoading) ...[
              const Text(
                'Company Type Dropdown Test',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Test with SearchableDropdown widget
              SearchableDropdown(
                value: _selectedCompanyType,
                items: _companyTypes,
                hintText: 'Select or type company type',
                labelText: 'Company Type',
                prefixIcon: Icons.business_rounded,
                primaryColor: primaryBlue,
                onChanged: (value) {
                  setState(() {
                    _selectedCompanyType = value;
                    _debugInfo += '\n✅ Selected: $value';
                  });
                  print('✅ Company type selected: $value');
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please select company type';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Selected Value Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _selectedCompanyType != null
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedCompanyType != null
                        ? Colors.green.shade300
                        : Colors.orange.shade300,
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
                            : Colors.orange.shade700,
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
                            : Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Available Options List
              const Text(
                'Available Company Types:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _companyTypes.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No company types loaded',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _companyTypes.length,
                        itemBuilder: (context, index) {
                          final companyType = _companyTypes[index];
                          final isSelected =
                              companyType == _selectedCompanyType;

                          return ListTile(
                            dense: true,
                            title: Text(
                              companyType,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? primaryBlue
                                    : Colors.black87,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check,
                                    color: primaryBlue,
                                    size: 18,
                                  )
                                : null,
                            onTap: () {
                              setState(() {
                                _selectedCompanyType = companyType;
                                _debugInfo +=
                                    '\n✅ Selected from list: $companyType';
                              });
                            },
                          );
                        },
                      ),
              ),
            ],

            const SizedBox(height: 24),

            // Refresh Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loadCompanyTypes,
                icon: const Icon(Icons.refresh),
                label: const Text('Reload Company Types'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
