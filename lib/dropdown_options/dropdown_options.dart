/// Centralized dropdown options
import 'qualification.dart';
import 'job_category.dart';
import 'job_type.dart';
import 'designation.dart';

/// Centralized access to all dropdown options
class DropdownOptions {
  /// Get dropdown options by category name
  static List<String> getOptions(String category) {
    switch (category.toLowerCase()) {
      case 'qualification':
      case 'qualifications':
        return QualificationOptions.values;
      case 'jobcategory':
      case 'job_category':
      case 'job_categories':
        return JobCategoryOptions.values;
      case 'jobtype':
      case 'job_type':
      case 'job_types':
        return JobTypeOptions.values;
      case 'designation':
      case 'designations':
        return DesignationOptions.values;
      default:
        return [];
    }
  }

  /// Get all dropdown options as a map
  static Map<String, List<String>> getAllOptions() {
    return {
      'qualification': QualificationOptions.values,
      'jobCategory': JobCategoryOptions.values,
      'jobType': JobTypeOptions.values,
      'designation': DesignationOptions.values,
    };
  }
}
