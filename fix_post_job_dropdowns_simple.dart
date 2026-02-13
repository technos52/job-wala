import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔧 Fixing Post Job Dropdowns - Simple Setup');

  final firestore = FirebaseFirestore.instance;

  // Simple dropdown data for post jobs
  final dropdowns = {
    'jobCategory': [
      'Software Development',
      'Marketing',
      'Sales',
      'HR',
      'Finance',
      'Operations',
      'Design',
      'Product Management',
      'Data Science',
      'Other',
    ],

    'jobType': ['Full Time', 'Part Time', 'Contract', 'Internship', 'Remote'],

    'department': [
      'IT',
      'Marketing',
      'Sales',
      'HR',
      'Finance',
      'Operations',
      'Engineering',
      'Design',
      'Other',
    ],

    'experienceLevel': [
      'Entry Level (0-1 years)',
      'Mid Level (2-5 years)',
      'Senior Level (5+ years)',
      'Executive Level',
    ],

    'industryType': [
      'Technology',
      'Healthcare',
      'Finance',
      'Education',
      'Retail',
      'Manufacturing',
      'Other',
    ],

    'salaryRange': [
      'Below ₹3 LPA',
      '₹3-5 LPA',
      '₹5-8 LPA',
      '₹8-12 LPA',
      '₹12-18 LPA',
      '₹18+ LPA',
    ],

    'workMode': ['Work from Office', 'Work from Home', 'Hybrid'],
  };

  try {
    print('📝 Creating dropdown documents...');

    for (final entry in dropdowns.entries) {
      final docId = entry.key;
      final options = entry.value;

      print('Creating $docId...');

      await firestore.collection('dropdown_options').doc(docId).set({
        'options': options,
        'created_at': FieldValue.serverTimestamp(),
      });

      print('✅ $docId: ${options.length} options');
    }

    print('\n🎉 All post job dropdowns created successfully!');

    // Verify
    print('\n🔍 Verifying...');
    final snapshot = await firestore.collection('dropdown_options').get();
    print('Total documents: ${snapshot.docs.length}');

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final options = data['options'] as List?;
      print('${doc.id}: ${options?.length ?? 0} options');
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}
