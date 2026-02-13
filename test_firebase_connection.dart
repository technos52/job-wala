import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Simple Firebase connection test
void main() async {
  print('🔥 Firebase Connection Test...\n');

  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully\n');

    await testBasicConnection();
    await testDropdownDataExists();
    await testSpecificDocuments();

    print('\n🎉 Firebase connection test completed!');
  } catch (e) {
    print('❌ Firebase connection error: $e');
  }
}

Future<void> testBasicConnection() async {
  print('🔗 Testing basic Firebase connection...');

  try {
    // Try to read any collection to test connection
    final testQuery = await FirebaseFirestore.instance
        .collection('jobs')
        .limit(1)
        .get();

    print(
      '✅ Firebase connection working - found ${testQuery.docs.length} test documents',
    );
  } catch (e) {
    print('❌ Firebase connection failed: $e');
  }
}

Future<void> testDropdownDataExists() async {
  print('\n📋 Testing dropdownData collection...');

  try {
    final collection = await FirebaseFirestore.instance
        .collection('dropdownData')
        .get();

    print(
      '✅ dropdownData collection exists with ${collection.docs.length} documents',
    );

    for (var doc in collection.docs) {
      print('   📄 Document: ${doc.id}');
    }
  } catch (e) {
    print('❌ Error accessing dropdownData collection: $e');
  }
}

Future<void> testSpecificDocuments() async {
  print('\n🔍 Testing specific documents...');

  final documentsToTest = [
    'jobCategory',
    'jobType',
    'department',
    'candidateDepartment',
    'designation',
    'location',
  ];

  for (String docId in documentsToTest) {
    try {
      print('\n📄 Testing document: $docId');

      final doc = await FirebaseFirestore.instance
          .collection('dropdownData')
          .doc(docId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        print('   ✅ Document exists');
        print('   📝 Keys: ${data?.keys.toList()}');

        // Check for different possible field names
        if (data?.containsKey('options') == true) {
          final options = data!['options'];
          print(
            '   📊 Has "options" field (${options is List ? (options as List).length : 'not a list'} items)',
          );

          if (options is List && options.isNotEmpty) {
            print('   📝 First option: ${options.first}');
            print('   📝 First option type: ${options.first.runtimeType}');
          }
        } else if (data?.containsKey('values') == true) {
          print('   📊 Has "values" field');
        } else if (data?.containsKey('items') == true) {
          print('   📊 Has "items" field');
        } else {
          print('   ⚠️  No standard options field found');
          print('   📄 Full data: $data');
        }
      } else {
        print('   ❌ Document does not exist');
      }
    } catch (e) {
      print('   ❌ Error testing $docId: $e');
    }
  }
}

// Test what the actual Firebase structure looks like
Future<void> inspectFirebaseStructure() async {
  print('\n🔬 Inspecting Firebase Structure...');

  try {
    // Check if the image you showed matches the actual structure
    final jobCategoryDoc = await FirebaseFirestore.instance
        .collection('dropdownData')
        .doc('jobCategory')
        .get();

    if (jobCategoryDoc.exists) {
      final data = jobCategoryDoc.data()!;
      print('📄 jobCategory document structure:');
      print(data);

      // Based on your image, it should have:
      // category: "jobCategory"
      // options: [
      //   {0: "Company Jobs"},
      //   {1: "Bank/NBFC Jobs"},
      //   etc.
      // ]

      if (data.containsKey('category')) {
        print('✅ Has category field: ${data['category']}');
      }

      if (data.containsKey('options')) {
        final options = data['options'] as List;
        print('✅ Has options field with ${options.length} items');

        for (int i = 0; i < options.length; i++) {
          final option = options[i];
          print('   Option $i: $option');

          if (option is Map) {
            // Based on your image, should be {0: "Company Jobs"}, {1: "Bank/NBFC Jobs"}, etc.
            final map = option as Map<String, dynamic>;
            map.forEach((key, value) {
              print('     Key: $key, Value: $value');
            });
          }
        }
      }
    }
  } catch (e) {
    print('❌ Error inspecting structure: $e');
  }
}
