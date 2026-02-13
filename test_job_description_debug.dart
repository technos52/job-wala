import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(home: JobDescriptionDebugScreen()));
}

class JobDescriptionDebugScreen extends StatefulWidget {
  @override
  _JobDescriptionDebugScreenState createState() =>
      _JobDescriptionDebugScreenState();
}

class _JobDescriptionDebugScreenState extends State<JobDescriptionDebugScreen> {
  String debugResult = 'Loading Firebase job data...';
  List<Map<String, dynamic>> jobs = [];

  @override
  void initState() {
    super.initState();
    _debugJobDescriptions();
  }

  Future<void> _debugJobDescriptions() async {
    final results = <String>[];

    results.add('🔍 Firebase Job Description Debug');
    results.add('==================================\n');

    try {
      // Load jobs from Firebase
      results.add('📡 Connecting to Firebase...');

      final jobsQuery = await FirebaseFirestore.instance
          .collection('jobs')
          .where('approvalStatus', isEqualTo: 'approved')
          .limit(5) // Limit for debugging
          .get();

      results.add('✅ Found ${jobsQuery.docs.length} approved jobs\n');

      if (jobsQuery.docs.isEmpty) {
        results.add('❌ No approved jobs found in Firebase');
        results.add(
          '💡 Check if jobs exist and have approvalStatus = "approved"',
        );
      }

      for (int i = 0; i < jobsQuery.docs.length; i++) {
        final doc = jobsQuery.docs[i];
        final data = doc.data();

        results.add('📄 Job ${i + 1}: ${doc.id}');
        results.add('   Title: ${data['jobTitle'] ?? 'N/A'}');
        results.add('   Company: ${data['companyName'] ?? 'N/A'}');

        // Check all possible description fields
        results.add('   🔍 Checking description fields:');

        final allKeys = data.keys.toList()..sort();
        results.add('   📋 All fields: ${allKeys.join(', ')}');

        // Check specific description fields
        final descriptionFields = [
          'jobDescription',
          'description',
          'job description',
          'job_description',
          'Description',
          'JobDescription',
        ];

        String foundDescription = '';
        String foundField = '';

        for (final field in descriptionFields) {
          if (data.containsKey(field)) {
            final value = data[field]?.toString() ?? '';
            results.add(
              '   ✅ Found "$field": "${value.length > 50 ? value.substring(0, 50) + '...' : value}"',
            );
            if (foundDescription.isEmpty && value.isNotEmpty) {
              foundDescription = value;
              foundField = field;
            }
          } else {
            results.add('   ❌ No "$field" field');
          }
        }

        if (foundDescription.isNotEmpty) {
          results.add(
            '   🎯 Best description from "$foundField": ${foundDescription.length} characters',
          );
        } else {
          results.add('   ⚠️ No description found in any field');
        }

        // Process job data like the app does
        String jobDescription = '';
        if (data.containsKey('jobDescription')) {
          jobDescription = data['jobDescription']?.toString() ?? '';
        } else if (data.containsKey('description')) {
          jobDescription = data['description']?.toString() ?? '';
        } else if (data.containsKey('job description')) {
          jobDescription = data['job description']?.toString() ?? '';
        }

        final processedJob = {
          'id': doc.id,
          'jobTitle': data['jobTitle'] ?? '',
          'companyName': data['companyName'] ?? '',
          'jobDescription': jobDescription,
        };

        jobs.add(processedJob);

        results.add(
          '   📤 Processed description: "${jobDescription.isEmpty ? 'EMPTY' : jobDescription.length.toString() + ' chars'}"',
        );
        results.add('');
      }

      // Test description display logic
      results.add('🎨 Testing Description Display Logic');
      results.add('=====================================');

      for (int i = 0; i < jobs.length; i++) {
        final job = jobs[i];
        final description = job['jobDescription']?.toString() ?? '';

        results.add('\nJob ${i + 1}: ${job['jobTitle']}');
        results.add('Raw description: "${description}"');
        results.add('Is empty: ${description.isEmpty}');
        results.add('Is "null": ${description == 'null'}');

        String displayText;
        if (description.isEmpty || description == 'null') {
          displayText = 'Job description not provided by employer.';
        } else {
          const maxLength = 120;
          final needsTruncation = description.length > maxLength;
          displayText = needsTruncation
              ? '${description.substring(0, maxLength)}...'
              : description;
        }

        results.add('Display text: "$displayText"');
      }

      results.add('\n🔧 Troubleshooting Steps:');
      results.add('========================');
      results.add('1. Check Firebase Console for actual field names');
      results.add('2. Verify job documents have description fields');
      results.add('3. Check if field names have spaces or special characters');
      results.add('4. Ensure approvalStatus is set to "approved"');
      results.add('5. Check if description fields contain actual text');
    } catch (e) {
      results.add('❌ Error loading jobs: $e');
      results.add('\n💡 Possible issues:');
      results.add('- Firebase not initialized');
      results.add('- Network connection problem');
      results.add('- Firestore rules blocking access');
      results.add('- Collection name mismatch');
    }

    setState(() {
      debugResult = results.join('\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Description Debug'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                debugResult = 'Reloading...';
              });
              _debugJobDescriptions();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            if (jobs.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                'Sample Job Cards:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ...jobs.map((job) => _buildJobCard(job)).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    final description = job['jobDescription']?.toString() ?? '';

    String displayText;
    if (description.isEmpty || description == 'null') {
      displayText = 'Job description not provided by employer.';
    } else {
      const maxLength = 120;
      final needsTruncation = description.length > maxLength;
      displayText = needsTruncation
          ? '${description.substring(0, maxLength)}...'
          : description;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['jobTitle'] ?? 'No Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              job['companyName'] ?? 'No Company',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Job Description',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    displayText,
                    style: TextStyle(
                      fontSize: 13,
                      color: description.isEmpty || description == 'null'
                          ? Colors.grey[500]
                          : Colors.grey[600],
                      height: 1.4,
                      fontStyle: description.isEmpty || description == 'null'
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
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
