import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/dropdown_service.dart';

class DropdownDebugScreen extends StatefulWidget {
  const DropdownDebugScreen({super.key});

  @override
  State<DropdownDebugScreen> createState() => _DropdownDebugScreenState();
}

class _DropdownDebugScreenState extends State<DropdownDebugScreen> {
  Map<String, dynamic> _debugInfo = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _runDebugTests();
  }

  Future<void> _runDebugTests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('🔍 Starting dropdown debug tests...');

      // Test 1: Check Firebase connection
      final connectionTest = await DropdownService.testFirebaseConnection();
      _debugInfo['connectionTest'] = connectionTest;

      // Test 2: Check what documents exist in dropdown_options
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('dropdown_options')
          .get();

      _debugInfo['documentsFound'] = querySnapshot.docs.length;
      _debugInfo['documentIds'] = querySnapshot.docs
          .map((doc) => doc.id)
          .toList();

      // Test 3: Get data for each document
      Map<String, dynamic> documentData = {};
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        documentData[doc.id] = {
          'exists': true,
          'data': data,
          'optionsCount': (data['options'] as List?)?.length ?? 0,
          'options': data['options'] ?? [],
        };
      }
      _debugInfo['documentData'] = documentData;

      // Test 4: Try to fetch each category individually using both app names and Firebase document names
      final categories = [
        // App category names (should be mapped to Firebase document names)
        'qualifications',
        'departments',
        'designations',
        'company_types',
        'industry_types',
        'job_categories',
        'job_types',
        // Direct Firebase document names
        'qualification',
        'department',
        'designation',
        'companyType',
        'candidateDepartment',
        'industryType',
        'jobCategory',
        'jobType',
      ];
      Map<String, dynamic> categoryTests = {};

      for (final category in categories) {
        try {
          final options = await DropdownService.getDropdownOptions(category);
          categoryTests[category] = {
            'success': true,
            'optionsCount': options.length,
            'options': options,
          };
        } catch (e) {
          categoryTests[category] = {'success': false, 'error': e.toString()};
        }
      }
      _debugInfo['categoryTests'] = categoryTests;

      // Test 5: Try getAllDropdownOptions
      try {
        final allOptions = await DropdownService.getAllDropdownOptions();
        _debugInfo['getAllTest'] = {
          'success': true,
          'categoriesCount': allOptions.length,
          'categories': allOptions.keys.toList(),
          'data': allOptions,
        };
      } catch (e) {
        _debugInfo['getAllTest'] = {'success': false, 'error': e.toString()};
      }

      print('✅ Debug tests completed');
      print('📊 Debug info: $_debugInfo');
    } catch (e) {
      print('❌ Error running debug tests: $e');
      _debugInfo['error'] = e.toString();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dropdown Debug'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dropdown Debug Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Connection Test
                  _buildSection(
                    'Firebase Connection Test',
                    _debugInfo['connectionTest'],
                  ),

                  // Documents Found
                  _buildSection('Documents in dropdown_options', {
                    'count': _debugInfo['documentsFound'],
                    'ids': _debugInfo['documentIds'],
                  }),

                  // Document Data
                  _buildSection('Document Data', _debugInfo['documentData']),

                  // Category Tests
                  _buildSection(
                    'Individual Category Tests',
                    _debugInfo['categoryTests'],
                  ),

                  // Get All Test
                  _buildSection(
                    'Get All Options Test',
                    _debugInfo['getAllTest'],
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _runDebugTests,
                    child: const Text('Run Tests Again'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSection(String title, dynamic data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                data?.toString() ?? 'No data',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
