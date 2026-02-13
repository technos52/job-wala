import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Debugging Authentication State...');

  // Check current user
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('❌ No authenticated user found');
    print('🔍 User must sign in with Google first');
    return;
  }

  print('✅ User authenticated:');
  print('   Email: ${user.email}');
  print('   UID: ${user.uid}');
  print('   Display Name: ${user.displayName}');
  print('   Email Verified: ${user.emailVerified}');

  // Test Firestore write permission
  try {
    print('🔍 Testing Firestore write permission...');

    final testData = {
      'fullName': 'Test User',
      'title': 'Mr.',
      'gender': 'Male',
      'mobileNumber': '9876543210',
      'birthYear': 1990,
      'age': 35,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'step': 1,
    };

    await FirebaseFirestore.instance
        .collection('candidates')
        .doc('9876543210')
        .set(testData, SetOptions(merge: true));

    print('✅ Firestore write successful');
    print('🔍 Authentication and permissions are working correctly');

    // Clean up test document
    await FirebaseFirestore.instance
        .collection('candidates')
        .doc('9876543210')
        .delete();

    print('🧹 Test document cleaned up');
  } catch (e) {
    print('❌ Firestore write failed: $e');
    print('🔍 This is likely the cause of the registration error');

    if (e.toString().contains('permission')) {
      print('💡 Solution: User needs to be authenticated first');
      print(
        '   Make sure user goes through Google Sign-In before registration',
      );
    } else if (e.toString().contains('network')) {
      print('💡 Solution: Check internet connection');
    } else {
      print('💡 Check Firestore rules and Firebase configuration');
    }
  }
}
