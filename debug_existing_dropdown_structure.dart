import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DebugApp());
}

class DebugApp extends StatelessWidget {
  const DebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debug Existing Dropdown Structure',
      home: const DebugScreen(),
    );
  }
}

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  Map<String, dynamic> _dropdownData = {};
  bool _isLoading = false;
  String _status = 'Ready to check existing structure';

  @override
  void initState() {
    super.initState();
    _checkExistingStructure();
  }

  Future<void> _checkExistingStructure() async {
    setState(() {
      _isLoading = true;
      _status = 'Checking existing dropdown_options structure...';
    });

    try {
      print('🔍 Checking existing dropdown_options collection structure...');

      // Get all documents in dropdown_options collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('dropdown_options')
          .get();

      print(
        '📄 Found ${querySnapshot.docs.length} documents in dropdown_options',
      );

      Map<String, dynamic> allData = {};

      for (final doc in querySnapshot.docs) {
        print('📄 Document ID: ${doc.id}');
        final data = doc.data();
        allData[doc.id] = data;

        print('📊 Document fields: ${data.keys.toList()}');

        // Check if this document has company_type field
        if (data.containsKey('company_type')) {
          print('🏢 Found company_type field in document: ${doc.id}');
          final companyTypes = data['company_type'];
          if (companyTypes is List) {
            print('📋 Company types count: ${companyTypes.length}');
            print(
              '📋 First few company types: ${companyTypes.take(3).toList()}',
            );
          } else {
            print('📋 Company type data type: ${companyTypes.runtimeType}');
            print('📋 Company type value: $companyTypes');
          }
        }

        // Check all fields in the document
        data.forEach((key, value) {
          if (value is List) {
            print(
              '   $key: [List with ${value.length} items] ${value.take(2).toList()}...',
            );
          } else {
            print('   $key: $value');
          }
        });
        print('');
      }

      setState(() {
        _dropdownData = allData;
        _status =
            'Found ${querySnapshot.docs.length} documents in dropdown_options';
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error checking dropdown structure: $e');
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
        title: const Text('Debug Existing Dropdown Structure'),
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
            ElevatedButton(
              onPressed: _isLoading ? null : _checkExistingStructure,
              child: const Text('Refresh Structure Check'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dropdown Options Structure:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _dropdownData.isEmpty
                  ? const Center(
                      child: Text(
                        'No data loaded yet',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _dropdownData.length,
                      itemBuilder: (context, index) {
                        final docId = _dropdownData.keys.elementAt(index);
                        final docData =
                            _dropdownData[docId] as Map<String, dynamic>;

                        return Card(
                          child: ExpansionTile(
                            title: Text(
                              'Document: $docId',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('${docData.keys.length} fields'),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: docData.entries.map((entry) {
                                    final key = entry.key;
                                    final value = entry.value;

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$key:',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          if (value is List) ...[
                                            Text(
                                              'List with ${value.length} items:',
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children:
                                                    value
                                                        .take(5)
                                                        .map(
                                                          (item) => Text(
                                                            '• $item',
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        )
                                                        .toList()
                                                      ..add(
                                                        value.length > 5
                                                            ? Text(
                                                                '... and ${value.length - 5} more',
                                                                style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              )
                                                            : const SizedBox.shrink(),
                                                      ),
                                              ),
                                            ),
                                          ] else ...[
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                value.toString(),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
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
