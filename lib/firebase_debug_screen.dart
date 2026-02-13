import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDebugScreen extends StatefulWidget {
  const FirebaseDebugScreen({super.key});

  @override
  State<FirebaseDebugScreen> createState() => _FirebaseDebugScreenState();
}

class _FirebaseDebugScreenState extends State<FirebaseDebugScreen> {
  String _debugOutput = 'Tap "Test Firebase" to start...';
  bool _isLoading = false;

  Future<void> _testFirebase() async {
    setState(() {
      _isLoading = true;
      _debugOutput = 'Testing Firebase...\n';
    });

    try {
      // Test jobCategory document
      await _testJobCategories();

      // Test filter documents
      await _testFilterDocuments();

      // Test jobs collection
      await _testJobsCollection();
    } catch (e) {
      _addToOutput('❌ Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testJobCategories() async {
    _addToOutput('🔍 Testing Job Categories...\n');

    try {
      final doc = await FirebaseFirestore.instance
          .collection('dropdown_options')
          .doc('jobCategory')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _addToOutput('✅ jobCategory document exists');
        _addToOutput('📄 Raw data: $data\n');

        // Show all keys in the document
        _addToOutput('🔑 Document keys: ${data.keys.toList()}\n');

        // Try to find and parse any lists
        for (var key in data.keys) {
          final value = data[key];
          _addToOutput('📋 Field "$key": $value (${value.runtimeType})');

          if (value is List) {
            _addToOutput('   📊 Found list with ${value.length} items:');

            final categories = <String>[];

            for (int i = 0; i < value.length; i++) {
              final item = value[i];
              _addToOutput('     [$i]: $item (${item.runtimeType})');

              String? categoryValue;

              if (item is String && item.isNotEmpty && item != 'null') {
                categoryValue = item;
                _addToOutput('       ✅ Direct string: $categoryValue');
              } else if (item is Map<String, dynamic>) {
                _addToOutput('       🗂️ Map keys: ${item.keys.toList()}');

                // Test parsing logic
                for (var mapKey in ['0', '1', 'value', 'name', 'label']) {
                  if (item.containsKey(mapKey)) {
                    final val = item[mapKey]?.toString();
                    if (val != null && val.isNotEmpty && val != 'null') {
                      categoryValue = val;
                      _addToOutput(
                        '       ✅ Found with key "$mapKey": $categoryValue',
                      );
                      break;
                    }
                  }
                }

                if (categoryValue == null) {
                  // Try first non-null value
                  for (var val in item.values) {
                    final str = val?.toString();
                    if (str != null && str.isNotEmpty && str != 'null') {
                      categoryValue = str;
                      _addToOutput(
                        '       ✅ Found first value: $categoryValue',
                      );
                      break;
                    }
                  }
                }
              }

              if (categoryValue != null) {
                categories.add(categoryValue);
                _addToOutput('       ✅ ADDED: $categoryValue');
              } else {
                _addToOutput('       ❌ Could not extract value');
              }
            }

            _addToOutput('\n🎯 Final categories from "$key": $categories');
            _addToOutput('📊 Total: ${categories.length}\n');

            if (categories.isNotEmpty) {
              _addToOutput(
                '🎉 SUCCESS! These categories would be used in the app.\n',
              );
              return; // Found categories, stop here
            }
          }
        }

        _addToOutput('❌ No usable list found in any field\n');
      } else {
        _addToOutput('❌ jobCategory document does not exist\n');
        _addToOutput('💡 You need to create: /dropdown_options/jobCategory\n');
        _addToOutput(
          '💡 With a structure like: { "options": ["Company Jobs", "Hospital Jobs", ...] }\n',
        );
      }
    } catch (e) {
      _addToOutput('❌ Error testing job categories: $e\n');
    }
  }

  Future<void> _testFilterDocuments() async {
    _addToOutput('🔍 Testing Filter Documents...\n');

    final filterFields = [
      'jobType',
      'department',
      'candidateDepartment',
      'designation',
      'location',
    ];

    for (String field in filterFields) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('dropdown_options')
            .doc(field)
            .get();

        if (doc.exists) {
          final data = doc.data()!;
          _addToOutput('✅ $field exists');

          if (data.containsKey('options')) {
            final options = data['options'] as List<dynamic>;
            _addToOutput('   📊 ${options.length} options');

            // Show first 3 options
            for (int i = 0; i < options.length && i < 3; i++) {
              _addToOutput('     [$i]: ${options[i]}');
            }
          } else {
            // Try to find any list field
            for (var key in data.keys) {
              final value = data[key];
              if (value is List) {
                _addToOutput(
                  '   📊 Found list in "$key": ${value.length} options',
                );
                // Show first 3 options
                for (int i = 0; i < value.length && i < 3; i++) {
                  _addToOutput('     [$i]: ${value[i]}');
                }
                break;
              }
            }
          }
        } else {
          _addToOutput('❌ $field does not exist');
        }
      } catch (e) {
        _addToOutput('❌ Error testing $field: $e');
      }
    }
    _addToOutput('');
  }

  Future<void> _testJobsCollection() async {
    _addToOutput('🔍 Testing Jobs Collection...\n');

    try {
      final jobs = await FirebaseFirestore.instance
          .collection('jobs')
          .where('approvalStatus', isEqualTo: 'approved')
          .limit(3)
          .get();

      _addToOutput('✅ Found ${jobs.docs.length} approved jobs');

      if (jobs.docs.isNotEmpty) {
        final sampleJob = jobs.docs.first.data();
        _addToOutput('📄 Sample job category: ${sampleJob['jobCategory']}');

        // Get unique categories from jobs
        final jobCategories = <String>{};
        for (var doc in jobs.docs) {
          final data = doc.data();
          final category = data['jobCategory']?.toString();
          if (category != null && category.isNotEmpty) {
            jobCategories.add(category);
          }
        }
        _addToOutput('📊 Job categories from jobs: ${jobCategories.toList()}');
      }
    } catch (e) {
      _addToOutput('❌ Error testing jobs: $e');
    }
  }

  void _addToOutput(String text) {
    setState(() {
      _debugOutput += '$text\n';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Debug'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testFirebase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BFF),
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Test Firebase'),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _debugOutput = 'Output cleared...\n';
                    });
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _debugOutput,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
