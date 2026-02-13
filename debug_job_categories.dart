import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print('🔥 Firebase initialized successfully');

    await debugJobCategories();
  } catch (e) {
    print('❌ Error: $e');
  }
}

Future<void> debugJobCategories() async {
  print('\n🔍 Debugging Job Categories');
  print('=' * 50);

  try {
    // Check the jobCategory document
    print('📋 Checking dropdown_options/jobCategory document...');

    final jobCategoryDoc = await FirebaseFirestore.instance
        .collection('dropdown_options')
        .doc('jobCategory')
        .get();

    if (jobCategoryDoc.exists) {
      final data = jobCategoryDoc.data();
      print('✅ jobCategory document exists!');
      print('📊 Document data: $data');
      print('📊 Document keys: ${data?.keys.toList()}');

      if (data != null) {
        for (var key in data.keys) {
          final value = data[key];
          print('  - Key: "$key" | Value: $value (${value.runtimeType})');

          if (value is List) {
            print('    List contents:');
            for (int i = 0; i < value.length; i++) {
              print('      [$i]: ${value[i]} (${value[i].runtimeType})');
            }
          } else if (value is Map) {
            print('    Map contents:');
            for (var mapKey in value.keys) {
              print(
                '      "$mapKey": ${value[mapKey]} (${value[mapKey].runtimeType})',
              );
            }
          }
        }
      }
    } else {
      print('❌ jobCategory document does not exist!');

      // Check if dropdown_options collection exists
      print('\n🔍 Checking dropdown_options collection...');
      final dropdownDocs = await FirebaseFirestore.instance
          .collection('dropdown_options')
          .get();

      print(
        '📊 dropdown_options collection has ${dropdownDocs.docs.length} documents:',
      );
      for (final doc in dropdownDocs.docs) {
        print('  - ${doc.id}');
      }
    }

    // Also check what job categories are actually in the jobs
    print('\n🔍 Checking job categories from actual jobs...');
    final jobsQuery = await FirebaseFirestore.instance
        .collection('jobs')
        .where('approvalStatus', isEqualTo: 'approved')
        .limit(10)
        .get();

    final jobCategories = <String>{};

    for (final doc in jobsQuery.docs) {
      final data = doc.data();
      final jobCategory = data['jobCategory']?.toString();
      final department = data['department']?.toString();

      if (jobCategory != null && jobCategory.isNotEmpty) {
        jobCategories.add(jobCategory);
      }
      if (department != null && department.isNotEmpty) {
        jobCategories.add(department);
      }
    }

    print(
      '📊 Job categories found in actual jobs: ${jobCategories.toList()..sort()}',
    );
  } catch (e) {
    print('❌ Error debugging job categories: $e');
  }
}
