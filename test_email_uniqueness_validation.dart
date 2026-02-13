import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/services/firebase_service.dart';

/// Test script to verify email uniqueness validation
/// This script tests both candidate and employer registration email conflicts
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🧪 Testing Email Uniqueness Validation');
  print('=====================================');

  await testCandidateEmailUniqueness();
  await testEmployerEmailUniqueness();
  await testCrossRoleEmailConflict();

  print('\n✅ All email uniqueness tests completed!');
}

/// Test candidate email uniqueness validation
Future<void> testCandidateEmailUniqueness() async {
  print('\n📧 Testing Candidate Email Uniqueness...');

  try {
    // Test 1: Check if duplicate candidate email is rejected
    print('Test 1: Attempting to register candidate with duplicate email...');

    // This should fail if email already exists for another candidate
    await FirebaseService.updateCandidateStep2Data(
      mobileNumber: '9999999999', // Different mobile number
      qualification: 'Bachelor\'s Degree',
      experienceYears: 2,
      experienceMonths: 6,
      jobCategory: 'Software Development',
      jobType: 'Full-time',
      designation: 'Software Developer',
      companyName: 'Test Company',
      email: 'test@example.com', // Duplicate email
    );

    print('❌ Test 1 FAILED: Duplicate candidate email was allowed');
  } catch (e) {
    if (e.toString().contains('already registered with another candidate')) {
      print('✅ Test 1 PASSED: Duplicate candidate email correctly rejected');
    } else {
      print('⚠️ Test 1 PARTIAL: Error occurred but not the expected one: $e');
    }
  }

  try {
    // Test 2: Check if same candidate can update their own email
    print('Test 2: Attempting to update same candidate with same email...');

    await FirebaseService.updateCandidateStep2Data(
      mobileNumber: '1234567890', // Same mobile number as existing
      qualification: 'Bachelor\'s Degree',
      experienceYears: 2,
      experienceMonths: 6,
      jobCategory: 'Software Development',
      jobType: 'Full-time',
      designation: 'Software Developer',
      companyName: 'Test Company',
      email: 'test@example.com', // Same email, same candidate
    );

    print('✅ Test 2 PASSED: Same candidate can update with same email');
  } catch (e) {
    print('❌ Test 2 FAILED: Same candidate cannot update with same email: $e');
  }
}

/// Test employer email uniqueness validation
Future<void> testEmployerEmailUniqueness() async {
  print('\n🏢 Testing Employer Email Uniqueness...');

  try {
    // Test 3: Check if duplicate employer email is rejected
    print('Test 3: Checking employer email conflict detection...');

    final candidateExists = await FirebaseService.candidateExistsByEmail(
      'employer@test.com',
    );
    final employerExists = await FirebaseService.employerExistsByEmail(
      'employer@test.com',
    );

    if (candidateExists) {
      print('✅ Test 3a PASSED: Candidate email conflict detection works');
    } else {
      print(
        '⚠️ Test 3a: No candidate found with test email (expected for clean test)',
      );
    }

    if (employerExists) {
      print('✅ Test 3b PASSED: Employer email conflict detection works');
    } else {
      print(
        '⚠️ Test 3b: No employer found with test email (expected for clean test)',
      );
    }
  } catch (e) {
    print('❌ Test 3 FAILED: Error checking email conflicts: $e');
  }
}

/// Test cross-role email conflict (candidate vs employer)
Future<void> testCrossRoleEmailConflict() async {
  print('\n🔄 Testing Cross-Role Email Conflicts...');

  try {
    // Test 4: Check if candidate email conflicts with employer
    print('Test 4: Testing candidate registration with employer email...');

    await FirebaseService.updateCandidateStep2Data(
      mobileNumber: '8888888888',
      qualification: 'Bachelor\'s Degree',
      experienceYears: 1,
      experienceMonths: 0,
      jobCategory: 'Marketing',
      jobType: 'Full-time',
      designation: 'Marketing Executive',
      companyName: 'Marketing Corp',
      email: 'employer@company.com', // Email that might belong to an employer
    );

    print(
      '❌ Test 4 FAILED: Candidate registration with employer email was allowed',
    );
  } catch (e) {
    if (e.toString().contains('employer account')) {
      print(
        '✅ Test 4 PASSED: Candidate registration correctly blocked for employer email',
      );
    } else {
      print('⚠️ Test 4 PARTIAL: Error occurred but not the expected one: $e');
    }
  }
}

/// Helper function to create test data
Future<void> createTestData() async {
  print('\n🔧 Creating test data...');

  try {
    // Create a test candidate
    await FirebaseFirestore.instance
        .collection('candidates')
        .doc('1234567890')
        .set({
          'fullName': 'Test Candidate',
          'email': 'test@example.com',
          'mobileNumber': '1234567890',
          'createdAt': FieldValue.serverTimestamp(),
        });

    // Create a test employer
    await FirebaseFirestore.instance
        .collection('employers')
        .doc('test-employer-uid')
        .set({
          'companyName': 'Test Company',
          'email': 'employer@company.com',
          'uid': 'test-employer-uid',
          'createdAt': FieldValue.serverTimestamp(),
        });

    print('✅ Test data created successfully');
  } catch (e) {
    print('❌ Failed to create test data: $e');
  }
}

/// Helper function to clean up test data
Future<void> cleanupTestData() async {
  print('\n🧹 Cleaning up test data...');

  try {
    await FirebaseFirestore.instance
        .collection('candidates')
        .doc('1234567890')
        .delete();

    await FirebaseFirestore.instance
        .collection('candidates')
        .doc('9999999999')
        .delete();

    await FirebaseFirestore.instance
        .collection('candidates')
        .doc('8888888888')
        .delete();

    await FirebaseFirestore.instance
        .collection('employers')
        .doc('test-employer-uid')
        .delete();

    print('✅ Test data cleaned up successfully');
  } catch (e) {
    print('⚠️ Cleanup completed with some errors: $e');
  }
}
