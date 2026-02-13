import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utils/init_sample_dropdown_data.dart';

class TestFirebaseDataScreen extends StatefulWidget {
  const TestFirebaseDataScreen({super.key});

  @override
  State<TestFirebaseDataScreen> createState() => _TestFirebaseDataScreenState();
}

class _TestFirebaseDataScreenState extends State<TestFirebaseDataScreen> {
  String _status = 'Checking Firebase data...';
  Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
    _checkFirebaseData();
  }

  Future<void> _checkFirebaseData() async {
    try {
      setState(() {
        _status = 'Checking dropdown_options collection...';
      });

      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection('dropdown_options').get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _status = 'No data found. Initializing sample data...';
        });

        await InitSampleDropdownData.initializeSampleData();

        setState(() {
          _status = 'Sample data initialized. Rechecking...';
        });

        // Check again
        final newSnapshot = await firestore
            .collection('dropdown_options')
            .get();
        _processSnapshot(newSnapshot);
      } else {
        _processSnapshot(snapshot);
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  void _processSnapshot(QuerySnapshot snapshot) {
    final data = <String, dynamic>{};
    for (final doc in snapshot.docs) {
      final docData = doc.data() as Map<String, dynamic>;
      data[doc.id] = {
        'options': docData['options'] ?? [],
        'count': (docData['options'] as List?)?.length ?? 0,
      };
    }

    setState(() {
      _data = data;
      _status = 'Found ${snapshot.docs.length} dropdown categories';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Data Test'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: $_status',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (_data.isNotEmpty) ...[
              const Text(
                'Dropdown Data:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final key = _data.keys.elementAt(index);
                    final value = _data[key];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              key,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Count: ${value['count']}'),
                            const SizedBox(height: 8),
                            Text('Options: ${value['options'].join(', ')}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _checkFirebaseData,
                    child: const Text('Refresh Data'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _status = 'Reinitializing data...';
                      });
                      await InitSampleDropdownData.initializeSampleData();
                      _checkFirebaseData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Reinitialize'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
