import 'package:cloud_firestore/cloud_firestore.dart';

/// Initialize dropdown management data in Firebase
/// This should be run once by an admin to set up the dropdown options
class DropdownDataInitializer {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initializeDropdownData() async {
    try {
      await _firestore
          .collection('admin_settings')
          .doc('dropdown_management')
          .set({
            'candidate_registration': {
              'qualifications': [
                '10th Pass',
                '12th Pass',
                'Diploma',
                'Bachelor\'s Degree (B.A/B.Sc/B.Com/B.Tech/BE)',
                'Master\'s Degree (M.A/M.Sc/M.Com/M.Tech/ME)',
                'MBA',
                'PhD',
                'Professional Certification',
                'Other',
              ],
              'departments': [
                'Information Technology',
                'Human Resources',
                'Finance & Accounting',
                'Marketing & Sales',
                'Operations',
                'Customer Service',
                'Administration',
                'Engineering',
                'Design & Creative',
                'Legal',
                'Research & Development',
                'Quality Assurance',
                'Supply Chain',
                'Business Development',
                'Data Science',
                'Digital Marketing',
                'Content Writing',
                'Other',
              ],
              'designations': [
                'Software Engineer',
                'Senior Software Engineer',
                'Team Lead',
                'Project Manager',
                'Business Analyst',
                'HR Executive',
                'HR Manager',
                'Marketing Executive',
                'Marketing Manager',
                'Sales Executive',
                'Sales Manager',
                'Customer Support Executive',
                'Customer Support Manager',
                'Finance Executive',
                'Accountant',
                'Operations Executive',
                'Operations Manager',
                'Data Analyst',
                'Data Scientist',
                'UI/UX Designer',
                'Graphic Designer',
                'Content Writer',
                'Digital Marketing Executive',
                'SEO Specialist',
                'Quality Analyst',
                'Business Development Executive',
                'Administrative Assistant',
                'Office Manager',
                'Intern',
                'Trainee',
                'Other',
              ],
              'company_types': [
                'Startup (1-50 employees)',
                'Small Business (51-200 employees)',
                'Medium Enterprise (201-1000 employees)',
                'Large Corporation (1000+ employees)',
                'Government Organization',
                'Non-Profit Organization',
                'Educational Institution',
                'Healthcare Organization',
                'Financial Institution',
                'Technology Company',
                'Manufacturing Company',
                'Retail Company',
                'Consulting Firm',
                'Other',
              ],
            },
            'job_posting': {
              'departments': [
                'Company',
                'Banking & Finance',
                'Education & Training',
                'Healthcare & Medical',
                'Hospitality & Tourism',
                'Government & Public Sector',
                'Retail & E-commerce',
                'Information Technology',
                'Manufacturing',
                'Real Estate',
                'Media & Entertainment',
                'Transportation & Logistics',
                'Other',
              ],
              'job_categories': [
                {
                  'name': 'Company Jobs',
                  'key': 'company',
                  'industries': [
                    'Information Technology and Services',
                    'Computer Software',
                    'Computer Hardware',
                    'Engineering',
                    'Manufacturing',
                    'Consulting',
                    'Marketing and Advertising',
                    'Human Resources',
                    'Business Development',
                    'Operations',
                    'Finance',
                    'Other',
                  ],
                },
                {
                  'name': 'Bank/NBFC Jobs',
                  'key': 'banking',
                  'industries': [
                    'Banking',
                    'Financial Services',
                    'Investment Banking',
                    'Insurance',
                    'Capital Markets',
                    'Credit & Lending',
                    'Wealth Management',
                    'Risk Management',
                    'Compliance',
                    'Other',
                  ],
                },
                {
                  'name': 'School Jobs',
                  'key': 'education',
                  'industries': [
                    'Education Management',
                    'Higher Education',
                    'Primary & Secondary Education',
                    'E-learning',
                    'Training & Development',
                    'Educational Technology',
                    'Research',
                    'Administration',
                    'Other',
                  ],
                },
                {
                  'name': 'Hospital Jobs',
                  'key': 'healthcare',
                  'industries': [
                    'Hospital & Health Care',
                    'Medical Practice',
                    'Medical Devices',
                    'Pharmaceuticals',
                    'Mental Health Care',
                    'Nursing',
                    'Laboratory Services',
                    'Healthcare Administration',
                    'Medical Research',
                    'Other',
                  ],
                },
                {
                  'name': 'Hotel/Bar Jobs',
                  'key': 'hospitality',
                  'industries': [
                    'Hospitality',
                    'Food & Beverages',
                    'Tourism',
                    'Event Management',
                    'Restaurant Management',
                    'Hotel Management',
                    'Travel Services',
                    'Entertainment',
                    'Other',
                  ],
                },
                {
                  'name': 'Govt Jobs Info',
                  'key': 'government',
                  'industries': [
                    'Government Administration',
                    'Public Policy',
                    'Defense',
                    'Law Enforcement',
                    'Public Health',
                    'Education',
                    'Transportation',
                    'Utilities',
                    'Social Services',
                    'Other',
                  ],
                },
                {
                  'name': 'Mall/Shopkeeper Jobs',
                  'key': 'retail',
                  'industries': [
                    'Retail',
                    'E-commerce',
                    'Fashion & Apparel',
                    'Consumer Goods',
                    'Wholesale',
                    'Supply Chain',
                    'Inventory Management',
                    'Customer Service',
                    'Sales',
                    'Other',
                  ],
                },
              ],
              'job_types': [
                'Full Time',
                'Part Time',
                'Contract',
                'Internship',
                'Freelance',
                'Remote',
                'Hybrid',
                'Temporary',
                'Seasonal',
              ],
            },
            'created_at': FieldValue.serverTimestamp(),
            'updated_at': FieldValue.serverTimestamp(),
            'version': '1.0',
          });

      print('Dropdown management data initialized successfully!');
    } catch (e) {
      print('Error initializing dropdown data: $e');
      rethrow;
    }
  }

  /// Update specific dropdown category
  static Future<void> updateDropdownCategory(
    String section, // 'candidate_registration' or 'job_posting'
    String category, // 'qualifications', 'departments', etc.
    List<String> values,
  ) async {
    try {
      await _firestore
          .collection('admin_settings')
          .doc('dropdown_management')
          .update({
            '$section.$category': values,
            'updated_at': FieldValue.serverTimestamp(),
          });

      print('Updated $section.$category successfully!');
    } catch (e) {
      print('Error updating dropdown category: $e');
      rethrow;
    }
  }

  /// Add new option to a dropdown category
  static Future<void> addDropdownOption(
    String section,
    String category,
    String newOption,
  ) async {
    try {
      await _firestore
          .collection('admin_settings')
          .doc('dropdown_management')
          .update({
            '$section.$category': FieldValue.arrayUnion([newOption]),
            'updated_at': FieldValue.serverTimestamp(),
          });

      print('Added "$newOption" to $section.$category successfully!');
    } catch (e) {
      print('Error adding dropdown option: $e');
      rethrow;
    }
  }

  /// Remove option from a dropdown category
  static Future<void> removeDropdownOption(
    String section,
    String category,
    String optionToRemove,
  ) async {
    try {
      await _firestore
          .collection('admin_settings')
          .doc('dropdown_management')
          .update({
            '$section.$category': FieldValue.arrayRemove([optionToRemove]),
            'updated_at': FieldValue.serverTimestamp(),
          });

      print('Removed "$optionToRemove" from $section.$category successfully!');
    } catch (e) {
      print('Error removing dropdown option: $e');
      rethrow;
    }
  }
}
