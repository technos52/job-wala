import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print('🔍 Testing Candidates Collection Access...\n');

    // Test 1: Check if candidates collection exists and has data
    final candidatesSnapshot = await FirebaseFirestore.instance
        .collection('candidates')
        .limit(10)
        .get();

    print('📊 Candidates Collection Status:');
    print('   Total documents found: ${candidatesSnapshot.docs.length}');

    if (candidatesSnapshot.docs.isEmpty) {
      print('   ❌ No candidates found in collection');
    } else {
      print('   ✅ Found ${candidatesSnapshot.docs.length} candidates');

      // Show first few candidates
      for (int i = 0; i < candidatesSnapshot.docs.length && i < 3; i++) {
        final doc = candidatesSnapshot.docs[i];
        final data = doc.data();
        print('   📝 Candidate ${i + 1}:');
        print('      ID: ${doc.id}');
        print('      Email: ${data['email'] ?? 'Not set'}');
        print('      Name: ${data['fullName'] ?? data['name'] ?? 'Not set'}');
        print('      Mobile: ${data['mobileNumber'] ?? 'Not set'}');
        print('      Created: ${data['createdAt'] ?? 'Not set'}');
        print('');
      }
    }

    // Test 2: Check collection structure
    print('🔍 Checking Collection Structure...');
    if (candidatesSnapshot.docs.isNotEmpty) {
      final sampleDoc = candidatesSnapshot.docs.first;
      final data = sampleDoc.data();
      print('   Available fields in first document:');
      data.keys.forEach((key) {
        print('      - $key: ${data[key]?.runtimeType}');
      });
    }

    // Test 3: Check if there are any subcollections
    print('\n🔍 Checking for Subcollections...');
    if (candidatesSnapshot.docs.isNotEmpty) {
      final docRef = candidatesSnapshot.docs.first.reference;
      // Note: listCollections() is not available in client SDK
      print('   Subcollection check skipped (requires admin SDK)');
    }

    print('\n✅ Test completed successfully!');
  } catch (e) {
    print('❌ Error during test: $e');
  }
}
