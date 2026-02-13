import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔧 Setting up POST JOB dropdown options in Firebase...');

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
      'Content Marketing',
      'Sales',
      'Customer Success',
      'Human Resources',
      'Finance',
      'Accounting',
      'Operations',
      'Supply Chain',
      'Legal',
      'Consulting',
      'Research',
      'Healthcare',
      'Education',
      'Other',
    ],

    // Job Types
    'jobType': [
      'Full Time',
      'Part Time',
      'Contract',
      'Freelance',
      'Internship',
      'Temporary',
      'Remote',
      'Hybrid',
    ],

    // Departments
    'department': [
      'Information Technology',
      'Software Development',
      'Data Science',
      'Engineering',
      'Product',
      'Design',
      'Marketing',
      'Sales',
      'Customer Success',
      'Human Resources',
      'Finance',
      'Accounting',
      'Operations',
      'Supply Chain',
      'Legal',
      'Administration',
      'Research & Development',
      'Quality Assurance',
      'Business Development',
      'Consulting',
      'Other',
    ],

    // Experience Levels
    'experienceLevel': [
      'Entry Level (0-1 years)',
      'Junior Level (1-3 years)',
      'Mid Level (3-5 years)',
      'Senior Level (5-8 years)',
      'Lead Level (8-12 years)',
      'Principal Level (12+ years)',
      'Executive Level',
    ],

    // Industry Types
    'industryType': [
      'Information Technology',
      'Software & Technology',
      'Financial Services',
      'Banking',
      'Insurance',
      'Healthcare',
      'Pharmaceuticals',
      'Biotechnology',
      'Manufacturing',
      'Automotive',
      'Aerospace',
      'Energy',
      'Oil & Gas',
      'Renewable Energy',
      'Retail',
      'E-commerce',
      'Consumer Goods',
      'Food & Beverage',
      'Hospitality',
      'Travel & Tourism',
      'Real Estate',
      'Construction',
      'Architecture',
      'Education',
      'Training',
      'Media & Entertainment',
      'Advertising',
      'Marketing',
      'Telecommunications',
      'Transportation',
      'Logistics',
      'Supply Chain',
      'Agriculture',
      'Government',
      'Non-Profit',
      'Consulting',
      'Legal Services',
      'Accounting',
      'Human Resources',
      'Startup',
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
      '₹25-35 LPA',
      '₹35-50 LPA',
      'Above ₹50 LPA',
      'Negotiable',
    ],

    // Work Modes
    'workMode': [
      'Work from Office',
      'Work from Home',
      'Hybrid (Office + Remote)',
      'Flexible Location',
      'On-site Client Location',
      'Travel Required',
    ],
  };

  try {
    print('📝 Creating/updating post job dropdown documents...\n');

    for (final entry in postJobDropdowns.entries) {
      final docId = entry.key;
      final options = entry.value;

      print('📄 Creating/updating $docId with ${options.length} options...');

      await firestore.collection('dropdown_options').doc(docId).set({
        'options': options,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('✅ $docId created/updated successfully');
      print(
        '   Sample options: ${options.take(3).join(', ')}${options.length > 3 ? '...' : ''}\n',
      );
    }

    print('🎉 POST JOB dropdown options setup completed!');
    print('💡 All post job dropdowns should now work properly.');

    // Verify the setup
    print('\n🔍 Verifying post job dropdown setup...');
    final snapshot = await firestore.collection('dropdown_options').get();
    print('📊 Total documents in dropdown_options: ${snapshot.docs.length}');

    final postJobDocs = [
      'jobCategory',
      'jobType',
      'department',
      'experienceLevel',
      'industryType',
      'salaryRange',
      'workMode',
    ];

    for (final docId in postJobDocs) {
      final doc = await firestore
          .collection('dropdown_options')
          .doc(docId)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final options = data['options'] as List?;
        print('   ✅ $docId: ${options?.length ?? 0} options');
      } else {
        print('   ❌ $docId: Document not found');
      }
    }
  } catch (error) {
    print('❌ Error setting up post job dropdown options: $error');
  }
}
