import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Testing Registration Authentication Fix...');
  print('=' * 50);

  // Test 1: Check authentication state
  await testAuthenticationState();

  // Test 2: Test registration without authentication
  await testRegistrationWithoutAuth();

  // Test 3: Test registration with authentication (if user is signed in)
  await testRegistrationWithAuth();

  print('=' * 50);
  print('✅ Registration authentication tests completed');
}

Future<void> testAuthenticationState() async {
  print('\n📋 Test 1: Authentication State Check');
  print('-' * 30);

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('❌ No authenticated user found');
    print('💡 User needs to sign in with Google first');
    print('   Navigate to: CandidateGoogleSignInScreen');
  } else {
    print('✅ User authenticated:');
    print('   Email: ${user.email}');
    print('   UID: ${user.uid}');
    print('   Display Name: ${user.displayName}');
    print('   Email Verified: ${user.emailVerified}');

    // Test token validity
    try {
      await user.reload();
      await user.getIdToken(true);
      print('✅ Authentication token is valid');
    } catch (e) {
      print('❌ Authentication token is invalid: $e');
    }
  }
}

Future<void> testRegistrationWithoutAuth() async {
  print('\n📋 Test 2: Registration Without Authentication');
  print('-' * 30);

  // Sign out first to simulate unauthenticated state
  await FirebaseAuth.instance.signOut();

  try {
    await FirebaseService.saveCandidateStep1Data(
      fullName: 'Test User',
      title: 'Mr.',
      gender: 'Male',
      mobileNumber: '9876543210',
      birthYear: 1990,
      age: 35,
    );

    print('❌ Registration succeeded without authentication (unexpected)');
  } catch (e) {
    print('✅ Registration correctly failed without authentication');
    print('   Error: $e');

    if (e.toString().contains('sign in')) {
      print('✅ Correct error message provided');
    } else {
      print('⚠️ Error message could be more specific');
    }
  }
}

Future<void> testRegistrationWithAuth() async {
  print('\n📋 Test 3: Registration With Authentication');
  print('-' * 30);

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('⏭️ Skipping - no authenticated user available');
    print('💡 To test this: Sign in with Google first');
    return;
  }

  try {
    print('🔍 Testing registration with authenticated user...');

    await FirebaseService.saveCandidateStep1Data(
      fullName: 'Test Authenticated User',
      title: 'Ms.',
      gender: 'Female',
      mobileNumber: '9876543211',
      birthYear: 1995,
      age: 30,
    );

    print('✅ Registration succeeded with authentication');

    // Verify data was saved
    final doc = await FirebaseFirestore.instance
        .collection('candidates')
        .doc('9876543211')
        .get();

    if (doc.exists) {
      print('✅ Data was successfully saved to Firestore');
      final data = doc.data()!;
      print('   Full Name: ${data['fullName']}');
      print('   Email: ${data['email']}');
      print('   UID: ${data['uid']}');

      // Clean up test document
      await doc.reference.delete();
      print('🧹 Test document cleaned up');
    } else {
      print('❌ Data was not saved to Firestore');
    }
  } catch (e) {
    print('❌ Registration failed with authentication: $e');

    if (e.toString().contains('permission')) {
      print('💡 Check Firestore rules - they may be too restrictive');
    }
  }
}
