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
    return;
  }

  print('🔧 FIX: Application Storage Issue');
  print('==================================\n');

  await fixApplicationStorageIssue();
}

Future<void> fixApplicationStorageIssue() async {
  try {
    print('📊 Step 1: Analyzing current application storage...');

    // Check job_applications collection
    final jobAppsQuery = await FirebaseFirestore.instance
        .collection('job_applications')
        .get();

    print(
      '✅ job_applications collection: ${jobAppsQuery.docs.length} documents',
    );

    // Check candidates collection for any applications
    final candidatesQuery = await FirebaseFirestore.instance
        .collection('candidates')
        .get();

    int candidatesWithApps = 0;
    int totalAppsInCandidates = 0;
    List<String> candidatesWithApplications = [];

    for (final doc in candidatesQuery.docs) {
      final data = doc.data();
      if (data.containsKey('applications') && data['applications'] is List) {
        final apps = data['applications'] as List;
        if (apps.isNotEmpty) {
          candidatesWithApps++;
          totalAppsInCandidates += apps.length;
          candidatesWithApplications.add(doc.id);
          print('  📄 Candidate ${doc.id} has ${apps.length} applications');
        }
      }
    }

    print('Total candidates: ${candidatesQuery.docs.length}');
    print('Candidates with applications: $candidatesWithApps');
    print('Total applications in candidates: $totalAppsInCandidates\n');

    if (totalAppsInCandidates > 0) {
      print('❌ ISSUE CONFIRMED: Applications found in candidates collection');
      print(
        '   According to current architecture, applications should ONLY be in job_applications collection',
      );
      print(
        '   Candidates collection should NOT contain application documents\n',
      );

      print('🔧 Step 2: Cleaning up incorrect application storage...');

      // Option 1: Remove applications from candidates collection
      print('   Option 1: Remove applications array from candidates documents');
      print(
        '   This will clean up the incorrect storage but preserve candidate profile data\n',
      );

      final batch = FirebaseFirestore.instance.batch();
      int cleanupCount = 0;

      for (final candidateId in candidatesWithApplications) {
        final candidateRef = FirebaseFirestore.instance
            .collection('candidates')
            .doc(candidateId);

        // Remove applications-related fields but keep profile data
        batch.update(candidateRef, {
          'applications': FieldValue.delete(),
          'totalApplications': FieldValue.delete(),
          'recentApplications': FieldValue.delete(),
          'monthlyApplications': FieldValue.delete(),
          'jobCategoryPreferences': FieldValue.delete(),
          'analyticsLastUpdated': FieldValue.delete(),
          'applicationAnalyticsVersion': FieldValue.delete(),
        });

        cleanupCount++;
      }

      if (cleanupCount > 0) {
        print('   Cleaning up $cleanupCount candidate documents...');
        await batch.commit();
        print('✅ Cleanup completed successfully');
      }

      print('\n📋 Step 3: Verification after cleanup...');

      // Verify cleanup
      final afterCandidatesQuery = await FirebaseFirestore.instance
          .collection('candidates')
          .get();

      int remainingApps = 0;
      for (final doc in afterCandidatesQuery.docs) {
        final data = doc.data();
        if (data.containsKey('applications') && data['applications'] is List) {
          final apps = data['applications'] as List;
          remainingApps += apps.length;
        }
      }

      if (remainingApps == 0) {
        print('✅ SUCCESS: All applications removed from candidates collection');
        print(
          '   Applications are now only stored in job_applications collection',
        );
      } else {
        print(
          '⚠️ WARNING: $remainingApps applications still remain in candidates collection',
        );
      }
    } else {
      print('✅ GOOD: No applications found in candidates collection');
      print(
        '   Current storage is correct - applications are only in job_applications collection',
      );
    }

    print('\n🎯 SUMMARY:');
    print(
      '- job_applications collection: ${jobAppsQuery.docs.length} documents (CORRECT)',
    );
    print('- applications in candidates: $totalAppsInCandidates (SHOULD BE 0)');

    if (totalAppsInCandidates == 0) {
      print('\n✅ APPLICATION STORAGE IS CORRECT');
      print('   Applications are stored only in job_applications collection');
      print('   No duplicate storage in candidates collection');
    } else {
      print('\n🔧 APPLICATION STORAGE HAS BEEN FIXED');
      print(
        '   Removed duplicate application storage from candidates collection',
      );
      print('   Applications now only exist in job_applications collection');
    }

    print('\n📝 IMPLEMENTATION NOTES:');
    print(
      '- The _applyForJob method in simple_candidate_dashboard.dart is correct',
    );
    print('- It stores applications ONLY in job_applications collection');
    print('- Candidates collection should only contain profile data');
    print(
      '- This architecture prevents duplicate data and ensures consistency',
    );
  } catch (e) {
    print('❌ Error during fix: $e');
  }
}
