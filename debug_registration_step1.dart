import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // This is a debug script to test Step 1 registration
  await debugRegistrationStep1();
}

Future<void> debugRegistrationStep1() async {
  print('🔍 Debug Registration Step 1');
  print('=' * 50);

  try {
    // Check current user authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('❌ No authenticated user found');
      print('Please log in to the app first, then run this test');
      return;
    }

    print('✅ User authenticated:');
    print('   - UID: ${user.uid}');
    print('   - Email: ${user.email}');
    print('   - Phone: ${user.phoneNumber}');
    print('   - Email verified: ${user.emailVerified}');

    // Test data (same as what registration would send)
    final testData = {
      'fullName': 'Test User',
      'title': 'Mr.',
      'gender': 'Male',
      'mobileNumber': '9999999999',
      'birthYear': 1990,
      'age': 35,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'step': 1,
    };

    print('\n📝 Test data to save:');
    testData.forEach((key, value) {
      print('   - $key: $value');
    });

    // Try to save to Firestore
    print('\n🔥 Attempting to save to Firestore...');
    print('📍 Target: candidates/9999999999');

    try {
      await FirebaseFirestore.instance
          .collection('candidates')
          .doc('9999999999')
          .set(testData, SetOptions(merge: true));

      print('✅ SUCCESS: Document saved successfully!');

      // Verify the document was created
      final doc = await FirebaseFirestore.instance
          .collection('candidates')
          .doc('9999999999')
          .get();

      if (doc.exists) {
        print('✅ VERIFIED: Document exists in Firestore');
        print('📊 Document data: ${doc.data()}');
      } else {
        print('❌ ERROR: Document was not created');
      }
    } catch (firestoreError) {
      print('❌ FIRESTORE ERROR: $firestoreError');
      print('🔍 Error type: ${firestoreError.runtimeType}');

      if (firestoreError.toString().contains('permission')) {
        print('🚫 This looks like a permission error');
        print('💡 Check Firestore security rules');
      }

      if (firestoreError.toString().contains('network')) {
        print('🌐 This looks like a network error');
        print('💡 Check internet connection');
      }
    }

    // Test Firestore rules directly
    print('\n🔒 Testing Firestore rules...');
    try {
      // Try to read from candidates collection
      final testRead = await FirebaseFirestore.instance
          .collection('candidates')
          .limit(1)
          .get();

      print('✅ READ permission: OK');
      print('📊 Found ${testRead.docs.length} documents');
    } catch (readError) {
      print('❌ READ permission: FAILED');
      print('🔍 Read error: $readError');
    }
  } catch (e) {
    print('❌ General error: $e');
    print('🔍 Error type: ${e.runtimeType}');
  }

  print('\n🎯 DEBUGGING CHECKLIST:');
  print('   □ User is authenticated');
  print('   □ Firestore rules allow write access');
  print('   □ Internet connection is working');
  print('   □ Firebase project is configured correctly');
  print('   □ No validation errors in data');
}
