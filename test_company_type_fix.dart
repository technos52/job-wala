import 'package:flutter/material.dart';
import 'lib/services/dropdown_service.dart';

void main() {
  runApp(const CompanyTypeTestApp());
}

class CompanyTypeTestApp extends StatelessWidget {
  const CompanyTypeTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Company Type Test',
      home: const CompanyTypeTestScreen(),
    );
  }
}

class CompanyTypeTestScreen extends StatefulWidget {
  const CompanyTypeTestScreen({super.key});

  @override
  State<CompanyTypeTestScreen> createState() => _CompanyTypeTestScreenState();
}

class _CompanyTypeTestScreenState extends State<CompanyTypeTestScreen> {
  List<String> _companyTypes = [];
  String? _selectedCompanyType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompanyTypes();
  }

  Future<void> _loadCompanyTypes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // First try to get default options (this should always work)
      final defaultTypes = DropdownService.getDefaultOptions('company_types');
      print('✅ Default company types loaded: ${defaultTypes.length}');

      setState(() {
        _companyTypes = defaultTypes;
        _isLoading = false;
      });

      // Then try to load from Firebase (this might fail)
      try {
        final allOptions = await DropdownService.getAllDropdownOptions();
        if (allOptions.containsKey('company_types')) {
          final firebaseTypes = allOptions['company_types']!;
          print('✅ Firebase company types loaded: ${firebaseTypes.length}');

          setState(() {
            _companyTypes = firebaseTypes;
          });
        } else {
          print('⚠️ No company_types in Firebase, using defaults');
        }
      } catch (e) {
        print('❌ Firebase error (using defaults): $e');
      }
    } catch (e) {
      print('❌ Error loading company types: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Type Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Company Types Test',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              Text('Loaded ${_companyTypes.length} company types'),
              const SizedBox(height: 16),

              // Simple dropdown test
              DropdownButtonFormField<String>(
                value: _selectedCompanyType,
                decoration: const InputDecoration(
                  labelText: 'Company Type',
                  border: OutlineInputBorder(),
                ),
                items: _companyTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCompanyType = newValue;
                  });
                  print('Selected: $newValue');
                },
              ),

              const SizedBox(height: 16),

              if (_selectedCompanyType != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Selected: $_selectedCompanyType'),
                ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _loadCompanyTypes,
                child: const Text('Reload Company Types'),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: _companyTypes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_companyTypes[index]),
                      onTap: () {
                        setState(() {
                          _selectedCompanyType = _companyTypes[index];
                        });
                      },
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
