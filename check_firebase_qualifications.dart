import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FirebaseQualificationChecker());
}

class FirebaseQualificationChecker extends StatelessWidget {
  const FirebaseQualificationChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Qualification Checker',
      home: const QualificationCheckerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QualificationCheckerScreen extends StatefulWidget {
  const QualificationCheckerScreen({super.key});

  @override
  State<QualificationCheckerScreen> createState() =>
      _QualificationCheckerScreenState();
}

class _QualificationCheckerScreenState
    extends State<QualificationCheckerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> _results = {};
  bool _isLoading = false;
  String _status = 'Ready to check Firebase';

  @override
  void initState() {
    super.initState();
    _checkFirebaseQualifications();
  }

  Future<void> _checkFirebaseQualifications() async {
    setState(() {
      _isLoading = true;
      _status = 'Checking Firebase for qualifications...';
      _results = {};
    });

    try {
      print('🔍 Checking Firebase for qualification documents...');

      // Check 1: Look for 'qualification' document
      try {
        final qualDoc = await _firestore
            .collection('dropdown_options')
            .doc('qualification')
            .get();
        _results['qualification_doc'] = {
          'exists': qualDoc.exists,
          'data': qualDoc.exists ? qualDoc.data() : null,
        };
        print('📄 qualification document exists: ${qualDoc.exists}');
        if (qualDoc.exists) {
          print('📊 qualification document data: ${qualDoc.data()}');
        }
      } catch (e) {
        _results['qualification_doc'] = {'error': e.toString()};
        print('❌ Error checking qualification document: $e');
      }

      // Check 2: Look for 'qualifications' document
      try {
        final qualsDoc = await _firestore
            .collection('dropdown_options')
            .doc('qualifications')
            .get();
        _results['qualifications_doc'] = {
          'exists': qualsDoc.exists,
          'data': qualsDoc.exists ? qualsDoc.data() : null,
        };
        print('📄 qualifications document exists: ${qualsDoc.exists}');
        if (qualsDoc.exists) {
          print('📊 qualifications document data: ${qualsDoc.data()}');
        }
      } catch (e) {
        _results['qualifications_doc'] = {'error': e.toString()};
        print('❌ Error checking qualifications document: $e');
      }

      // Check 3: List all documents in dropdown_options
      try {
        final allDocs = await _firestore.collection('dropdown_options').get();
        _results['all_documents'] = {
          'count': allDocs.docs.length,
          'document_ids': allDocs.docs.map((doc) => doc.id).toList(),
          'documents': {},
        };

        print('📋 Found ${allDocs.docs.length} documents in dropdown_options');
        print('📋 Document IDs: ${allDocs.docs.map((doc) => doc.id).toList()}');

        // Check each document for qualification-related fields
        for (final doc in allDocs.docs) {
          final data = doc.data();
          final hasQualificationField = data.containsKey('qualification');
          final hasQualificationsField = data.containsKey('qualifications');
          final hasOptionsField = data.containsKey('options');

          _results['all_documents']['documents'][doc.id] = {
            'data': data,
            'has_qualification_field': hasQualificationField,
            'has_qualifications_field': hasQualificationsField,
            'has_options_field': hasOptionsField,
          };

          print('📄 Document ${doc.id}:');
          print('  - Has qualification field: $hasQualificationField');
          print('  - Has qualifications field: $hasQualificationsField');
          print('  - Has options field: $hasOptionsField');
          print('  - Data: $data');

          if (hasQualificationField) {
            final qualData = data['qualification'];
            print(
              '  - Qualification data: $qualData (type: ${qualData.runtimeType})',
            );
          }
          if (hasQualificationsField) {
            final qualsData = data['qualifications'];
            print(
              '  - Qualifications data: $qualsData (type: ${qualsData.runtimeType})',
            );
          }
          if (hasOptionsField) {
            final optionsData = data['options'];
            print(
              '  - Options data: $optionsData (type: ${optionsData.runtimeType})',
            );
          }
        }
      } catch (e) {
        _results['all_documents'] = {'error': e.toString()};
        print('❌ Error listing all documents: $e');
      }

      // Check 4: Test Firebase connection
      try {
        final testDoc = await _firestore
            .collection('dropdown_options')
            .limit(1)
            .get();
        _results['firebase_connection'] = {
          'can_read': true,
          'has_documents': testDoc.docs.isNotEmpty,
        };
        print('✅ Firebase connection successful');
      } catch (e) {
        _results['firebase_connection'] = {
          'can_read': false,
          'error': e.toString(),
        };
        print('❌ Firebase connection failed: $e');
      }

      setState(() {
        _isLoading = false;
        _status = 'Firebase check completed';
      });

      print('🎯 Firebase qualification check completed');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error: $e';
      });
      print('❌ Error in Firebase qualification check: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Qualification Checker'),
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
                color: _isLoading
                    ? Colors.orange[100]
                    : _status.contains('completed')
                    ? Colors.green[100]
                    : Colors.red[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isLoading
                      ? Colors.orange
                      : _status.contains('completed')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              child: Text(
                _status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isLoading
                      ? Colors.orange[800]
                      : _status.contains('completed')
                      ? Colors.green[800]
                      : Colors.red[800],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Loading indicator
            if (_isLoading) const Center(child: CircularProgressIndicator()),

            // Results
            if (!_isLoading && _results.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      'Firebase Check Results:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Firebase Connection
                    _buildResultCard(
                      'Firebase Connection',
                      _results['firebase_connection'],
                      Colors.blue,
                    ),
                    const SizedBox(height: 16),

                    // Qualification Document
                    _buildResultCard(
                      'Qualification Document',
                      _results['qualification_doc'],
                      Colors.green,
                    ),
                    const SizedBox(height: 16),

                    // Qualifications Document
                    _buildResultCard(
                      'Qualifications Document',
                      _results['qualifications_doc'],
                      Colors.purple,
                    ),
                    const SizedBox(height: 16),

                    // All Documents
                    _buildResultCard(
                      'All Documents',
                      _results['all_documents'],
                      Colors.orange,
                    ),
                  ],
                ),
              ),

            // Refresh button
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _checkFirebaseQualifications,
                child: const Text('Refresh Check'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, dynamic data, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (data == null)
              const Text('No data')
            else
              Text(
                data.toString(),
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
          ],
        ),
      ),
    );
  }
}
