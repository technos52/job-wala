import 'package:flutter/material.dart';
import 'lib/services/dropdown_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Verifying Post Job Dropdowns...');

  final categories = [
    'job_categories',
    'job_types',
    'departments',
    'experience_levels',
    'industry_types',
    'salary_ranges',
    'work_modes',
  ];

  bool allWorking = true;

  for (final category in categories) {
    try {
      final options = await DropdownService.getDropdownOptions(category);
      if (options.isNotEmpty) {
        print('✅ $category: ${options.length} options');
        print('   Sample: ${options.take(2).join(', ')}...');
      } else {
        print('❌ $category: No options found');
        allWorking = false;
      }
    } catch (e) {
      print('❌ $category: Error - $e');
      allWorking = false;
    }
  }

  print('\n' + '=' * 40);
  if (allWorking) {
    print('🎉 ALL POST JOB DROPDOWNS WORKING!');
  } else {
    print('❌ SOME DROPDOWNS NOT WORKING');
    print('Run: dart fix_post_job_dropdowns_simple.dart');
  }
  print('=' * 40);
}
