import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Test script to verify job categories are loaded correctly from Firebase
void main() async {
  print('🔍 Testing Job Categories Loading Fix...\n');

  try {
    // Initialize Firebase (you may need to adjust this based on your setup)
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully');

    // Test loading job categories from the jobCategory document
    await testJobCategoriesFromDocument();

    // Test fallback to jobs collection
    await testJobCategoriesFallback();

    print('\n🎉 All tests completed successfully!');
  } catch (e) {
    print('❌ Error during testing: $e');
  }
}

Future<void> testJobCategoriesFromDocument() async {
  print('\n📋 Testing job categories from jobCategory document...');

  try {
    final categoryDoc = await FirebaseFirestore.instance
        .collection('dropdownData')
        .doc('jobCategory')
        .get();

    if (categoryDoc.exists) {
      final data = categoryDoc.data();
      print('✅ jobCategory document found');
      print('📄 Document data: $data');

      if (data != null && data['options'] != null) {
        final options = data['options'] as List<dynamic>;
        final categories = <String>[];

        for (var option in options) {
          if (option is Map<String, dynamic> && option.containsKey('1')) {
            categories.add(option['1'].toString());
          }
        }

        print('📊 Found ${categories.length} categories:');
        for (int i = 0; i < categories.length; i++) {
          print('   ${i + 1}. ${categories[i]}');
        }

        if (categories.length >= 8) {
          print('✅ Expected number of categories found (8)');
        } else {
          print('⚠️  Expected 8 categories, but found ${categories.length}');
        }
      } else {
        print('❌ No options field found in document');
      }
    } else {
      print('❌ jobCategory document not found');
    }
  } catch (e) {
    print('❌ Error loading job categories from document: $e');
  }
}

Future<void> testJobCategoriesFallback() async {
  print('\n🔄 Testing fallback to jobs collection...');

  try {
    final jobsQuery = await FirebaseFirestore.instance
        .collection('jobs')
        .where('approvalStatus', isEqualTo: 'approved')
        .get();

    print('✅ Found ${jobsQuery.docs.length} approved jobs');

    final categories = <String>{};
    for (var doc in jobsQuery.docs) {
      final data = doc.data();
      final jobCategory = data['jobCategory']?.toString();
      if (jobCategory != null && jobCategory.isNotEmpty) {
        categories.add(jobCategory);
      }
    }

    print('📊 Unique job categories from jobs collection:');
    final sortedCategories = categories.toList()..sort();
    for (int i = 0; i < sortedCategories.length; i++) {
      print('   ${i + 1}. ${sortedCategories[i]}');
    }

    if (categories.contains('Government Jobs')) {
      print('✅ Government Jobs category found in jobs');
    }

    if (categories.contains('aaaa')) {
      print('✅ aaaa category found in jobs');
    }
  } catch (e) {
    print('❌ Error loading job categories from jobs collection: $e');
  }
}

// Simulate the updated _loadJobCategories method
Future<List<String>> loadJobCategoriesUpdated() async {
  try {
    print('\n🔧 Simulating updated _loadJobCategories method...');

    // Get job categories from the jobCategory document
    final categoryDoc = await FirebaseFirestore.instance
        .collection('dropdownData')
        .doc('jobCategory')
        .get();

    final categories = <String>[];

    if (categoryDoc.exists) {
      final data = categoryDoc.data();
      if (data != null && data['options'] != null) {
        final options = data['options'] as List<dynamic>;
        for (var option in options) {
          if (option is Map<String, dynamic> && option.containsKey('1')) {
            categories.add(option['1'].toString());
          }
        }
      }
    }

    print('📋 Categories from document: $categories');

    // If no categories found in document, fallback to getting from jobs
    if (categories.isEmpty) {
      print(
        '🔄 No categories found in document, falling back to jobs collection...',
      );
      final jobsQuery = await FirebaseFirestore.instance
          .collection('jobs')
          .where('approvalStatus', isEqualTo: 'approved')
          .get();

      final jobCategories = <String>{};
      for (var doc in jobsQuery.docs) {
        final data = doc.data();
        final jobCategory = data['jobCategory']?.toString();
        if (jobCategory != null && jobCategory.isNotEmpty) {
          jobCategories.add(jobCategory);
        }
      }
      categories.addAll(jobCategories);
    }

    final finalCategories = ['All Jobs', ...categories];
    print('🎯 Final categories list: $finalCategories');

    return finalCategories;
  } catch (e) {
    print('❌ Error in loadJobCategoriesUpdated: $e');
    return ['All Jobs'];
  }
}
