import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'lib/services/job_application_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print('🔥 Firebase initialized successfully');

    await testSubcollectionApplications();
  } catch (e) {
    print('❌ Error: $e');
  }
}

Future<void> testSubcollectionApplications() async {
  print('\n🧪 Testing Subcollection Job Applications');
  print('=' * 50);

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('❌ No authenticated user found');
    print('Please log in to the app first, then run this test');
    return;
  }

  print('👤 Testing with user: ${user.email} (${user.uid})');

  // Test 1: Apply for a test job
  print('\n📝 Test 1: Applying for a test job...');

  final testJobId = 'test_job_${DateTime.now().millisecondsSinceEpoch}';

  final applicationId = await JobApplicationService.applyForJob(
    jobId: testJobId,
    jobTitle: 'Test Flutter Developer',
    companyName: 'Test Company Inc',
    employerId: 'test_employer_123',
    additionalData: {
      'location': 'Test City',
      'jobType': 'Full-time',
      'salary': '50,000 - 70,000',
    },
  );

  if (applicationId != null) {
    print('✅ Application created successfully!');
    print('📍 Application ID: $applicationId');
    print('📍 Location: candidates/${user.uid}/applications/$applicationId');
  } else {
    print('❌ Failed to create application');
    return;
  }

  // Test 2: Verify the subcollection exists
  print('\n🔍 Test 2: Verifying subcollection exists...');

  try {
    final applicationsSnapshot = await FirebaseFirestore.instance
        .collection('candidates')
        .doc(user.uid)
        .collection('applications')
        .get();

    print('✅ Subcollection found!');
    print('📊 Total applications: ${applicationsSnapshot.docs.length}');

    for (final doc in applicationsSnapshot.docs) {
      final data = doc.data();
      print('  - ${data['jobTitle']} at ${data['companyName']} (${doc.id})');
    }
  } catch (e) {
    print('❌ Error accessing subcollection: $e');
    return;
  }

  // Test 3: Check if user has applied for the job
  print('\n🔍 Test 3: Checking application status...');

  final hasApplied = await JobApplicationService.hasAppliedForJob(testJobId);
  print('✅ Has applied for test job: $hasApplied');

  // Test 4: Get user applications stream
  print('\n📡 Test 4: Testing applications stream...');

  try {
    final stream = JobApplicationService.getUserApplications();
    final snapshot = await stream.first;

    print('✅ Stream working!');
    print('📊 Applications in stream: ${snapshot.docs.length}');
  } catch (e) {
    print('❌ Error with stream: $e');
  }

  // Test 5: Update application status
  print('\n📝 Test 5: Updating application status...');

  final updateSuccess = await JobApplicationService.updateApplicationStatus(
    applicationId: applicationId,
    status: 'reviewed',
  );

  if (updateSuccess) {
    print('✅ Status updated successfully!');

    // Verify the update
    final updatedApp = await JobApplicationService.getApplication(
      applicationId,
    );
    if (updatedApp != null && updatedApp.exists) {
      final data = updatedApp.data() as Map<String, dynamic>;
      print('📊 New status: ${data['status']}');
    }
  } else {
    print('❌ Failed to update status');
  }

  print('\n🎉 All tests completed!');
  print('🔥 Check your Firebase Console:');
  print(
    '   Navigate to: Firestore Database > candidates > ${user.uid} > applications',
  );
  print('   You should see your job applications stored there!');
}
