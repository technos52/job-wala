import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Test widget to verify applicant count functionality
class ApplicantCountTestWidget extends StatefulWidget {
  const ApplicantCountTestWidget({super.key});

  @override
  State<ApplicantCountTestWidget> createState() =>
      _ApplicantCountTestWidgetState();
}

class _ApplicantCountTestWidgetState extends State<ApplicantCountTestWidget> {
  final TextEditingController _jobIdController = TextEditingController();
  int _collectionGroupCount = 0;
  int _individualQueryCount = 0;
  bool _isLoading = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _applications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicant Count Test'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Job ID Input
            TextField(
              controller: _jobIdController,
              decoration: const InputDecoration(
                labelText: 'Enter Job ID to test',
                border: OutlineInputBorder(),
                hintText: 'e.g., job123',
              ),
            ),
            const SizedBox(height: 16),

            // Test Button
            ElevatedButton(
              onPressed: _isLoading ? null : _testApplicantCount,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Test Applicant Count'),
            ),
            const SizedBox(height: 24),

            // Results
            if (_errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Text(
                  'Error: $_errorMessage',
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),

            if (!_isLoading && _errorMessage.isEmpty) ...[
              // Count Results
              Row(
                children: [
                  Expanded(
                    child: _buildCountCard(
                      'Collection Group',
                      _collectionGroupCount,
                      Colors.green,
                      'Fast, efficient method',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCountCard(
                      'Individual Queries',
                      _individualQueryCount,
                      Colors.orange,
                      'Slower, fallback method',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Applications List
              if (_applications.isNotEmpty) ...[
                const Text(
                  'Applications Found:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _applications.length,
                    itemBuilder: (context, index) {
                      final app = _applications[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(app['candidateEmail'] ?? 'Unknown'),
                          subtitle: Text(
                            'Job: ${app['jobTitle'] ?? 'Unknown'}\n'
                            'Applied: ${_formatDate(app['appliedAt'])}',
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],

            // Instructions
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '1. Enter a job ID from your Firestore database\n'
                    '2. Tap "Test Applicant Count" to check both methods\n'
                    '3. Collection Group method should be faster and more reliable\n'
                    '4. Both counts should match if everything is working correctly',
                    style: TextStyle(color: Colors.blue.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountCard(
    String title,
    int count,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: color.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _testApplicantCount() async {
    final jobId = _jobIdController.text.trim();
    if (jobId.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a job ID';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _collectionGroupCount = 0;
      _individualQueryCount = 0;
      _applications = [];
    });

    try {
      // Method 1: Collection Group Query
      debugPrint('🔍 Testing collection group query for job: $jobId');
      final collectionGroupQuery = await FirebaseFirestore.instance
          .collectionGroup('applications')
          .where('jobId', isEqualTo: jobId)
          .get();

      final collectionGroupCount = collectionGroupQuery.docs.length;
      final applications = collectionGroupQuery.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'candidateEmail': data['candidateEmail'],
          'jobTitle': data['jobTitle'],
          'appliedAt': data['appliedAt'],
        };
      }).toList();

      debugPrint(
        '✅ Collection group found: $collectionGroupCount applications',
      );

      // Method 2: Individual Candidate Queries
      debugPrint('🔍 Testing individual candidate queries...');
      final candidatesSnapshot = await FirebaseFirestore.instance
          .collection('candidates')
          .get();

      int individualCount = 0;
      for (final candidateDoc in candidatesSnapshot.docs) {
        try {
          final applicationsQuery = await FirebaseFirestore.instance
              .collection('candidates')
              .doc(candidateDoc.id)
              .collection('applications')
              .where('jobId', isEqualTo: jobId)
              .get();

          individualCount += applicationsQuery.docs.length;
        } catch (e) {
          debugPrint('Error checking candidate ${candidateDoc.id}: $e');
        }
      }

      debugPrint('✅ Individual queries found: $individualCount applications');

      setState(() {
        _collectionGroupCount = collectionGroupCount;
        _individualQueryCount = individualCount;
        _applications = applications;
        _isLoading = false;
      });

      // Show result message
      if (collectionGroupCount == individualCount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Both methods match: $collectionGroupCount applications',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '⚠️ Methods don\'t match: Collection Group ($collectionGroupCount) vs Individual ($individualCount)',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error testing applicant count: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';

    try {
      if (timestamp is Timestamp) {
        final date = timestamp.toDate();
        return '${date.day}/${date.month}/${date.year}';
      }
      return timestamp.toString();
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  void dispose() {
    _jobIdController.dispose();
    super.dispose();
  }
}

/// Test app to run the applicant count test
class ApplicantCountTestApp extends StatelessWidget {
  const ApplicantCountTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Applicant Count Test',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ApplicantCountTestWidget(),
    );
  }
}
