import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(home: DynamicJobCategoriesTest()));
}

class DynamicJobCategoriesTest extends StatefulWidget {
  @override
  _DynamicJobCategoriesTestState createState() =>
      _DynamicJobCategoriesTestState();
}

class _DynamicJobCategoriesTestState extends State<DynamicJobCategoriesTest> {
  static const primaryBlue = Color(0xFF007BFF);

  String testResult = 'Loading Firebase jobType data...';
  List<String> jobCategories = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _testJobCategoryLoading();
  }

  Future<void> _testJobCategoryLoading() async {
    setState(() {
      isLoading = true;
    });

    final results = <String>[];

    results.add('🧪 Testing Dynamic Job Categories');
    results.add('===================================\n');

    try {
      results.add('📡 Connecting to Firebase...');
      results.add('📍 Path: /dropdown_options/jobType\n');

      // Load from /dropdown_options/jobType
      final jobTypeDoc = await FirebaseFirestore.instance
          .collection('dropdown_options')
          .doc('jobType')
          .get();

      if (jobTypeDoc.exists) {
        final data = jobTypeDoc.data();
        results.add('✅ jobType document found');
        results.add('📄 Raw data: $data\n');

        final firebaseJobTypes = <String>[];

        if (data != null) {
          results.add('🔍 Extracting job types from document:');

          // Extract all values from the document
          for (var key in data.keys) {
            final value = data[key];
            results.add('   Key "$key": $value (${value.runtimeType})');

            if (value is String && value.isNotEmpty && value != 'null') {
              firebaseJobTypes.add(value);
              results.add('   ✅ Added: $value');
            } else if (value is List) {
              results.add('   📋 Processing list with ${value.length} items:');
              for (var item in value) {
                if (item is String && item.isNotEmpty && item != 'null') {
                  firebaseJobTypes.add(item);
                  results.add('      ✅ Added from list: $item');
                }
              }
            } else if (value is Map<String, dynamic>) {
              results.add('   🗂️ Processing nested object:');
              for (var nestedKey in value.keys) {
                final nestedValue = value[nestedKey];
                results.add('      Nested "$nestedKey": $nestedValue');
                if (nestedValue is String &&
                    nestedValue.isNotEmpty &&
                    nestedValue != 'null') {
                  firebaseJobTypes.add(nestedValue);
                  results.add('      ✅ Added from nested: $nestedValue');
                }
              }
            }
          }
        }

        // Remove duplicates and sort
        final uniqueJobTypes = firebaseJobTypes.toSet().toList()..sort();

        results.add('\n📊 Processing Results:');
        results.add('Raw job types found: ${firebaseJobTypes.length}');
        results.add('Unique job types: ${uniqueJobTypes.length}');
        results.add('Final list: $uniqueJobTypes');

        if (uniqueJobTypes.isNotEmpty) {
          setState(() {
            jobCategories = ['All Jobs', ...uniqueJobTypes];
          });

          results.add('\n✅ SUCCESS: Job categories loaded');
          results.add('Categories for UI: $jobCategories');
        } else {
          results.add('\n⚠️ No valid job types found');
          results.add('Falling back to "All Jobs" only');
          setState(() {
            jobCategories = ['All Jobs'];
          });
        }
      } else {
        results.add('❌ jobType document does not exist');
        results.add('📍 Check if /dropdown_options/jobType exists in Firebase');
        setState(() {
          jobCategories = ['All Jobs'];
        });
      }

      results.add('\n🔧 Implementation Details:');
      results.add('========================');
      results.add('✅ Loads from /dropdown_options/jobType (not jobCategory)');
      results.add('✅ Handles String, List, and nested Map values');
      results.add('✅ Removes duplicates and sorts alphabetically');
      results.add('✅ Always includes "All Jobs" as first tab');
      results.add('✅ Falls back to "All Jobs" only if no data found');

      results.add('\n🎯 Expected Firebase Structure:');
      results.add('==============================');
      results.add('/dropdown_options/jobType:');
      results.add('{');
      results.add('  "0": "Full Time",');
      results.add('  "1": "Part Time", ');
      results.add('  "2": "Contract",');
      results.add('  "3": "Freelance"');
      results.add('}');
      results.add('\nOR as array:');
      results.add('{');
      results.add('  "types": ["Full Time", "Part Time", "Contract"]');
      results.add('}');
    } catch (e) {
      results.add('❌ Error loading job types: $e');
      results.add('\n💡 Possible issues:');
      results.add('- Firebase not initialized');
      results.add('- Network connection problem');
      results.add('- Firestore rules blocking access');
      results.add('- Document path incorrect');

      setState(() {
        jobCategories = ['All Jobs'];
      });
    }

    setState(() {
      testResult = results.join('\n');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Job Categories Test'),
        backgroundColor: primaryBlue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: isLoading
                ? null
                : () {
                    setState(() {
                      testResult = 'Refreshing...';
                      jobCategories.clear();
                    });
                    _testJobCategoryLoading();
                  },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test Results
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                testResult,
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),

            if (jobCategories.isNotEmpty) ...[
              SizedBox(height: 20),

              // Job Categories Preview
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Job Categories Preview',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        if (isLoading)
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                primaryBlue,
                              ),
                            ),
                          )
                        else
                          Icon(Icons.refresh, color: primaryBlue),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Found ${jobCategories.length} categories:',
                      style: TextStyle(fontSize: 14, color: Colors.blue[700]),
                    ),
                    SizedBox(height: 8),

                    // Category Tabs Preview
                    Container(
                      height: 95,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: jobCategories.length,
                        itemBuilder: (context, index) {
                          final category = jobCategories[index];
                          final isSelected =
                              index == 0; // First one selected for demo

                          return Container(
                            width: 110,
                            margin: EdgeInsets.only(right: 12),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryBlue
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? primaryBlue
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.work_outline,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                      size: 22,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Expanded(
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? primaryBlue
                                            : Colors.grey.shade700,
                                        height: 1.1,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    height: 2,
                                    width: isSelected ? 30 : 0,
                                    decoration: BoxDecoration(
                                      color: primaryBlue,
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 20),

            // Instructions
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✅ Dynamic Job Categories Implementation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Categories load from /dropdown_options/jobType\n'
                    '• Refresh button updates data dynamically\n'
                    '• Tabs show only what exists in Firebase\n'
                    '• Auto-refreshes every 5 minutes\n'
                    '• Falls back to "All Jobs" if no data',
                    style: TextStyle(fontSize: 14, color: Colors.green[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
