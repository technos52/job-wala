import 'package:cloud_firestore/cloud_firestore.dart';

class InitSampleDropdownData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize sample dropdown data in Firebase
  static Future<void> initializeSampleData() async {
    try {
      print('🔄 Initializing sample dropdown data...');

      // Sample data for each dropdown category - using correct Firebase document names
      final sampleData = {
        'qualification': [
          '10th Pass',
          '12th Pass',
          'Diploma',
          'Bachelor\'s Degree',
          'Master\'s Degree',
          'PhD',
          'Professional Certification',
          'Other',
        ],
        'department': [
          'IT',
          'HR',
          'Finance',
          'Marketing',
          'Sales',
          'Operations',
          'Customer Service',
          'Administration',
          'Engineering',
          'Design',
        ],
        'designation': [
          'Software Engineer',
          'Senior Software Engineer',
          'Team Lead',
          'Project Manager',
          'Business Analyst',
          'HR Executive',
          'Marketing Executive',
          'Sales Executive',
          'Customer Support Executive',
          'Operations Manager',
        ],
        'companyType': [
          'Startup',
          'Small Business',
          'Medium Enterprise',
          'Large Corporation',
          'Government',
          'Non-Profit',
          'Consulting',
          'Other',
        ],
        'candidateDepartment': [
          'Information Technology',
          'Human Resources',
          'Finance & Accounting',
          'Marketing & Sales',
          'Operations',
          'Customer Service',
          'Engineering',
          'Design & Creative',
          'Legal',
          'Administration',
        ],
        'industryType': [
          'Information Technology',
          'Healthcare',
          'Finance & Banking',
          'Education',
          'Retail & E-commerce',
          'Manufacturing',
          'Hospitality & Tourism',
          'Government & Public Sector',
          'Non-Profit',
          'Consulting Services',
        ],
        'jobCategory': [
          'Software Development',
          'Data Science',
          'Digital Marketing',
          'Business Analysis',
          'Project Management',
          'Customer Support',
          'Sales & Business Development',
          'Human Resources',
          'Finance & Accounting',
          'Operations Management',
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
      };

      // Create/update each document in the dropdown_options collection
      for (final entry in sampleData.entries) {
        await _firestore.collection('dropdown_options').doc(entry.key).set({
          'options': entry.value,
          'lastUpdated': FieldValue.serverTimestamp(),
          'createdBy': 'system_init',
        });

        print('✅ Created ${entry.key} with ${entry.value.length} options');
      }

      print('🎉 Sample dropdown data initialized successfully!');
    } catch (e) {
      print('❌ Error initializing sample data: $e');
      rethrow;
    }
  }

  /// Clear all existing dropdown data and reinitialize with correct document names
  static Future<void> reinitializeWithCorrectNames() async {
    try {
      print('🔄 Clearing existing dropdown data...');

      // Get all existing documents
      final snapshot = await _firestore.collection('dropdown_options').get();

      // Delete all existing documents
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
        print('🗑️ Deleted document: ${doc.id}');
      }

      print('✅ Cleared all existing dropdown data');

      // Now initialize with correct names
      await initializeSampleData();
    } catch (e) {
      print('❌ Error reinitializing dropdown data: $e');
      rethrow;
    }
  }

  /// Check if dropdown data exists
  static Future<bool> checkIfDataExists() async {
    try {
      final snapshot = await _firestore
          .collection('dropdown_options')
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('❌ Error checking dropdown data: $e');
      return false;
    }
  }
}
