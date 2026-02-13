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

  print('🔍 TRACE: Application Submission Flow');
  print('====================================\n');

  await traceApplicationFlow();
}

Future<void> traceApplicationFlow() async {
  try {
    print('📊 Step 1: Current state before any application...');

    // Check current state of job_applications collection
    final beforeJobApps = await FirebaseFirestore.instance
        .collection('job_applications')
        .get();

    print(
      'job_applications collection: ${beforeJobApps.docs.length} documents',
    );

    // Check current state of candidates collection
    final beforeCandidates = await FirebaseFirestore.instance
        .collection('candidates')
        .where('applications', isNotEqualTo: null)
        .get();

    int totalUserApps = 0;
    for (final doc in beforeCandidates.docs) {
      final data = doc.data();
      final apps = data['applications'] as List? ?? [];
      totalUserApps += apps.length;
    }

    print('candidates with applications: ${beforeCandidates.docs.length}');
    print('total applications in user docs: $totalUserApps\n');

    print('📊 Step 2: Monitoring for new documents...');
    print('Apply for a job now using the app, then check results.\n');

    // Set up listeners to detect new documents
    final jobAppsListener = FirebaseFirestore.instance
        .collection('job_applications')
        .snapshots()
        .listen((snapshot) {
          for (final change in snapshot.docChanges) {
            if (change.type == DocumentChangeType.added) {
              print('🚨 NEW SEPARATE DOCUMENT DETECTED!');
              print('   Collection: job_applications');
              print('   Document ID: ${change.doc.id}');
              print('   Data: ${change.doc.data()}');
              print('   This should NOT happen!\n');
            }
          }
        });

    final candidatesListener = FirebaseFirestore.instance
        .collection('candidates')
        .snapshots()
        .listen((snapshot) {
          for (final change in snapshot.docChanges) {
            if (change.type == DocumentChangeType.modified) {
              final data = change.doc.data() as Map<String, dynamic>?;
              if (data != null && data.containsKey('applications')) {
                print('✅ USER DOCUMENT UPDATED (Correct behavior)');
                print('   Collection: candidates');
                print('   Document ID: ${change.doc.id}');
                print(
                  '   Applications count: ${(data['applications'] as List?)?.length ?? 0}',
                );
                print(
                  '   Total applications: ${data['totalApplications'] ?? 0}\n',
                );
              }
            }
          }
        });

    print('🎯 Listeners active - apply for a job now...');
    print('Press Ctrl+C to stop monitoring\n');

    // Keep the listeners active
    await Future.delayed(const Duration(minutes: 5));

    jobAppsListener.cancel();
    candidatesListener.cancel();

    print('📊 Step 3: Final state check...');

    final afterJobApps = await FirebaseFirestore.instance
        .collection('job_applications')
        .get();

    final afterCandidates = await FirebaseFirestore.instance
        .collection('candidates')
        .where('applications', isNotEqualTo: null)
        .get();

    int finalUserApps = 0;
    for (final doc in afterCandidates.docs) {
      final data = doc.data();
      final apps = data['applications'] as List? ?? [];
      finalUserApps += apps.length;
    }

    print(
      'Final job_applications collection: ${afterJobApps.docs.length} documents',
    );
    print('Final candidates with applications: ${afterCandidates.docs.length}');
    print('Final total applications in user docs: $finalUserApps');

    final newSeparateDocs =
        afterJobApps.docs.length - beforeJobApps.docs.length;
    final newUserApps = finalUserApps - totalUserApps;

    print('\n📈 Changes detected:');
    print('New separate documents: $newSeparateDocs');
    print('New user document applications: $newUserApps');

    if (newSeparateDocs > 0) {
      print('\n❌ ISSUE CONFIRMED: Separate documents are still being created!');
      print('   This means there\'s still code creating separate documents.');
      print('   Need to investigate further...');

      // Show the new separate documents
      print('\n🔍 New separate documents:');
      for (
        int i = beforeJobApps.docs.length;
        i < afterJobApps.docs.length;
        i++
      ) {
        final doc = afterJobApps.docs[i];
        final data = doc.data();
        print('   Document ${i + 1}: ${doc.id}');
        print('      Job: ${data['jobTitle'] ?? 'N/A'}');
        print(
          '      Candidate: ${data['candidateEmail'] ?? data['candidateId'] ?? 'N/A'}',
        );
        print(
          '      Applied: ${data['appliedAt'] ?? data['appliedDate'] ?? 'N/A'}',
        );
      }
    } else if (newUserApps > 0) {
      print('\n✅ SUCCESS: Applications stored correctly in user documents!');
      print('   No separate documents created.');
    } else {
      print('\n⚠️ No new applications detected during monitoring period.');
    }
  } catch (e) {
    print('❌ Error during tracing: $e');
  }
}
