import 'package:cloud_firestore/cloud_firestore.dart';
import '../dropdown_options/dropdown_options.dart';
import '../dropdown_options/qualification.dart';
import '../dropdown_options/job_category.dart';
import '../dropdown_options/job_type.dart';
import '../dropdown_options/designation.dart';

class DropdownService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get dropdown options - prioritize Firebase for qualifications, local for others
  static Future<List<String>> getDropdownOptions(String category) async {
    try {
      // For post job categories and qualifications, try Firebase first
      final postJobCategories = [
        'job_categories',
        'jobCategory',
        'job_types',
        'jobType',
        'departments',
        'department',
        'experience_levels',
        'experienceLevel',
        'industry_types',
        'industryType',
        'salary_ranges',
        'salaryRange',
        'work_modes',
        'workMode',
        'qualifications',
        'qualification',
      ];

      if (postJobCategories.contains(category.toLowerCase()) ||
          postJobCategories.contains(category)) {
        print('🔍 DropdownService: Prioritizing Firebase for $category...');

        try {
          // Map category name to actual Firebase document name
          final documentName = _mapCategoryToDocumentName(category);

          print(
            '🔍 DropdownService: Fetching $category from Firebase (mapped to: $documentName)',
          );

          // Always fetch fresh data from Firebase - no cache
          final doc = await _firestore
              .collection('dropdown_options')
              .doc(documentName)
              .get()
              .timeout(const Duration(seconds: 5));

          print('📄 DropdownService: $category document exists: ${doc.exists}');

          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;
            print('📊 DropdownService: $category document data: $data');

            // Method 1: Check for 'options' field (new structure)
            if (data.containsKey('options')) {
              final options = List<String>.from(data['options'] ?? []);
              if (options.isNotEmpty) {
                print(
                  '✅ DropdownService: Found ${options.length} $category from Firebase options field: $options',
                );
                return options;
              }
            }

            // Method 2: Check for field matching the category (existing structure)
            final fieldName = _mapCategoryToFieldName(category);
            if (data.containsKey(fieldName)) {
              final options = List<String>.from(data[fieldName] ?? []);
              if (options.isNotEmpty) {
                print(
                  '✅ DropdownService: Found ${options.length} $category from Firebase field $fieldName: $options',
                );
                return options;
              }
            }

            // Method 3: Check for direct field name
            if (data.containsKey(category)) {
              final options = List<String>.from(data[category] ?? []);
              if (options.isNotEmpty) {
                print(
                  '✅ DropdownService: Found ${options.length} $category from Firebase direct field: $options',
                );
                return options;
              }
            }
          }

          // Try to find data in any document
          print('🔍 DropdownService: Searching all documents for $category...');
          final querySnapshot = await _firestore
              .collection('dropdown_options')
              .get();
          for (final doc in querySnapshot.docs) {
            final data = doc.data();
            final fieldName = _mapCategoryToFieldName(category);
            if (data.containsKey(fieldName) && data[fieldName] is List) {
              final options = List<String>.from(data[fieldName]);
              if (options.isNotEmpty) {
                print(
                  '✅ DropdownService: Found ${options.length} $category in document ${doc.id} field $fieldName',
                );
                return options;
              }
            }
            // Also check for direct field name
            if (data.containsKey(category) && data[category] is List) {
              final options = List<String>.from(data[category]);
              if (options.isNotEmpty) {
                print(
                  '✅ DropdownService: Found ${options.length} $category in document ${doc.id} direct field',
                );
                return options;
              }
            }
          }

          print(
            '⚠️ DropdownService: No $category found in Firebase, using local options',
          );
        } catch (e) {
          print(
            '❌ DropdownService: Error fetching $category from Firebase: $e',
          );
        }

        // Fallback to local options for post job categories
        final localOptions = DropdownOptions.getOptions(category);
        if (localOptions.isNotEmpty) {
          print(
            '✅ DropdownService: Using local $category as fallback: ${localOptions.length} items',
          );
          return localOptions;
        }

        // Final fallback to default options
        final defaultOptions = getDefaultOptions(category);
        if (defaultOptions.isNotEmpty) {
          print(
            '✅ DropdownService: Using default $category options: ${defaultOptions.length} items',
          );
          return defaultOptions;
        }
      }

      // For other categories, try local options first
      final localOptions = DropdownOptions.getOptions(category);
      if (localOptions.isNotEmpty) {
        print(
          '✅ DropdownService: Using local options for $category: ${localOptions.length} items',
        );
        return localOptions;
      }

      // Fallback to Firebase if no local options found
      print(
        '🔍 DropdownService: No local options for $category, trying Firebase...',
      );

      // Map category name to actual Firebase document name
      final documentName = _mapCategoryToDocumentName(category);

      print(
        '🔍 DropdownService: Fetching fresh options for category: $category (mapped to: $documentName)',
      );

      // Always fetch fresh data from Firebase - no cache
      final doc = await _firestore
          .collection('dropdown_options')
          .doc(documentName)
          .get()
          .timeout(const Duration(seconds: 5)); // Add timeout

      print('📄 DropdownService: Document exists: ${doc.exists}');
      print('📄 DropdownService: Document ID: ${doc.id}');

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        print('📊 DropdownService: Document data keys: ${data.keys.toList()}');
        print('📊 DropdownService: Full document data: $data');

        // Method 1: Check for 'options' field (new structure)
        if (data.containsKey('options')) {
          final options = List<String>.from(data['options'] ?? []);
          print(
            '✅ DropdownService: Found ${options.length} options for $category from options field: $options',
          );
          return options;
        }

        // Method 2: Check for field matching the category (existing structure)
        final fieldName = _mapCategoryToFieldName(category);
        if (data.containsKey(fieldName)) {
          final options = List<String>.from(data[fieldName] ?? []);
          print(
            '✅ DropdownService: Found ${options.length} options for $category from field $fieldName: $options',
          );
          return options;
        }

        print(
          '⚠️ DropdownService: No options or matching field found in document for category: $category',
        );
      } else {
        print(
          '⚠️ DropdownService: Document not found for category: $category (document: $documentName)',
        );

        // Try to find the data in any document as a field
        final querySnapshot = await _firestore
            .collection('dropdown_options')
            .get();
        for (final doc in querySnapshot.docs) {
          final data = doc.data();
          final fieldName = _mapCategoryToFieldName(category);
          if (data.containsKey(fieldName) && data[fieldName] is List) {
            final options = List<String>.from(data[fieldName]);
            print(
              '✅ DropdownService: Found ${options.length} options for $category in document ${doc.id} field $fieldName',
            );
            return options;
          }
        }
      }

      // Let's also check what documents actually exist
      final allDocs = await _firestore.collection('dropdown_options').get();
      print(
        '📋 DropdownService: Available documents: ${allDocs.docs.map((d) => d.id).toList()}',
      );

      // If no document found, return some default options to prevent empty dropdowns
      return getDefaultOptions(category);
    } catch (e) {
      print(
        '❌ DropdownService: Error fetching dropdown options for $category: $e',
      );
      print('❌ DropdownService: Error type: ${e.runtimeType}');

      // Return default options on error to prevent empty dropdowns
      return getDefaultOptions(category);
    }
  }

  /// Map app category names to Firebase document names
  static String _mapCategoryToDocumentName(String category) {
    switch (category) {
      case 'qualifications':
        return 'qualification';
      case 'departments':
        return 'department';
      case 'designations':
        return 'designation';
      case 'company_types':
        return 'companyType';
      case 'candidate_departments':
        return 'candidateDepartment';
      case 'industry_types':
        return 'industryType';
      case 'job_categories':
        return 'jobCategory';
      case 'job_types':
        return 'jobType';
      case 'experience_levels':
        return 'experienceLevel';
      case 'salary_ranges':
        return 'salaryRange';
      case 'work_modes':
        return 'workMode';
      case 'skills':
        return 'skill';
      case 'locations':
        return 'location';
      case 'company_sizes':
        return 'companySize';
      case 'education_levels':
        return 'educationLevel';
      case 'languages':
        return 'language';
      default:
        return category; // Return as-is if no mapping found
    }
  }

  /// Map app category names to Firebase field names (for existing structure)
  static String _mapCategoryToFieldName(String category) {
    switch (category) {
      case 'company_types':
        return 'company_type';
      case 'qualifications':
        return 'qualification';
      case 'departments':
        return 'department';
      case 'designations':
        return 'designation';
      case 'candidate_departments':
        return 'candidate_department';
      case 'industry_types':
        return 'industry_type';
      case 'job_categories':
        return 'job_category';
      case 'job_types':
        return 'job_type';
      case 'experience_levels':
        return 'experience_level';
      case 'salary_ranges':
        return 'salary_range';
      case 'work_modes':
        return 'work_mode';
      case 'skills':
        return 'skill';
      case 'locations':
        return 'location';
      case 'company_sizes':
        return 'company_size';
      case 'education_levels':
        return 'education_level';
      case 'languages':
        return 'language';
      default:
        return category; // Return as-is if no mapping found
    }
  }

  /// Get default options for a category when Firebase data is not available
  static List<String> getDefaultOptions(String category) {
    // First try to get from local dropdown options
    final localOptions = DropdownOptions.getOptions(category);
    if (localOptions.isNotEmpty) {
      return localOptions;
    }

    // Fallback to hardcoded defaults
    switch (category) {
      case 'qualifications':
      case 'qualification':
        return QualificationOptions.values;
      case 'departments':
      case 'department':
      case 'candidate_departments':
      case 'candidateDepartment':
        return ['IT', 'HR', 'Finance', 'Marketing', 'Sales', 'Operations'];
      case 'designations':
      case 'designation':
        return DesignationOptions.values;
      case 'company_types':
      case 'companyType':
        return [
          'Information Technology (IT)',
          'Automobile',
          'Automotive',
          'Pharmaceutical',
          'Healthcare',
          'Banking & Finance',
          'Insurance',
          'Manufacturing',
          'Retail',
          'E-commerce',
          'Education',
          'Consulting',
          'Real Estate',
          'Construction',
          'Telecommunications',
          'Media & Entertainment',
          'Food & Beverage',
          'Textile',
          'Chemical',
          'Oil & Gas',
          'Agriculture',
          'Logistics',
          'Government',
          'Non-Profit',
          'Startup',
          'Other',
        ];
      case 'industry_types':
      case 'industryType':
        return [
          'Technology',
          'Healthcare',
          'Finance',
          'Education',
          'Retail',
          'Manufacturing',
        ];
      case 'job_categories':
      case 'jobCategory':
        return JobCategoryOptions.values;
      case 'job_types':
      case 'jobType':
        return JobTypeOptions.values;
      case 'experience_levels':
      case 'experienceLevel':
        return ['Entry Level', 'Mid Level', 'Senior Level', 'Executive'];
      case 'salary_ranges':
      case 'salaryRange':
        return [
          'Below 3 LPA',
          '3-5 LPA',
          '5-8 LPA',
          '8-12 LPA',
          '12-18 LPA',
          '18-25 LPA',
          'Above 25 LPA',
        ];
      case 'work_modes':
      case 'workMode':
        return ['Work from Office', 'Work from Home', 'Hybrid'];
      case 'skills':
      case 'skill':
        return [
          'Java',
          'Python',
          'JavaScript',
          'React',
          'Node.js',
          'SQL',
          'Project Management',
          'Communication',
        ];
      case 'locations':
      case 'location':
        return [
          'Mumbai',
          'Delhi',
          'Bangalore',
          'Chennai',
          'Hyderabad',
          'Pune',
          'Kolkata',
          'Ahmedabad',
        ];
      case 'company_sizes':
      case 'companySize':
        return [
          'Startup (1-50)',
          'Small (51-200)',
          'Medium (201-1000)',
          'Large (1000+)',
        ];
      case 'education_levels':
      case 'educationLevel':
        return ['High School', 'Diploma', 'Bachelor\'s', 'Master\'s', 'PhD'];
      case 'languages':
      case 'language':
        return [
          'English',
          'Hindi',
          'Tamil',
          'Telugu',
          'Marathi',
          'Bengali',
          'Gujarati',
          'Kannada',
        ];
      default:
        return [];
    }
  }

  /// Get all dropdown options at once - prioritize Firebase for qualifications, merge with local
  static Future<Map<String, List<String>>> getAllDropdownOptions() async {
    try {
      print(
        '🔍 DropdownService: Getting all dropdown options (Firebase + local)...',
      );

      // Start with local options
      final result = DropdownOptions.getAllOptions();
      print(
        '📊 DropdownService: Loaded ${result.length} categories from local options',
      );

      // Try to merge with Firebase options, prioritizing qualifications
      try {
        final querySnapshot = await _firestore
            .collection('dropdown_options')
            .get();

        print(
          '📄 DropdownService: Found ${querySnapshot.docs.length} documents in dropdown_options',
        );

        if (querySnapshot.docs.isNotEmpty) {
          // Process each document - check for both document-based and field-based structure
          for (final doc in querySnapshot.docs) {
            final data = doc.data();

            // Method 1: Document has 'options' field (new structure)
            if (data.containsKey('options')) {
              final options = List<String>.from(data['options'] ?? []);
              String appCategoryName = _mapDocumentNameToCategory(doc.id);

              // For qualifications, always use Firebase if available
              if (appCategoryName == 'qualifications' && options.isNotEmpty) {
                result[appCategoryName] = options;
                print(
                  '📊 DropdownService: Updated qualifications from Firebase ${doc.id}: ${options.length} options',
                );
              } else if (!result.containsKey(appCategoryName)) {
                // Only use Firebase data if we don't have local data for other categories
                result[appCategoryName] = options;
                print(
                  '📊 DropdownService: Added Firebase ${doc.id} -> $appCategoryName: ${options.length} options',
                );
              }
            } else {
              // Method 2: Document has individual fields for each dropdown type (existing structure)
              data.forEach((fieldName, fieldValue) {
                if (fieldValue is List) {
                  final options = List<String>.from(fieldValue);
                  // Map field names to app category names
                  String appCategoryName = _mapFieldNameToCategory(fieldName);

                  // For qualifications, always use Firebase if available
                  if (appCategoryName == 'qualifications' &&
                      options.isNotEmpty) {
                    result[appCategoryName] = options;
                    print(
                      '📊 DropdownService: Updated qualifications from Firebase field $fieldName: ${options.length} options',
                    );
                  } else if (!result.containsKey(appCategoryName)) {
                    // Only use Firebase data if we don't have local data for other categories
                    result[appCategoryName] = options;
                    print(
                      '📊 DropdownService: Added Firebase field $fieldName -> $appCategoryName: ${options.length} options',
                    );
                  }
                }
              });
            }
          }
        }
      } catch (e) {
        print(
          '⚠️ DropdownService: Error fetching Firebase options (using local only): $e',
        );
      }

      print(
        '✅ DropdownService: Successfully loaded ${result.length} total categories',
      );
      return result;
    } catch (e) {
      print('❌ DropdownService: Error in getAllDropdownOptions: $e');
      // Return at least the local options
      return DropdownOptions.getAllOptions();
    }
  }

  /// Map Firebase document names back to app category names
  static String _mapDocumentNameToCategory(String documentName) {
    switch (documentName) {
      case 'qualification':
        return 'qualifications';
      case 'department':
        return 'departments';
      case 'designation':
        return 'designations';
      case 'companyType':
        return 'company_types';
      case 'candidateDepartment':
        return 'candidate_departments';
      case 'industryType':
        return 'industry_types';
      case 'jobCategory':
        return 'job_categories';
      case 'jobType':
        return 'job_types';
      default:
        return documentName; // Return as-is if no mapping found
    }
  }

  /// Map Firebase field names to app category names (for existing structure)
  static String _mapFieldNameToCategory(String fieldName) {
    switch (fieldName) {
      case 'company_type':
        return 'company_types';
      case 'qualification':
        return 'qualifications';
      case 'department':
        return 'departments';
      case 'designation':
        return 'designations';
      case 'candidate_department':
        return 'candidate_departments';
      case 'industry_type':
        return 'industry_types';
      case 'job_category':
        return 'job_categories';
      case 'job_type':
        return 'job_types';
      case 'experience_level':
        return 'experience_levels';
      case 'salary_range':
        return 'salary_ranges';
      case 'work_mode':
        return 'work_modes';
      case 'skill':
        return 'skills';
      case 'location':
        return 'locations';
      case 'company_size':
        return 'company_sizes';
      case 'education_level':
        return 'education_levels';
      case 'language':
        return 'languages';
      default:
        return fieldName; // Return as-is if no mapping found
    }
  }

  /// Test Firebase connectivity and permissions
  static Future<Map<String, dynamic>> testFirebaseConnection() async {
    final result = <String, dynamic>{
      'canReadDropdownOptions': false,
      'canReadAdminSettings': false,
      'dropdownOptionsExists': false,
      'adminSettingsExists': false,
      'error': null,
    };

    try {
      print('🔍 Testing Firebase connection...');

      // Test dropdown_options collection
      try {
        final dropdownQuery = await _firestore
            .collection('dropdown_options')
            .limit(1)
            .get();
        result['canReadDropdownOptions'] = true;
        result['dropdownOptionsExists'] = dropdownQuery.docs.isNotEmpty;
        print('✅ Can read dropdown_options collection');
      } catch (e) {
        result['error'] = 'Cannot read dropdown_options: $e';
        print('❌ Cannot read dropdown_options: $e');
      }

      // Test admin_settings collection
      try {
        final adminDoc = await _firestore
            .collection('admin_settings')
            .doc('dropdown_management')
            .get();
        result['canReadAdminSettings'] = true;
        result['adminSettingsExists'] = adminDoc.exists;
        print('✅ Can read admin_settings collection');
      } catch (e) {
        result['error'] =
            (result['error'] ?? '') + '\nCannot read admin_settings: $e';
        print('❌ Cannot read admin_settings: $e');
      }

      return result;
    } catch (e) {
      result['error'] = 'General Firebase error: $e';
      print('❌ General Firebase error: $e');
      return result;
    }
  }

  /// Listen to real-time updates from Firebase
  static Stream<Map<String, List<String>>> getDropdownOptionsStream() {
    return _firestore.collection('dropdown_options').snapshots().map((
      querySnapshot,
    ) {
      Map<String, List<String>> options = {};

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final optionsList = List<String>.from(data['options'] ?? []);

        // Map Firebase document names back to app category names
        String appCategoryName = _mapDocumentNameToCategory(doc.id);
        options[appCategoryName] = optionsList;
      }

      return options;
    });
  }
}
