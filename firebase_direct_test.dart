import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Direct Firebase test to see actual data structure
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print('🔥 Firebase initialized');

    await testActualFirebaseData();
  } catch (e) {
    print('❌ Error: $e');
  }
}

Future<void> testActualFirebaseData() async {
  print('\n🔍 TESTING ACTUAL FIREBASE DATA STRUCTURE\n');

  // Test 1: Check if dropdownData collection exists
  print('📋 Step 1: Checking dropdownData collection...');
  try {
    final collection = await FirebaseFirestore.instance
        .collection('dropdownData')
        .get();

    print(
      '✅ dropdownData collection exists with ${collection.docs.length} documents',
    );

    for (var doc in collection.docs) {
      print('   📄 Document ID: ${doc.id}');
    }
  } catch (e) {
    print('❌ Error accessing dropdownData: $e');
    return;
  }

  // Test 2: Check jobCategory document specifically
  print('\n📋 Step 2: Checking jobCategory document...');
  try {
    final doc = await FirebaseFirestore.instance
        .collection('dropdownData')
        .doc('jobCategory')
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      print('✅ jobCategory document exists');
      print('📄 FULL DOCUMENT DATA:');
      print(data);
      print('\n📝 Document keys: ${data.keys.toList()}');

      // Check each possible field
      if (data.containsKey('options')) {
        print('\n📊 Found "options" field');
        final options = data['options'];
        print('   Type: ${options.runtimeType}');
        print('   Value: $options');

        if (options is List) {
          print('   Length: ${options.length}');
          for (int i = 0; i < options.length; i++) {
            print('   [$i]: ${options[i]} (${options[i].runtimeType})');
          }
        }
      }

      if (data.containsKey('category')) {
        print('\n📊 Found "category" field: ${data['category']}');
      }

      // Try to parse with current logic
      print('\n🔧 Testing current parsing logic...');
      final categories = <String>[];

      if (data.containsKey('options')) {
        final options = data['options'] as List<dynamic>;

        for (int i = 0; i < options.length; i++) {
          final option = options[i];
          print('   Processing option $i: $option');

          String? categoryValue;

          if (option is Map<String, dynamic>) {
            print('     Keys available: ${option.keys.toList()}');

            // Test all possible keys
            for (String key in option.keys) {
              print('     Key "$key" = ${option[key]}');
            }

            if (option.containsKey('0')) {
              categoryValue = option['0'].toString();
              print('     ✅ Using key "0": $categoryValue');
            } else if (option.containsKey('1')) {
              categoryValue = option['1'].toString();
              print('     ✅ Using key "1": $categoryValue');
            } else if (option.containsKey(i.toString())) {
              categoryValue = option[i.toString()].toString();
              print('     ✅ Using key "$i": $categoryValue');
            } else {
              // Use first value
              final values = option.values.toList();
              if (values.isNotEmpty) {
                categoryValue = values.first.toString();
                print('     ✅ Using first value: $categoryValue');
              }
            }
          } else if (option is String) {
            categoryValue = option;
            print('     ✅ Direct string: $categoryValue');
          }

          if (categoryValue != null && categoryValue.isNotEmpty) {
            categories.add(categoryValue);
            print('     ✅ ADDED: $categoryValue');
          }
        }
      }

      print('\n🎯 FINAL PARSED CATEGORIES: $categories');
      print('📊 Total categories found: ${categories.length}');
    } else {
      print('❌ jobCategory document does not exist');
    }
  } catch (e) {
    print('❌ Error checking jobCategory: $e');
  }

  // Test 3: Check filter documents
  print('\n📋 Step 3: Checking filter documents...');
  final filterFields = [
    'jobType',
    'department',
    'candidateDepartment',
    'designation',
    'location',
  ];

  for (String field in filterFields) {
    print('\n   Testing $field...');
    try {
      final doc = await FirebaseFirestore.instance
          .collection('dropdownData')
          .doc(field)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        print('   ✅ $field document exists');
        print('   📄 Data: $data');

        if (data.containsKey('options')) {
          final options = data['options'] as List<dynamic>;
          print('   📊 Has ${options.length} options');

          // Show first few options
          for (int i = 0; i < options.length && i < 3; i++) {
            print('     [$i]: ${options[i]}');
          }
        }
      } else {
        print('   ❌ $field document does not exist');
      }
    } catch (e) {
      print('   ❌ Error checking $field: $e');
    }
  }

  // Test 4: Check jobs collection for fallback
  print('\n📋 Step 4: Checking jobs collection...');
  try {
    final jobs = await FirebaseFirestore.instance
        .collection('jobs')
        .where('approvalStatus', isEqualTo: 'approved')
        .limit(5)
        .get();

    print('✅ Found ${jobs.docs.length} approved jobs');

    if (jobs.docs.isNotEmpty) {
      final sampleJob = jobs.docs.first.data();
      print('📄 Sample job fields: ${sampleJob.keys.toList()}');
      print('📄 Sample jobCategory: ${sampleJob['jobCategory']}');
    }
  } catch (e) {
    print('❌ Error checking jobs: $e');
  }

  print('\n🎉 Firebase data structure analysis complete!');
}
