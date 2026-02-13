import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 DEEP RCA: Application Storage Issue');
  print('=====================================\n');

  try {
    // Check if separate documents are being created in job_applications collection
    print('📊 Checking job_applications collection...');
    final jobApplicationsQuery = await FirebaseFirestore.instance
        .collection('job_applications')
        .limit(10)
        .get();

    print(
      'Found ${jobApplicationsQuery.docs.length} documents in job_applications collection',
    );

    if (jobApplicationsQuery.docs.isNotEmpty) {
      print('\n❌ ISSUE FOUND: Separate documents still exist!');
      print('Recent documents in job_applications collection:');

      for (int i = 0; i < jobApplicationsQuery.docs.length; i++) {
        final doc = jobApplicationsQuery.docs[i];
        final data = doc.data();
        print('   ${i + 1}. Document ID: ${doc.id}');
        print('      Job Title: ${data['jobTitle'] ?? 'N/A'}');
        print('      Candidate Email: ${data['candidateEmail'] ?? 'N/A'}');
        print(
          '      Applied At: ${data['appliedAt'] ?? data['appliedDate'] ?? 'N/A'}',
        );
        print('      Created At: ${data['createdAt'] ?? 'N/A'}');
        print('');
      }
    } else {
      print('✅ No separate documents found in job_applications collection');
    }

    // Check candidates collection for proper storage
    print('\n📊 Checking candidates collection...');
    final candidatesQuery = await FirebaseFirestore.instance
        .collection('candidates')
        .limit(5)
        .get();

    print('Found ${candidatesQuery.docs.length} candidate documents');

    for (final doc in candidatesQuery.docs) {
      final data = doc.data();
      final applications = data['applications'] as List? ?? [];

      print('\nCandidate: ${doc.id}');
      print('   Applications in document: ${applications.length}');
      print('   Total applications count: ${data['totalApplications'] ?? 0}');

      if (applications.isNotEmpty) {
        print('   Recent applications:');
        for (int i = 0; i < applications.length.take(3); i++) {
          final app = applications[i];
          print(
            '      ${i + 1}. ${app['jobTitle'] ?? 'N/A'} at ${app['companyName'] ?? 'N/A'}',
          );
        }
      }
    }

    print('\n🔍 ROOT CAUSE ANALYSIS:');
    print('======================');

    if (jobApplicationsQuery.docs.isNotEmpty) {
      print(
        '❌ PROBLEM: Applications are still being saved as separate documents',
      );
      print(
        '   This means there\'s still code creating documents in job_applications collection',
      );
      print('\n🔧 INVESTIGATION NEEDED:');
      print(
        '   1. Check if EnhancedJobApplicationService is being called somewhere',
      );
      print(
        '   2. Look for any other code that writes to job_applications collection',
      );
      print(
        '   3. Check if there are any background processes or cloud functions',
      );
      print(
        '   4. Verify that _applyForJob in simple_candidate_dashboard.dart is being used',
      );
    } else {
      print('✅ GOOD: No separate documents found');
      print('   Applications are being stored correctly in user documents');
    }
  } catch (e) {
    print('❌ Error during investigation: $e');
  }
}
