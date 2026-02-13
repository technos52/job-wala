import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/services/dropdown_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DebugApp());
}

class DebugApp extends StatelessWidget {
  const DebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Company Type Debug', home: const DebugScreen());
  }
}

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  List<String> _companyTypes = [];
  bool _isLoading = false;
  String _status = 'Ready to test';
  Map<String, dynamic> _firebaseTest = {};

  @override
  void initState() {
    super.initState();
    _testFirebaseConnection();
  }

  Future<void> _testFirebaseConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing Firebase connection...';
    });

    try {
      // Test Firebase connection
      final testResult = await DropdownService.testFirebaseConnection();
      setState(() {
        _firebaseTest = testResult;
        _status = 'Firebase test completed';
      });

      // Check what documents exist in dropdown_options
      await _checkDropdownOptionsCollection();

      // Try to load company types
      await _loadCompanyTypes();
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _checkDropdownOptionsCollection() async {
    try {
      print('🔍 Checking dropdown_options collection...');
      final querySnapshot = await FirebaseFirestore.instance
          .collection('dropdown_options')
          .get();

      print('📄 Found ${querySnapshot.docs.length} documents');

      for (final doc in querySnapshot.docs) {
        print('📄 Document ID: ${doc.id}');
        final data = doc.data();
        print('📊 Document data: $data');

        if (data.containsKey('options')) {
          final options = List<String>.from(data['options'] ?? []);
          print('📋 Options count: ${options.length}');
          print('📋 First few options: ${options.take(3).toList()}');
        }
      }

      // Specifically check for companyType document
      final companyTypeDoc = await FirebaseFirestore.instance
          .collection('dropdown_options')
          .doc('companyType')
          .get();

      print('🏢 CompanyType document exists: ${companyTypeDoc.exists}');
      if (companyTypeDoc.exists) {
        final data = companyTypeDoc.data();
        print('🏢 CompanyType data: $data');
      }
    } catch (e) {
      print('❌ Error checking dropdown_options: $e');
    }
  }

  Future<void> _loadCompanyTypes() async {
    setState(() {
      _status = 'Loading company types...';
    });

    try {
      // Test direct Firebase call
      final doc = await FirebaseFirestore.instance
          .collection('dropdown_options')
          .doc('companyType')
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final options = List<String>.from(data['options'] ?? []);
        setState(() {
          _companyTypes = options;
          _status = 'Loaded ${options.length} company types from Firebase';
        });
      } else {
        // Try using DropdownService
        final options = await DropdownService.getDropdownOptions(
          'company_types',
        );
        setState(() {
          _companyTypes = options;
          _status =
              'Loaded ${options.length} company types from DropdownService';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error loading company types: $e';
        // Load defaults as fallback
        _companyTypes = DropdownService.getDefaultOptions('company_types');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createCompanyTypeDocument() async {
    setState(() {
      _isLoading = true;
      _status = 'Creating company type document...';
    });

    try {
      final companyTypes = [
        'Information Technology (IT)',
        'Automobile',
        'Automotive',
        'Pharmaceutical',
        'Healthcare',
        'Banking & Finance',
        'Insurance',
        'Manufacturing',
        'Retail',
        'E-commerce',
        'Education',
        'Consulting',
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
        'Government',
        'Non-Profit',
        'Startup',
        'Other',
      ];

      await FirebaseFirestore.instance
          .collection('dropdown_options')
          .doc('companyType')
          .set({
            'options': companyTypes,
            'created_at': FieldValue.serverTimestamp(),
            'updated_at': FieldValue.serverTimestamp(),
          });

      setState(() {
        _status = 'Company type document created successfully!';
        _companyTypes = companyTypes;
      });

      // Reload to verify
      await _loadCompanyTypes();
    } catch (e) {
      setState(() {
        _status = 'Error creating document: $e';
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
        title: const Text('Company Type Debug'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: $_status',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
            if (_firebaseTest.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Firebase Connection Test:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Can read dropdown_options: ${_firebaseTest['canReadDropdownOptions']}',
                      ),
                      Text(
                        'Dropdown options exists: ${_firebaseTest['dropdownOptionsExists']}',
                      ),
                      Text(
                        'Can read admin_settings: ${_firebaseTest['canReadAdminSettings']}',
                      ),
                      Text(
                        'Admin settings exists: ${_firebaseTest['adminSettingsExists']}',
                      ),
                      if (_firebaseTest['error'] != null)
                        Text(
                          'Error: ${_firebaseTest['error']}',
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _loadCompanyTypes,
                  child: const Text('Reload Company Types'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _createCompanyTypeDocument,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Create Document'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Company Types (${_companyTypes.length}):',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _companyTypes.isEmpty
                  ? const Center(
                      child: Text(
                        'No company types loaded',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _companyTypes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(_companyTypes[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
