import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/services/dropdown_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Debugging Post Job Dropdowns Firebase Integration...');

  // Test Firebase connection
  final connectionTest = await DropdownService.testFirebaseConnection();
  print('📊 Firebase Connection Test Results: $connectionTest');

  // Check what documents exist in dropdown_options
  try {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('dropdown_options').get();

    print('\n📄 Available documents in dropdown_options:');
    for (final doc in querySnapshot.docs) {
      print('  - Document ID: ${doc.id}');
      final data = doc.data();
      print('    Data keys: ${data.keys.toList()}');

      // Check for specific post job dropdown fields
      final postJobFields = [
        'job_category',
        'jobCategory',
        'job_categories',
        'job_type',
        'jobType',
        'job_types',
        'department',
        'departments',
        'experience_level',
        'experienceLevel',
        'experience_levels',
        'industry_type',
        'industryType',
        'industry_types',
      ];

      for (final field in postJobFields) {
        if (data.containsKey(field)) {
          final value = data[field];
          if (value is List) {
            print(
              '    ✅ $field: ${value.length} items - ${value.take(3).toList()}...',
            );
          } else {
            print('    ⚠️ $field: ${value.runtimeType} - $value');
          }
        }
      }

      // Check for 'options' field
      if (data.containsKey('options')) {
        final options = data['options'];
        if (options is List) {
          print(
            '    ✅ options: ${options.length} items - ${options.take(3).toList()}...',
          );
        }
      }
    }

    print('\n🔍 Testing specific dropdown categories for post job:');
    final categories = [
      'job_categories',
      'job_types',
      'departments',
      'experience_levels',
      'industry_types',
    ];

    for (final category in categories) {
      try {
        final options = await DropdownService.getDropdownOptions(category);
        print(
          '✅ $category: ${options.length} options - ${options.take(3).toList()}...',
        );
      } catch (e) {
        print('❌ $category: Error - $e');
      }
    }
  } catch (e) {
    print('❌ Error checking Firebase: $e');
  }
}
