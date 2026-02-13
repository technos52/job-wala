import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Debug script to check applicant counts and troubleshoot issues
class ApplicantCountDebugger {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Debug method to check applicant count for a specific job
  static Future<void> debugApplicantCount(String jobId) async {
    print('🔍 DEBUGGING APPLICANT COUNT FOR JOB: $jobId');
    print('=' * 50);

    try {
      // Method 1: Collection Group Query (New Method)
      print('\n📊 METHOD 1: Collection Group Query');
      final collectionGroupQuery = await _firestore
          .collectionGroup('applications')
          .where('jobId', isEqualTo: jobId)
          .get();

      print('✅ Collection Group Count: ${collectionGroupQuery.docs.length}');

      if (collectionGroupQuery.docs.isNotEmpty) {
        print('📋 Applications found:');
        for (int i = 0; i < collectionGroupQuery.docs.length; i++) {
          final doc = collectionGroupQuery.docs[i];
          final data = doc.data();
          print(
            '  ${i + 1}. ${data['candidateEmail']} - Applied: ${data['appliedAt']}',
          );
        }
      }

      // Method 2: Individual Candidate Queries (Old Method)
      print('\n📊 METHOD 2: Individual Candidate Queries');
      final candidatesSnapshot = await _firestore
          .collection('candidates')
          .get();

      int individualCount = 0;
      print('👥 Found ${candidatesSnapshot.docs.length} candidate documents');

      for (final candidateDoc in candidatesSnapshot.docs) {
        try {
          final applicationsQuery = await _firestore
              .collection('candidates')
              .doc(candidateDoc.id)
              .collection('applications')
              .where('jobId', isEqualTo: jobId)
              .get();

          if (applicationsQuery.docs.isNotEmpty) {
            print(
              '✅ Candidate ${candidateDoc.id}: ${applicationsQuery.docs.length} applications',
            );
            individualCount += applicationsQuery.docs.length;
          }
        } catch (e) {
          print('❌ Error checking candidate ${candidateDoc.id}: $e');
        }
      }

      print('✅ Individual Query Count: $individualCount');

      // Method 3: Check specific job document
      print('\n📊 METHOD 3: Job Document Check');
      final jobDoc = await _firestore.collection('jobs').doc(jobId).get();

      if (jobDoc.exists) {
        final jobData = jobDoc.data()!;
        final storedCount = jobData['applications'] ?? 0;
        print('✅ Job Document Stored Count: $storedCount');
        print('📋 Job Title: ${jobData['jobTitle']}');
        print('🏢 Company: ${jobData['companyName']}');
        print('👤 Employer ID: ${jobData['employerId']}');
      } else {
        print('❌ Job document not found!');
      }

      // Summary
      print('\n📈 SUMMARY:');
      print('Collection Group Method: ${collectionGroupQuery.docs.length}');
      print('Individual Query Method: $individualCount');
      if (jobDoc.exists) {
        print('Job Document Count: ${jobDoc.data()!['applications'] ?? 0}');
      }
    } catch (e) {
      print('❌ Error during debug: $e');
    }
  }

  /// Check all applications in the system
  static Future<void> debugAllApplications() async {
    print('🔍 DEBUGGING ALL APPLICATIONS IN SYSTEM');
    print('=' * 50);

    try {
      // Get all applications using collection group
      final allApplications = await _firestore
          .collectionGroup('applications')
          .get();

      print('📊 Total applications in system: ${allApplications.docs.length}');

      // Group by job ID
      Map<String, List<Map<String, dynamic>>> applicationsByJob = {};

      for (final doc in allApplications.docs) {
        final data = doc.data();
        final jobId = data['jobId'] as String;

        if (!applicationsByJob.containsKey(jobId)) {
          applicationsByJob[jobId] = [];
        }

        applicationsByJob[jobId]!.add({
          'id': doc.id,
          'candidateEmail': data['candidateEmail'],
          'appliedAt': data['appliedAt'],
          'jobTitle': data['jobTitle'],
        });
      }

      print('\n📋 Applications by Job:');
      applicationsByJob.forEach((jobId, applications) {
        print('Job $jobId: ${applications.length} applications');
        for (final app in applications) {
          print('  - ${app['candidateEmail']} (${app['jobTitle']})');
        }
      });
    } catch (e) {
      print('❌ Error debugging all applications: $e');
    }
  }

  /// Check candidate documents and their applications
  static Future<void> debugCandidateApplications() async {
    print('🔍 DEBUGGING CANDIDATE APPLICATIONS');
    print('=' * 50);

    try {
      final candidatesSnapshot = await _firestore
          .collection('candidates')
          .get();

      print('👥 Found ${candidatesSnapshot.docs.length} candidates');

      for (final candidateDoc in candidatesSnapshot.docs) {
        try {
          final candidateData = candidateDoc.data();
          final email = candidateData['email'] ?? 'No email';

          final applicationsSnapshot = await _firestore
              .collection('candidates')
              .doc(candidateDoc.id)
              .collection('applications')
              .get();

          if (applicationsSnapshot.docs.isNotEmpty) {
            print('\n👤 Candidate: $email (${candidateDoc.id})');
            print('   Applications: ${applicationsSnapshot.docs.length}');

            for (final appDoc in applicationsSnapshot.docs) {
              final appData = appDoc.data();
              print('   - Job: ${appData['jobTitle']} (${appData['jobId']})');
            }
          }
        } catch (e) {
          print('❌ Error checking candidate ${candidateDoc.id}: $e');
        }
      }
    } catch (e) {
      print('❌ Error debugging candidate applications: $e');
    }
  }

  /// Test the stream method
  static Stream<int> testApplicantCountStream(String jobId) async* {
    print('🔄 TESTING APPLICANT COUNT STREAM FOR JOB: $jobId');

    await for (final _ in Stream.periodic(const Duration(seconds: 2))) {
      try {
        final applicationsQuery = await _firestore
            .collectionGroup('applications')
            .where('jobId', isEqualTo: jobId)
            .get();

        final count = applicationsQuery.docs.length;
        print('📊 Stream count for job $jobId: $count');
        yield count;
      } catch (e) {
        print('❌ Stream error: $e');
        yield 0;
      }
    }
  }
}

/// Manual testing instructions
void printTestingInstructions() {
  print('''
🧪 APPLICANT COUNT TESTING INSTRUCTIONS
=======================================

1. BASIC TEST:
   - Apply for a job as a candidate
   - Go to employer dashboard
   - Check if the applicant count shows correctly

2. DEBUG SPECIFIC JOB:
   - Get the job ID from Firestore console
   - Run: ApplicantCountDebugger.debugApplicantCount('your-job-id')

3. DEBUG ALL APPLICATIONS:
   - Run: ApplicantCountDebugger.debugAllApplications()

4. DEBUG CANDIDATE APPLICATIONS:
   - Run: ApplicantCountDebugger.debugCandidateApplications()

5. CHECK FIRESTORE RULES:
   - Ensure collection group queries are allowed
   - Check if employer can read candidate applications

6. COMMON ISSUES:
   - Applications not showing: Check if candidate profile exists
   - Count is 0: Verify job ID matches exactly
   - Slow loading: Collection group query might need indexing
   - Permission errors: Check Firestore security rules

7. FIRESTORE CONSOLE CHECK:
   - Go to Firestore console
   - Navigate to candidates/{userId}/applications
   - Verify applications exist with correct jobId

8. REAL-TIME TESTING:
   - Apply for job in one browser/device
   - Check employer dashboard in another
   - Count should update within 3 seconds
''');
}
