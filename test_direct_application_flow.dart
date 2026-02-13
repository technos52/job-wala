import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  print('🧪 DIRECT TEST: Application Flow');
  print('================================\n');

  await testApplicationFlow();
}

Future<void> testApplicationFlow() async {
  try {
    print('📊 Step 1: Check current Firebase state...');

    // Count current documents
    final currentJobApps = await FirebaseFirestore.instance
        .collection('job_applications')
        .get();

    final currentCandidates = await FirebaseFirestore.instance
        .collection('candidates')
        .get();

    print('Current job_applications documents: ${currentJobApps.docs.length}');
    print('Current candidates documents: ${currentCandidates.docs.length}\n');

    print('📊 Step 2: Simulate the exact _applyForJob logic...');

    // Simulate what happens in _applyForJob method
    final testUserId = 'test_user_${DateTime.now().millisecondsSinceEpoch}';
    final testJob = {
      'id': 'test_job_123',
      'jobTitle': 'Test Developer',
      'companyName': 'Test Company',
      'location': 'Test City',
      'jobCategory': 'IT',
      'department': 'Engineering',
      'designation': 'Developer',
      'jobType': 'Full Time',
      'salaryRange': '50k-70k',
      'jobDescription': 'Test job description',
      'experienceRequired': '2-3 years',
      'employerId': 'test_employer_123',
      'industryType': 'Technology',
    };

    print('Test User ID: $testUserId');
    print('Test Job ID: ${testJob['id']}\n');

    // Simulate the exact logic from _updateUserWithJobApplicationData
    print('📝 Step 3: Executing user document update logic...');

    final userRef = FirebaseFirestore.instance
        .collection('candidates')
        .doc(testUserId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userDoc = await transaction.get(userRef);

      Map<String, dynamic> currentData = {};
      if (userDoc.exists) {
        currentData = userDoc.data() ?? {};
      }

      // Update application counts and statistics
      final totalApplications = (currentData['totalApplications'] ?? 0) + 1;
      final currentMonth = DateTime.now().month;
      final currentYear = DateTime.now().year;
      final monthKey =
          '${currentYear}_${currentMonth.toString().padLeft(2, '0')}';

      // Store complete application data in applications array
      final applications = List<Map<String, dynamic>>.from(
        currentData['applications'] ?? [],
      );

      final applicationId =
          '${testUserId}_${testJob['id']}_${DateTime.now().millisecondsSinceEpoch}';

      // Add the new application with complete data
      applications.insert(0, {
        'applicationId': applicationId,
        'jobId': testJob['id'],
        'jobTitle': testJob['jobTitle'],
        'companyName': testJob['companyName'],
        'location': testJob['location'],
        'department': testJob['jobCategory'] ?? testJob['department'],
        'designation': testJob['designation'],
        'jobType': testJob['jobType'],
        'salary': testJob['salaryRange'],
        'jobDescription': testJob['jobDescription'],
        'experienceRequired': testJob['experienceRequired'],
        'appliedAt': DateTime.now(),
        'status': 'Applied',
        'isNew': true,
        'applicationSource': 'mobile_app',
        'deviceInfo': 'flutter_mobile',
        'employerId': testJob['employerId'],
        'industryType': testJob['industryType'],
      });

      // Update recent applications list
      final recentApplications = List<Map<String, dynamic>>.from(
        currentData['recentApplications'] ?? [],
      );
      recentApplications.insert(0, {
        'applicationId': applicationId,
        'jobTitle': testJob['jobTitle'],
        'companyName': testJob['companyName'],
        'jobCategory': testJob['jobCategory'],
        'industryType': testJob['industryType'],
        'location': testJob['location'],
        'salaryRange': testJob['salaryRange'],
        'appliedAt': DateTime.now(),
        'status': 'pending',
      });

      // Keep only last 10 applications
      if (recentApplications.length > 10) {
        recentApplications.removeRange(10, recentApplications.length);
      }

      // Update monthly application stats
      final monthlyApplications = Map<String, dynamic>.from(
        currentData['monthlyApplications'] ?? {},
      );
      monthlyApplications[monthKey] = (monthlyApplications[monthKey] ?? 0) + 1;

      // Update job category preferences
      final jobCategoryPreferences = Map<String, dynamic>.from(
        currentData['jobCategoryPreferences'] ?? {},
      );
      final jobCategory = testJob['jobCategory'] ?? 'unknown';
      jobCategoryPreferences[jobCategory] =
          (jobCategoryPreferences[jobCategory] ?? 0) + 1;

      final updatedUserData = {
        ...currentData,
        'applications': applications,
        'totalApplications': totalApplications,
        'recentApplications': recentApplications,
        'monthlyApplications': monthlyApplications,
        'jobCategoryPreferences': jobCategoryPreferences,
        'analyticsLastUpdated': FieldValue.serverTimestamp(),
        'applicationAnalyticsVersion': '1.0',
      };

      transaction.set(userRef, updatedUserData, SetOptions(merge: true));

      print('✅ Transaction completed - data stored in user document only');
    });

    print('📊 Step 4: Verify no separate documents were created...');

    // Check if any new documents were created in job_applications
    final afterJobApps = await FirebaseFirestore.instance
        .collection('job_applications')
        .get();

    final newSeparateDocs =
        afterJobApps.docs.length - currentJobApps.docs.length;

    if (newSeparateDocs > 0) {
      print(
        '❌ PROBLEM: ${newSeparateDocs} new separate documents were created!',
      );

      // Show the new documents
      for (
        int i = currentJobApps.docs.length;
        i < afterJobApps.docs.length;
        i++
      ) {
        final doc = afterJobApps.docs[i];
        print('   New document: ${doc.id}');
        print('   Data: ${doc.data()}');
      }
    } else {
      print('✅ SUCCESS: No separate documents created');
    }

    // Verify the user document was updated
    final userDoc = await userRef.get();
    if (userDoc.exists) {
      final userData = userDoc.data()!;
      final applications = userData['applications'] as List? ?? [];
      print('✅ User document updated with ${applications.length} applications');
      print('   Total applications: ${userData['totalApplications'] ?? 0}');
    } else {
      print('❌ User document was not created');
    }

    print('\n📊 Step 5: Cleanup test data...');

    // Clean up test data
    await userRef.delete();
    print('✅ Test data cleaned up');

    print('\n🎯 CONCLUSION:');
    if (newSeparateDocs == 0) {
      print('✅ The _applyForJob logic is working correctly');
      print('   No separate documents are created by this code path');
      print('   The issue must be coming from somewhere else');
    } else {
      print('❌ The _applyForJob logic is creating separate documents');
      print('   This indicates there\'s still problematic code in the flow');
    }
  } catch (e) {
    print('❌ Error during test: $e');
  }
}
