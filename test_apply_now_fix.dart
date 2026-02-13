import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/services/firebase_service.dart';
import 'lib/services/job_application_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  print('🧪 Testing Apply Now Fix');
  print('=' * 50);

  await testApplyNowFix();
}

Future<void> testApplyNowFix() async {
  try {
    print('\n📋 Step 1: Check current user authentication...');
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('❌ No user authenticated. Please sign in first.');
      return;
    }

    print('✅ User authenticated: ${user.email}');
    print('🔑 User UID: ${user.uid}');

    print('\n📋 Step 2: Test getUserDocumentIdByEmail...');
    final userId = await FirebaseService.getUserDocumentIdByEmail(user.email!);

    if (userId == null) {
      print('❌ getUserDocumentIdByEmail returned null');
      print('💡 This means no candidate document exists for this email');

      // Check if any candidate documents exist
      print('\n🔍 Checking all candidate documents...');
      final allCandidates = await FirebaseFirestore.instance
          .collection('candidates')
          .limit(5)
          .get();

      print('📊 Found ${allCandidates.docs.length} candidate documents:');
      for (var doc in allCandidates.docs) {
        final data = doc.data();
        print('   - ID: ${doc.id}');
        print('     Email: ${data['email'] ?? 'No email'}');
        print('     Name: ${data['fullName'] ?? 'No name'}');
        print('     Mobile: ${data['mobileNumber'] ?? 'No mobile'}');
      }

      return;
    }

    print('✅ Found user document ID: $userId');

    print('\n📋 Step 3: Verify user document exists...');
    final userDoc = await FirebaseFirestore.instance
        .collection('candidates')
        .doc(userId)
        .get();

    if (!userDoc.exists) {
      print('❌ User document does not exist at candidates/$userId');
      return;
    }

    print('✅ User document exists');
    final userData = userDoc.data()!;
    print('📊 User data keys: ${userData.keys.toList()}');
    print('👤 Name: ${userData['fullName'] ?? 'No name'}');
    print('📧 Email: ${userData['email'] ?? 'No email'}');

    print('\n📋 Step 4: Test job application creation...');

    // Create a test job data
    final testJob = {
      'id': 'test_job_${DateTime.now().millisecondsSinceEpoch}',
      'jobTitle': 'Test Software Developer',
      'companyName': 'Test Company',
      'employerId': 'test_employer_123',
      'location': 'Test City',
      'jobCategory': 'IT',
      'designation': 'Software Developer',
      'jobType': 'Full-time',
      'salaryRange': '50000-80000',
      'jobDescription': 'Test job description',
      'experienceRequired': '2-3 years',
      'industryType': 'Technology',
    };

    print('🎯 Attempting to apply for test job...');
    print('   Job ID: ${testJob['id']}');
    print('   Job Title: ${testJob['jobTitle']}');

    final applicationId = await JobApplicationService.applyForJob(
      jobId: testJob['id']!,
      jobTitle: testJob['jobTitle']!,
      companyName: testJob['companyName']!,
      employerId: testJob['employerId']!,
      additionalData: {
        'location': testJob['location'],
        'department': testJob['jobCategory'],
        'designation': testJob['designation'],
        'jobType': testJob['jobType'],
        'salary': testJob['salaryRange'],
        'jobDescription': testJob['jobDescription'],
        'experienceRequired': testJob['experienceRequired'],
        'candidateEmail': user.email,
        'candidateName': userData['fullName'],
        'applicationSource': 'test_script',
        'deviceInfo': 'test_device',
        'industryType': testJob['industryType'],
        'jobCategory': testJob['jobCategory'],
      },
    );

    if (applicationId != null) {
      print('✅ Application created successfully!');
      print('🔑 Application ID: $applicationId');
      print('📍 Location: candidates/$userId/applications/$applicationId');

      // Verify the application was created
      print('\n📋 Step 5: Verify application was stored...');
      final appDoc = await FirebaseFirestore.instance
          .collection('candidates')
          .doc(userId)
          .collection('applications')
          .doc(applicationId)
          .get();

      if (appDoc.exists) {
        print('✅ Application document verified');
        final appData = appDoc.data()!;
        print('📊 Application data keys: ${appData.keys.toList()}');
        print('🎯 Job Title: ${appData['jobTitle']}');
        print('🏢 Company: ${appData['companyName']}');
        print('📅 Applied At: ${appData['appliedAt']}');
        print('📊 Status: ${appData['status']}');
      } else {
        print('❌ Application document not found');
      }
    } else {
      print('❌ Application creation failed');
      print('💡 Check the logs above for specific error details');
    }

    print('\n🎯 CONCLUSION:');
    if (applicationId != null) {
      print('✅ Apply Now functionality is working correctly!');
      print('   The error should be resolved now.');
    } else {
      print('❌ Apply Now functionality still has issues');
      print('   Check the error logs above for troubleshooting');
    }
  } catch (e) {
    print('❌ Test failed with error: $e');
    print('🔍 Error type: ${e.runtimeType}');
  }
}
