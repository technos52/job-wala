import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/services/dropdown_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Testing Post Job Dropdowns Firebase Integration...');

  // First, set up the Firebase data
  print('\n📝 Setting up Firebase dropdown data...');
  await setupPostJobDropdowns();

  // Wait a moment for Firebase to process
  await Future.delayed(Duration(seconds: 2));

  // Test each post job dropdown category
  print('\n🧪 Testing Post Job Dropdown Categories...');

  final postJobCategories = [
    'job_categories',
    'job_types',
    'departments',
    'experience_levels',
    'industry_types',
    'salary_ranges',
    'work_modes',
  ];

  bool allTestsPassed = true;

  for (final category in postJobCategories) {
    try {
      print('\n🔍 Testing $category...');
      final options = await DropdownService.getDropdownOptions(category);

      if (options.isNotEmpty) {
        print('✅ $category: ${options.length} options loaded');
        print(
          '   Sample: ${options.take(3).join(', ')}${options.length > 3 ? '...' : ''}',
        );
      } else {
        print('❌ $category: No options found');
        allTestsPassed = false;
      }
    } catch (e) {
      print('❌ $category: Error - $e');
      allTestsPassed = false;
    }
  }

  // Test Firebase connection
  print('\n🔍 Testing Firebase Connection...');
  final connectionTest = await DropdownService.testFirebaseConnection();
  print('📊 Connection Test: $connectionTest');

  // Final result
  print('\n' + '=' * 50);
  if (allTestsPassed) {
    print('🎉 ALL POST JOB DROPDOWN TESTS PASSED!');
    print('💡 Post job dropdowns should now work properly in the app.');
  } else {
    print('❌ SOME TESTS FAILED!');
    print(
      '💡 Check the errors above and ensure Firebase is properly configured.',
    );
  }
  print('=' * 50);
}

Future<void> setupPostJobDropdowns() async {
  final firestore = FirebaseFirestore.instance;

  final postJobDropdowns = {
    // Job Categories
    'jobCategory': [
      'Software Development',
      'Web Development',
      'Mobile Development',
      'Data Science',
      'Machine Learning',
      'DevOps',
      'Quality Assurance',
      'UI/UX Design',
      'Product Management',
      'Project Management',
      'Business Analysis',
      'Marketing',
      'Digital Marketing',
      'Sales',
      'Human Resources',
      'Finance',
      'Operations',
      'Consulting',
      'Other',
    ],

    // Job Types
    'jobType': [
      'Full Time',
      'Part Time',
      'Contract',
      'Freelance',
      'Internship',
      'Remote',
      'Hybrid',
    ],

    // Departments
    'department': [
      'Information Technology',
      'Software Development',
      'Engineering',
      'Marketing',
      'Sales',
      'Human Resources',
      'Finance',
      'Operations',
      'Legal',
      'Other',
    ],

    // Experience Levels
    'experienceLevel': [
      'Entry Level (0-1 years)',
      'Junior Level (1-3 years)',
      'Mid Level (3-5 years)',
      'Senior Level (5-8 years)',
      'Lead Level (8+ years)',
      'Executive Level',
    ],

    // Industry Types
    'industryType': [
      'Information Technology',
      'Healthcare',
      'Finance',
      'Education',
      'Retail',
      'Manufacturing',
      'Consulting',
      'Other',
    ],

    // Salary Ranges
    'salaryRange': [
      'Below ₹3 LPA',
      '₹3-5 LPA',
      '₹5-8 LPA',
      '₹8-12 LPA',
      '₹12-18 LPA',
      '₹18-25 LPA',
      'Above ₹25 LPA',
      'Negotiable',
    ],

    // Work Modes
    'workMode': [
      'Work from Office',
      'Work from Home',
      'Hybrid (Office + Remote)',
      'Flexible Location',
    ],
  };

  try {
    for (final entry in postJobDropdowns.entries) {
      final docId = entry.key;
      final options = entry.value;

      await firestore.collection('dropdown_options').doc(docId).set({
        'options': options,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('✅ Setup $docId with ${options.length} options');
    }
  } catch (error) {
    print('❌ Error setting up dropdowns: $error');
  }
}
