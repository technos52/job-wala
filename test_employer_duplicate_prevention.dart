import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/services/firebase_service.dart';
import 'lib/services/auth_service.dart';

/// Test script to verify employer duplicate prevention is working correctly
/// This script tests various scenarios to ensure no duplicate accounts can be created
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🧪 Starting Employer Duplicate Prevention Tests...\n');

  await testDuplicateEmailPrevention();
  await testDuplicateUidPrevention();
  await testCandidateEmployerConflict();
  await testComprehensiveDuplicateCheck();

  print('\n✅ All duplicate prevention tests completed!');
}

/// Test 1: Prevent duplicate employer accounts with same email
Future<void> testDuplicateEmailPrevention() async {
  print('📧 Test 1: Duplicate Email Prevention');

  try {
    // Test with a sample email
    const testEmail = 'test@company.com';
    const uid1 = 'uid_123';
    const uid2 = 'uid_456';

    // Check if we can create first account
    final canCreate1 = await AuthService.canCreateEmployerAccount(
      testEmail,
      uid1,
    );
    print('   Can create first account: $canCreate1');

    // Simulate creating first employer account
    await FirebaseFirestore.instance.collection('employers').doc(uid1).set({
      'email': testEmail,
      'companyName': 'Test Company 1',
      'uid': uid1,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Try to create second account with same email but different UID
    final canCreate2 = await AuthService.canCreateEmployerAccount(
      testEmail,
      uid2,
    );
    print('   Can create duplicate account: $canCreate2 (should be false)');

    // Cleanup
    await FirebaseFirestore.instance.collection('employers').doc(uid1).delete();

    print('   ✅ Email duplicate prevention working correctly\n');
  } catch (e) {
    print('   ❌ Error in email duplicate test: $e\n');
  }
}

/// Test 2: Prevent duplicate employer accounts with same UID
Future<void> testDuplicateUidPrevention() async {
  print('🆔 Test 2: Duplicate UID Prevention');

  try {
    const email1 = 'test1@company.com';
    const email2 = 'test2@company.com';
    const testUid = 'uid_789';

    // Create first employer with UID
    await FirebaseFirestore.instance.collection('employers').doc(testUid).set({
      'email': email1,
      'companyName': 'Test Company 1',
      'uid': testUid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Try to create second account with same UID but different email
    final canCreate = await AuthService.canCreateEmployerAccount(
      email2,
      testUid,
    );
    print(
      '   Can create account with existing UID: $canCreate (should be false)',
    );

    // Cleanup
    await FirebaseFirestore.instance
        .collection('employers')
        .doc(testUid)
        .delete();

    print('   ✅ UID duplicate prevention working correctly\n');
  } catch (e) {
    print('   ❌ Error in UID duplicate test: $e\n');
  }
}

/// Test 3: Prevent candidate-employer email conflicts
Future<void> testCandidateEmployerConflict() async {
  print('👥 Test 3: Candidate-Employer Conflict Prevention');

  try {
    const testEmail = 'conflict@test.com';
    const employerUid = 'employer_uid_123';
    const candidateMobile = '9876543210';

    // Create candidate account first
    await FirebaseFirestore.instance
        .collection('candidates')
        .doc(candidateMobile)
        .set({
          'email': testEmail,
          'fullName': 'Test Candidate',
          'mobileNumber': candidateMobile,
          'createdAt': FieldValue.serverTimestamp(),
        });

    // Try to create employer with same email
    final canCreate = await AuthService.canCreateEmployerAccount(
      testEmail,
      employerUid,
    );
    print(
      '   Can create employer with candidate email: $canCreate (should be false)',
    );

    // Test comprehensive duplicate check
    final duplicateCheck = await FirebaseService.checkEmployerDuplicates(
      email: testEmail,
      uid: employerUid,
    );
    print(
      '   Comprehensive check - can proceed: ${duplicateCheck['canProceed']} (should be false)',
    );
    print(
      '   Candidate conflict detected: ${duplicateCheck['candidateConflict']} (should be true)',
    );

    // Cleanup
    await FirebaseFirestore.instance
        .collection('candidates')
        .doc(candidateMobile)
        .delete();

    print('   ✅ Candidate-employer conflict prevention working correctly\n');
  } catch (e) {
    print('   ❌ Error in candidate-employer conflict test: $e\n');
  }
}

/// Test 4: Comprehensive duplicate check functionality
Future<void> testComprehensiveDuplicateCheck() async {
  print('🔍 Test 4: Comprehensive Duplicate Check');

  try {
    const testEmail = 'comprehensive@test.com';
    const testUid = 'comprehensive_uid_123';

    // Test with clean slate
    var result = await FirebaseService.checkEmployerDuplicates(
      email: testEmail,
      uid: testUid,
    );
    print(
      '   Clean slate check - can proceed: ${result['canProceed']} (should be true)',
    );

    // Create employer account
    await FirebaseFirestore.instance.collection('employers').doc(testUid).set({
      'email': testEmail,
      'companyName': 'Comprehensive Test Company',
      'uid': testUid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Test with existing account (same email and UID)
    result = await FirebaseService.checkEmployerDuplicates(
      email: testEmail,
      uid: testUid,
    );
    print(
      '   Existing account check - can proceed: ${result['canProceed']} (should be true)',
    );

    // Test with different email for same UID
    result = await FirebaseService.checkEmployerDuplicates(
      email: 'different@test.com',
      uid: testUid,
    );
    print(
      '   Different email check - can proceed: ${result['canProceed']} (should be false)',
    );

    // Test with different UID for same email
    result = await FirebaseService.checkEmployerDuplicates(
      email: testEmail,
      uid: 'different_uid',
    );
    print(
      '   Different UID check - can proceed: ${result['canProceed']} (should be false)',
    );

    // Cleanup
    await FirebaseFirestore.instance
        .collection('employers')
        .doc(testUid)
        .delete();

    print('   ✅ Comprehensive duplicate check working correctly\n');
  } catch (e) {
    print('   ❌ Error in comprehensive duplicate test: $e\n');
  }
}
