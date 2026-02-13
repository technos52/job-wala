// Comprehensive debug tool for red dot notification system
// This will help identify exactly why the red dot is not appearing

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MaterialApp(home: RedDotDebugScreen()));
}

class RedDotDebugScreen extends StatefulWidget {
  @override
  _RedDotDebugScreenState createState() => _RedDotDebugScreenState();
}

class _RedDotDebugScreenState extends State<RedDotDebugScreen> {
  String _debugLog = '';
  bool _hasNewApplications = false;
  Map<String, int> _applicantCounts = {};
  Map<String, int> _newApplicationCounts = {};
  Map<String, DateTime> _lastViewedTimes = {};

  @override
  void initState() {
    super.initState();
    _runComprehensiveDebug();
  }

  void _log(String message) {
    setState(() {
      _debugLog += '$message\n';
    });
    print(message);
  }

  Future<void> _runComprehensiveDebug() async {
    _log('🔍 COMPREHENSIVE RED DOT DEBUG STARTED');
    _log('=====================================');

    await _checkUserAuthentication();
    await _checkJobsExist();
    await _checkApplicationsExist();
    await _checkLastViewedTimes();
    await _simulateRedDotLogic();

    _log('');
    _log('🎯 FINAL DIAGNOSIS:');
    _log('==================');
    _log('Has New Applications: $_hasNewApplications');
    _log('Should Show Red Dot: ${_hasNewApplications ? "YES" : "NO"}');
  }

  Future<void> _checkUserAuthentication() async {
    _log('');
    _log('1️⃣ CHECKING USER AUTHENTICATION');
    _log('--------------------------------');

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _log('❌ ERROR: User not authenticated');
      return;
    }

    _log('✅ User authenticated: ${user.uid}');
    _log('📧 Email: ${user.email}');
  }

  Future<void> _checkJobsExist() async {
    _log('');
    _log('2️⃣ CHECKING EMPLOYER JOBS');
    _log('-------------------------');

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final jobsSnapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where('employerId', isEqualTo: user.uid)
          .get();

      _log('📊 Total jobs found: ${jobsSnapshot.docs.length}');

      if (jobsSnapshot.docs.isEmpty) {
        _log('❌ ERROR: No jobs found for this employer');
        _log('💡 TIP: Create a job first to test red dot functionality');
        return;
      }

      for (final jobDoc in jobsSnapshot.docs) {
        final jobData = jobDoc.data();
        _log('📋 Job: ${jobData['title']} (ID: ${jobDoc.id})');
        _log('   Status: ${jobData['status']}');
        _log('   Created: ${jobData['createdAt']}');
      }
    } catch (e) {
      _log('❌ ERROR checking jobs: $e');
    }
  }

  Future<void> _checkApplicationsExist() async {
    _log('');
    _log('3️⃣ CHECKING APPLICATIONS IN SUBCOLLECTIONS');
    _log('------------------------------------------');

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Get all jobs for this employer
      final jobsSnapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where('employerId', isEqualTo: user.uid)
          .get();

      int totalApplications = 0;

      for (final jobDoc in jobsSnapshot.docs) {
        final jobId = jobDoc.id;
        final jobTitle = jobDoc.data()['title'];
        int jobApplicationCount = 0;

        _log('');
        _log('🔍 Checking applications for job: $jobTitle');

        // Get all candidates
        final candidatesSnapshot = await FirebaseFirestore.instance
            .collection('candidates')
            .get();

        _log('👥 Total candidates to check: ${candidatesSnapshot.docs.length}');

        // Check each candidate's applications subcollection
        for (final candidateDoc in candidatesSnapshot.docs) {
          try {
            final applicationsQuery = await FirebaseFirestore.instance
                .collection('candidates')
                .doc(candidateDoc.id)
                .collection('applications')
                .where('jobId', isEqualTo: jobId)
                .get();

            if (applicationsQuery.docs.isNotEmpty) {
              _log(
                '   📝 Candidate ${candidateDoc.id}: ${applicationsQuery.docs.length} applications',
              );

              for (final appDoc in applicationsQuery.docs) {
                final appData = appDoc.data();
                _log('      - Applied at: ${appData['appliedAt']}');
                _log('      - Status: ${appData['status'] ?? 'pending'}');
              }
            }

            jobApplicationCount += applicationsQuery.docs.length;
          } catch (e) {
            _log('   ❌ Error checking candidate ${candidateDoc.id}: $e');
          }
        }

        _applicantCounts[jobId] = jobApplicationCount;
        totalApplications += jobApplicationCount;

        _log('📊 Total applications for "$jobTitle": $jobApplicationCount');
      }

      _log('');
      _log('📈 TOTAL APPLICATIONS ACROSS ALL JOBS: $totalApplications');

      if (totalApplications == 0) {
        _log('❌ ERROR: No applications found');
        _log('💡 TIP: Have a candidate apply for a job to test red dot');
      }
    } catch (e) {
      _log('❌ ERROR checking applications: $e');
    }
  }

  Future<void> _checkLastViewedTimes() async {
    _log('');
    _log('4️⃣ CHECKING LAST VIEWED TIMES');
    _log('-----------------------------');

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('employers')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        final lastViewedData =
            data?['lastViewedTimes'] as Map<String, dynamic>?;

        if (lastViewedData != null) {
          _log('📅 Last viewed times found:');
          lastViewedData.forEach((jobId, timestamp) {
            final dateTime = (timestamp as Timestamp).toDate();
            _lastViewedTimes[jobId] = dateTime;
            _log('   Job $jobId: $dateTime');
          });
        } else {
          _log('📅 No last viewed times found (first time user)');
          // Set default old dates for all jobs
          _applicantCounts.keys.forEach((jobId) {
            _lastViewedTimes[jobId] = DateTime(2020);
          });
        }
      } else {
        _log('📅 No employer document found');
      }
    } catch (e) {
      _log('❌ ERROR checking last viewed times: $e');
    }
  }

  Future<void> _simulateRedDotLogic() async {
    _log('');
    _log('5️⃣ SIMULATING RED DOT LOGIC');
    _log('---------------------------');

    try {
      bool hasAnyNewApplications = false;
      _newApplicationCounts.clear();

      for (final jobId in _applicantCounts.keys) {
        final lastViewed = _lastViewedTimes[jobId] ?? DateTime(2020);
        _log('');
        _log('🔍 Checking job: $jobId');
        _log('   Last viewed: $lastViewed');

        int newCount = 0;

        // Get all candidates
        final candidatesSnapshot = await FirebaseFirestore.instance
            .collection('candidates')
            .get();

        // Check each candidate's applications since last viewed
        for (final candidateDoc in candidatesSnapshot.docs) {
          try {
            final applicationsQuery = await FirebaseFirestore.instance
                .collection('candidates')
                .doc(candidateDoc.id)
                .collection('applications')
                .where('jobId', isEqualTo: jobId)
                // TEMPORARY FIX: Remove appliedAt filter to avoid index requirement
                // .where(
                //   'appliedAt',
                //   isGreaterThan: Timestamp.fromDate(lastViewed),
                // )
                .get();

            if (applicationsQuery.docs.isNotEmpty) {
              // TEMPORARY FIX: Filter on client side until index is built
              final newApplications = applicationsQuery.docs.where((doc) {
                final appData = doc.data();
                final appliedAt = (appData['appliedAt'] as Timestamp).toDate();
                return appliedAt.isAfter(lastViewed);
              }).toList();

              if (newApplications.isNotEmpty) {
                _log(
                  '   📝 New applications from ${candidateDoc.id}: ${newApplications.length}',
                );
                for (final appDoc in newApplications) {
                  final appData = appDoc.data();
                  final appliedAt = (appData['appliedAt'] as Timestamp)
                      .toDate();
                  _log('      - Applied at: $appliedAt (NEW!)');
                }
                newCount += newApplications.length;
              }
            }
          } catch (e) {
            _log('   ❌ Error checking new applications: $e');
          }
        }

        _newApplicationCounts[jobId] = newCount;
        _log('   🆕 New applications count: $newCount');

        if (newCount > 0) {
          hasAnyNewApplications = true;
          _log('   🔴 This job should show red dot!');
        } else {
          _log('   ⚪ No new applications for this job');
        }
      }

      _hasNewApplications = hasAnyNewApplications;

      _log('');
      _log(
        '🔴 FINAL RED DOT STATUS: ${hasAnyNewApplications ? "SHOW" : "HIDE"}',
      );

      if (!hasAnyNewApplications) {
        _log('');
        _log('💡 POSSIBLE REASONS RED DOT NOT SHOWING:');
        _log('   1. No applications exist at all');
        _log('   2. All applications were applied before last viewed time');
        _log('   3. Last viewed times are too recent');
        _log('   4. Applications are in wrong collection structure');
      }
    } catch (e) {
      _log('❌ ERROR in red dot logic: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Red Dot Debug'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                Text(
                  'Red Dot Status: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _hasNewApplications ? Colors.red : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text(_hasNewApplications ? 'SHOULD SHOW' : 'SHOULD HIDE'),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(
                _debugLog,
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _debugLog = '';
                });
                _runComprehensiveDebug();
              },
              child: Text('Run Debug Again'),
            ),
          ),
        ],
      ),
    );
  }
}
