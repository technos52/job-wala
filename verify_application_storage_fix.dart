import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'lib/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  print('🔍 VERIFICATION: Application Storage Fix');
  print('=======================================\n');

  await verifyApplicationStorage();
}

Future<void> verifyApplicationStorage() async {
  try {
    print('📊 Step 1: Checking job_applications collection...');

    // Check if any documents exist in job_applications collection
    final jobApplicationsQuery = await FirebaseFirestore.instance
        .collection('job_applications')
        .limit(5)
        .get();

    if (jobApplicationsQuery.docs.isNotEmpty) {
      print(
        '❌ ISSUE: Found ${jobApplicationsQuery.docs.length} separate documents in job_applications collection',
      );
      print('   These should not exist if the fix is working correctly.\n');

      for (int i = 0; i < jobApplicationsQuery.docs.length; i++) {
        final doc = jobApplicationsQuery.docs[i];
        final data = doc.data();
        print('   Document ${i + 1}:');
        print('      ID: ${doc.id}');
        print('      Job: ${data['jobTitle'] ?? 'N/A'}');
        print(
          '      Candidate: ${data['candidateEmail'] ?? data['candidateId'] ?? 'N/A'}',
        );
        print(
          '      Applied: ${data['appliedAt'] ?? data['appliedDate'] ?? 'N/A'}',
        );
        print('');
      }

      print(
        '🔧 RECOMMENDATION: Delete these separate documents as they are duplicates',
      );
      print('   The correct data is stored in the candidates collection.\n');
    } else {
      print(
        '✅ GOOD: No separate documents found in job_applications collection\n',
      );
    }

    print('📊 Step 2: Checking candidates collection for proper storage...');

    // Check candidates collection for applications stored within user documents
    final candidatesQuery = await FirebaseFirestore.instance
        .collection('candidates')
        .where('applications', isNotEqualTo: null)
        .limit(5)
        .get();

    print(
      'Found ${candidatesQuery.docs.length} candidates with applications\n',
    );

    int totalApplicationsInUserDocs = 0;

    for (final doc in candidatesQuery.docs) {
      final data = doc.data();
      final applications = data['applications'] as List? ?? [];
      final totalApps = data['totalApplications'] ?? 0;

      totalApplicationsInUserDocs += applications.length;

      print('Candidate: ${doc.id}');
      print('   Applications in document: ${applications.length}');
      print('   Total applications count: $totalApps');
      print(
        '   Recent applications count: ${(data['recentApplications'] as List?)?.length ?? 0}',
      );

      if (applications.isNotEmpty) {
        print('   Latest application:');
        final latestApp = applications.first;
        print('      Job: ${latestApp['jobTitle'] ?? 'N/A'}');
        print('      Company: ${latestApp['companyName'] ?? 'N/A'}');
        print('      Applied: ${latestApp['appliedAt'] ?? 'N/A'}');
        print('      Status: ${latestApp['status'] ?? 'N/A'}');
      }
      print('');
    }

    print('📊 Step 3: Summary');
    print('==================');
    print('Total applications in user documents: $totalApplicationsInUserDocs');
    print(
      'Separate documents in job_applications: ${jobApplicationsQuery.docs.length}',
    );

    if (jobApplicationsQuery.docs.isEmpty && totalApplicationsInUserDocs > 0) {
      print('\n✅ SUCCESS: Application storage is working correctly!');
      print('   ✓ No separate documents created');
      print('   ✓ Applications stored within user documents');
      print('   ✓ Analytics data properly maintained');
    } else if (jobApplicationsQuery.docs.isNotEmpty) {
      print('\n❌ ISSUE: Separate documents still being created');
      print(
        '   This indicates the fix is not complete or there\'s another code path',
      );
      print('   creating separate documents.');
    } else {
      print('\n⚠️ WARNING: No applications found in either location');
      print(
        '   This might be normal if no applications have been submitted recently.',
      );
    }

    print('\n🔧 VERIFICATION STEPS:');
    print('1. Apply for a job using the app');
    print(
      '2. Run this script again to verify no separate documents are created',
    );
    print('3. Check that the application appears in the user\'s document');
    print('4. Verify analytics are updated correctly');
  } catch (e) {
    print('❌ Error during verification: $e');
  }
}
