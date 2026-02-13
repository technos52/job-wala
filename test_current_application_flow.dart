import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Testing Current Application Flow');
  print('=====================================\n');

  try {
    // Check current state of collections
    print('📊 Step 1: Checking current state of collections...');

    final jobAppsQuery = await FirebaseFirestore.instance
        .collection('job_applications')
        .get();

    print('Current job_applications documents: ${jobAppsQuery.docs.length}');

    final candidatesQuery = await FirebaseFirestore.instance
        .collection('candidates')
        .get();

    print('Current candidates documents: ${candidatesQuery.docs.length}');

    // Check if any candidates have applications array
    int candidatesWithApps = 0;
    int totalAppsInCandidates = 0;

    for (final doc in candidatesQuery.docs) {
      final data = doc.data();
      if (data.containsKey('applications') && data['applications'] is List) {
        final apps = data['applications'] as List;
        if (apps.isNotEmpty) {
          candidatesWithApps++;
          totalAppsInCandidates += apps.length;
          print('  📄 Candidate ${doc.id} has ${apps.length} applications');
        }
      }
    }

    print('Candidates with applications: $candidatesWithApps');
    print(
      'Total applications in candidates collection: $totalAppsInCandidates\n',
    );

    print('🎯 ANALYSIS:');
    if (totalAppsInCandidates > 0) {
      print(
        '❌ ISSUE CONFIRMED: Applications are being stored in candidates collection',
      );
      print(
        '   This should NOT happen according to the current implementation',
      );
      print('   Need to investigate where this is coming from');
    } else {
      print('✅ CORRECT: No applications found in candidates collection');
      print(
        '   Applications are only in job_applications collection as expected',
      );
    }

    print('\n📋 SUMMARY:');
    print(
      '- job_applications collection: ${jobAppsQuery.docs.length} documents',
    );
    print('- candidates with applications: $candidatesWithApps');
    print('- total apps in candidates: $totalAppsInCandidates');
  } catch (e) {
    print('❌ Error during testing: $e');
  }
}
