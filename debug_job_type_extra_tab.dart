import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(home: DebugJobTypeExtraTab()));
}

class DebugJobTypeExtraTab extends StatefulWidget {
  @override
  _DebugJobTypeExtraTabState createState() => _DebugJobTypeExtraTabState();
}

class _DebugJobTypeExtraTabState extends State<DebugJobTypeExtraTab> {
  static const primaryBlue = Color(0xFF007BFF);

  String debugResult = 'Loading Firebase jobType data...';
  List<String> processedCategories = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _debugJobTypeDocument();
  }

  Future<void> _debugJobTypeDocument() async {
    setState(() {
      isLoading = true;
    });

    final results = <String>[];

    results.add('🔍 Debug: Extra "job type" Tab Issue');
    results.add('=====================================\n');

    try {
      results.add('📡 Loading from /dropdown_options/jobType...\n');

      final jobTypeDoc = await FirebaseFirestore.instance
          .collection('dropdown_options')
          .doc('jobType')
          .get();

      if (jobTypeDoc.exists) {
        final data = jobTypeDoc.data();
        results.add('✅ Document exists');
        results.add('📄 Raw Firebase data: $data');
        results.add('📊 Document keys: ${data?.keys.toList()}');
        results.add('📊 Document values: ${data?.values.toList()}\n');

        final firebaseJobTypes = <String>[];

        if (data != null) {
          results.add('🔍 Processing each field:');
          results.add('========================');

          for (var key in data.keys) {
            final value = data[key];
            results.add('\n🔑 Key: "$key"');
            results.add('   Value: "$value"');
            results.add('   Type: ${value.runtimeType}');

            // Check if key should be skipped
            if (key.toLowerCase() == 'jobtype' ||
                key.toLowerCase() == 'job_type' ||
                key.toLowerCase() == 'type') {
              results.add('   ⏭️ SKIPPED: Metadata key');
              continue;
            }

            if (value is String && value.isNotEmpty && value != 'null') {
              final cleanValue = value.trim();
              results.add('   📝 Clean value: "$cleanValue"');

              // Check if value should be skipped
              if (cleanValue.toLowerCase() == 'jobtype' ||
                  cleanValue.toLowerCase() == 'job type' ||
                  cleanValue.toLowerCase() == 'type') {
                results.add('   ⏭️ SKIPPED: Unwanted value');
              } else if (cleanValue.length > 0) {
                firebaseJobTypes.add(cleanValue);
                results.add('   ✅ ADDED: "$cleanValue"');
              } else {
                results.add('   ⏭️ SKIPPED: Empty value');
              }
            } else if (value is List) {
              results.add('   📋 Processing list with ${value.length} items:');
              for (var i = 0; i < value.length; i++) {
                final item = value[i];
                results.add('      [$i]: "$item" (${item.runtimeType})');
                if (item is String && item.isNotEmpty && item != 'null') {
                  final cleanItem = item.trim();
                  if (cleanItem.toLowerCase() != 'jobtype' &&
                      cleanItem.toLowerCase() != 'job type' &&
                      cleanItem.toLowerCase() != 'type' &&
                      cleanItem.length > 0) {
                    firebaseJobTypes.add(cleanItem);
                    results.add('      ✅ ADDED from list: "$cleanItem"');
                  } else {
                    results.add('      ⏭️ SKIPPED from list: "$cleanItem"');
                  }
                }
              }
            } else if (value is Map<String, dynamic>) {
              results.add('   🗂️ Processing nested object:');
              for (var nestedKey in value.keys) {
                final nestedValue = value[nestedKey];
                results.add(
                  '      "$nestedKey": "$nestedValue" (${nestedValue.runtimeType})',
                );
                if (nestedValue is String &&
                    nestedValue.isNotEmpty &&
                    nestedValue != 'null') {
                  final cleanNestedValue = nestedValue.trim();
                  if (cleanNestedValue.toLowerCase() != 'jobtype' &&
                      cleanNestedValue.toLowerCase() != 'job type' &&
                      cleanNestedValue.toLowerCase() != 'type' &&
                      cleanNestedValue.length > 0) {
                    firebaseJobTypes.add(cleanNestedValue);
                    results.add(
                      '      ✅ ADDED from nested: "$cleanNestedValue"',
                    );
                  } else {
                    results.add(
                      '      ⏭️ SKIPPED from nested: "$cleanNestedValue"',
                    );
                  }
                }
              }
            } else {
              results.add(
                '   ⏭️ SKIPPED: Non-string, non-list, non-object value',
              );
            }
          }
        }

        // Process results
        final uniqueJobTypes = firebaseJobTypes.toSet().toList()..sort();

        results.add('\n📊 Processing Summary:');
        results.add('=====================');
        results.add('Raw job types found: ${firebaseJobTypes.length}');
        results.add('Raw list: $firebaseJobTypes');
        results.add('Unique job types: ${uniqueJobTypes.length}');
        results.add('Unique list: $uniqueJobTypes');

        final finalCategories = ['All Jobs', ...uniqueJobTypes];
        results.add('Final categories for UI: $finalCategories');

        setState(() {
          processedCategories = finalCategories;
        });

        results.add('\n🎯 Expected Result:');
        results.add('==================');
        results.add(
          'Based on your data: 0"Full Time"1"mrzi"2"faaltu"3"1 hour"',
        );
        results.add(
          'Should show 5 tabs: All Jobs, 1 hour, Full Time, faaltu, mrzi',
        );
        results.add(
          'If you see 6 tabs, there\'s an extra value being processed.',
        );

        results.add('\n🔧 Troubleshooting:');
        results.add('==================');
        if (finalCategories.length > 5) {
          results.add('❌ ISSUE: More than 5 tabs detected!');
          results.add('Extra tabs: ${finalCategories.sublist(5)}');
          results.add(
            'Check the processing log above to see what\'s being added.',
          );
        } else if (finalCategories.length == 5) {
          results.add('✅ CORRECT: Exactly 5 tabs as expected');
        } else {
          results.add('⚠️ FEWER TABS: Only ${finalCategories.length} tabs');
          results.add('Some data might not be processed correctly.');
        }
      } else {
        results.add('❌ Document does not exist at /dropdown_options/jobType');
      }
    } catch (e) {
      results.add('❌ Error: $e');
    }

    setState(() {
      debugResult = results.join('\n');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Extra Job Type Tab'),
        backgroundColor: primaryBlue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: isLoading
                ? null
                : () {
                    setState(() {
                      debugResult = 'Reloading...';
                      processedCategories.clear();
                    });
                    _debugJobTypeDocument();
                  },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Debug Results
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                debugResult,
                style: TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),

            if (processedCategories.isNotEmpty) ...[
              SizedBox(height: 20),

              // Visual Preview
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: processedCategories.length > 5
                      ? Colors.red[50]
                      : Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: processedCategories.length > 5
                        ? Colors.red[300]!
                        : Colors.green[300]!,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      processedCategories.length > 5
                          ? '❌ Issue Found: ${processedCategories.length} tabs'
                          : '✅ Correct: ${processedCategories.length} tabs',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: processedCategories.length > 5
                            ? Colors.red[800]
                            : Colors.green[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Categories: ${processedCategories.join(', ')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: processedCategories.length > 5
                            ? Colors.red[700]
                            : Colors.green[700],
                      ),
                    ),
                    if (processedCategories.length > 5) ...[
                      SizedBox(height: 8),
                      Text(
                        'Extra tabs: ${processedCategories.sublist(5).join(', ')}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
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
