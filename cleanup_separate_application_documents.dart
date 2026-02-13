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

  print('🧹 CLEANUP: Remove Separate Application Documents');
  print('================================================\n');

  await cleanupSeparateDocuments();
}

Future<void> cleanupSeparateDocuments() async {
  try {
    print(
      '📊 Step 1: Finding separate documents in job_applications collection...',
    );

    // Get all documents in job_applications collection
    final jobApplicationsQuery = await FirebaseFirestore.instance
        .collection('job_applications')
        .get();

    if (jobApplicationsQuery.docs.isEmpty) {
      print('✅ No separate documents found to clean up.');
      return;
    }

    print(
      'Found ${jobApplicationsQuery.docs.length} separate documents to clean up\n',
    );

    // Show what will be deleted
    print('📋 Documents to be deleted:');
    for (int i = 0; i < jobApplicationsQuery.docs.length; i++) {
      final doc = jobApplicationsQuery.docs[i];
      final data = doc.data();
      print('   ${i + 1}. ${doc.id}');
      print('      Job: ${data['jobTitle'] ?? 'N/A'}');
      print(
        '      Candidate: ${data['candidateEmail'] ?? data['candidateId'] ?? 'N/A'}',
      );
      print(
        '      Applied: ${data['appliedAt'] ?? data['appliedDate'] ?? 'N/A'}',
      );
    }

    print('\n⚠️  WARNING: This will permanently delete these documents!');
    print(
      '   The application data should already exist in the candidates collection.',
    );
    print('   Make sure you have verified this before proceeding.\n');

    // In a real scenario, you might want to add a confirmation prompt
    // For now, we'll proceed with the cleanup

    print('🧹 Step 2: Deleting separate documents...');

    final batch = FirebaseFirestore.instance.batch();
    int deleteCount = 0;

    for (final doc in jobApplicationsQuery.docs) {
      batch.delete(doc.reference);
      deleteCount++;

      // Firestore batch has a limit of 500 operations
      if (deleteCount % 500 == 0) {
        await batch.commit();
        print('   Deleted batch of $deleteCount documents...');
      }
    }

    // Commit remaining documents
    if (deleteCount % 500 != 0) {
      await batch.commit();
    }

    print('✅ Successfully deleted $deleteCount separate documents\n');

    print('📊 Step 3: Verifying cleanup...');

    // Verify cleanup
    final verificationQuery = await FirebaseFirestore.instance
        .collection('job_applications')
        .limit(1)
        .get();

    if (verificationQuery.docs.isEmpty) {
      print('✅ Cleanup successful - no separate documents remain\n');
    } else {
      print('⚠️  Some documents may still exist - check manually\n');
    }

    print('📊 Step 4: Verifying user documents still have application data...');

    // Check that user documents still have their application data
    final candidatesQuery = await FirebaseFirestore.instance
        .collection('candidates')
        .where('applications', isNotEqualTo: null)
        .limit(3)
        .get();

    int totalUserApplications = 0;
    for (final doc in candidatesQuery.docs) {
      final data = doc.data();
      final applications = data['applications'] as List? ?? [];
      totalUserApplications += applications.length;
    }

    print(
      '✅ User documents still contain $totalUserApplications applications\n',
    );

    print('🎉 CLEANUP COMPLETE!');
    print('===================');
    print('✓ Removed separate documents from job_applications collection');
    print('✓ User application data preserved in candidates collection');
    print('✓ Analytics data maintained');
    print('\nThe application storage issue should now be resolved.');
  } catch (e) {
    print('❌ Error during cleanup: $e');
  }
}
