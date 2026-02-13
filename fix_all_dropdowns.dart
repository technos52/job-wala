import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/services/dropdown_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔧 Fixing All Dropdown Issues...');
  print('=' * 50);

  // Step 1: Check current Firebase data
  await checkCurrentFirebaseData();

  // Step 2: Set up missing dropdown data
  await setupMissingDropdownData();

  // Step 3: Test DropdownService functionality
  await testDropdownServiceAfterSetup();

  print('=' * 50);
  print('✅ Dropdown fix completed');
  print('💡 Next steps:');
  print('   1. Restart your app');
  print('   2. Check that all dropdowns now load data');
  print('   3. Verify registration forms work properly');
}

Future<void> checkCurrentFirebaseData() async {
  print('\n📋 Step 1: Checking Current Firebase Data');
  print('-' * 40);

  try {
    final collection = await FirebaseFirestore.instance
        .collection('dropdown_options')
        .get();

    print('📊 Found ${collection.docs.length} documents in dropdown_options');

    final requiredDocs = [
      'qualification',
      'jobCategory',
      'jobType',
      'designation',
      'companyType',
      'location',
    ];

    final existingDocs = collection.docs.map((doc) => doc.id).toList();
    final missingDocs = requiredDocs
        .where((doc) => !existingDocs.contains(doc))
        .toList();

    if (missingDocs.isNotEmpty) {
      print('❌ Missing documents: ${missingDocs.join(", ")}');
    } else {
      print('✅ All required documents exist');
    }

    // Check document structure
    for (final doc in collection.docs) {
      final data = doc.data();
      if (data.containsKey('options')) {
        final options = List<String>.from(data['options'] ?? []);
        print('✅ ${doc.id}: ${options.length} options (correct structure)');
      } else {
        print('⚠️ ${doc.id}: Legacy structure (needs migration)');
      }
    }
  } catch (e) {
    print('❌ Error checking Firebase data: $e');
  }
}

Future<void> setupMissingDropdownData() async {
  print('\n📋 Step 2: Setting Up Missing Dropdown Data');
  print('-' * 40);

  final dropdownData = {
    'qualification': [
      'High School',
      'Diploma',
      'Bachelor\'s Degree',
      'Master\'s Degree',
      'PhD',
      'Certificate Course',
      'Professional Certification',
    ],
    'jobCategory': [
      'Software Development',
      'Marketing & Sales',
      'Human Resources',
      'Finance & Accounting',
      'Operations',
      'Customer Service',
      'Design & Creative',
      'Data Science & Analytics',
      'Project Management',
      'Quality Assurance',
      'Business Development',
      'Administration',
    ],
    'jobType': [
      'Full Time',
      'Part Time',
      'Contract',
      'Internship',
      'Freelance',
      'Remote',
      'Hybrid',
    ],
    'designation': [
      'Software Engineer',
      'Senior Software Engineer',
      'Team Lead',
      'Project Manager',
      'Business Analyst',
      'Marketing Executive',
      'Sales Executive',
      'HR Executive',
      'Finance Executive',
      'Operations Executive',
      'Customer Support Executive',
      'Quality Analyst',
      'Data Analyst',
      'UI/UX Designer',
      'Product Manager',
    ],
    'companyType': [
      'Information Technology (IT)',
      'Banking & Finance',
      'Healthcare & Pharmaceuticals',
      'Education & Training',
      'Manufacturing',
      'Retail & E-commerce',
      'Consulting',
      'Real Estate',
      'Automotive',
      'Telecommunications',
      'Media & Entertainment',
      'Food & Beverage',
      'Government',
      'Non-Profit',
      'Startup',
      'Other',
    ],
    'location': [
      'Mumbai',
      'Delhi',
      'Bangalore',
      'Chennai',
      'Hyderabad',
      'Pune',
      'Kolkata',
      'Ahmedabad',
      'Surat',
      'Jaipur',
      'Lucknow',
      'Kanpur',
      'Nagpur',
      'Indore',
      'Thane',
      'Bhopal',
      'Visakhapatnam',
      'Pimpri-Chinchwad',
      'Patna',
      'Vadodara',
    ],
  };

  try {
    for (final entry in dropdownData.entries) {
      final docId = entry.key;
      final options = entry.value;

      print('📝 Setting up $docId with ${options.length} options...');

      await FirebaseFirestore.instance
          .collection('dropdown_options')
          .doc(docId)
          .set({
            'options': options,
            'created_at': FieldValue.serverTimestamp(),
            'updated_at': FieldValue.serverTimestamp(),
          });

      print('✅ $docId setup complete');
    }

    print('🎉 All dropdown data setup completed');
  } catch (e) {
    print('❌ Error setting up dropdown data: $e');
  }
}

Future<void> testDropdownServiceAfterSetup() async {
  print('\n📋 Step 3: Testing DropdownService After Setup');
  print('-' * 40);

  try {
    final allOptions = await DropdownService.getAllDropdownOptions();

    if (allOptions.isEmpty) {
      print('❌ DropdownService still not loading data');
    } else {
      print(
        '✅ DropdownService working! Loaded ${allOptions.length} categories:',
      );

      allOptions.forEach((category, options) {
        print('   $category: ${options.length} options');
        if (options.isNotEmpty) {
          print(
            '     Sample: ${options.take(2).join(", ")}${options.length > 2 ? "..." : ""}',
          );
        }
      });
    }

    // Test specific categories used in registration
    final testCategories = [
      'qualifications',
      'job_categories',
      'job_types',
      'designations',
      'company_types',
    ];

    print('\n🧪 Testing specific categories:');
    for (final category in testCategories) {
      final options = await DropdownService.getDropdownOptions(category);
      if (options.isNotEmpty) {
        print('✅ $category: ${options.length} options');
      } else {
        print('❌ $category: No options loaded');
      }
    }
  } catch (e) {
    print('❌ Error testing DropdownService: $e');
  }
}
