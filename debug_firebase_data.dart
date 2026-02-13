import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Comprehensive Firebase data debugging script
void main() async {
  print('🔍 Firebase Data Debugging Script...\n');

  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully\n');

    await debugDropdownDataCollection();
    await debugJobCategoryDocument();
    await debugFilterDocuments();
    await debugJobsCollection();

    print('\n🎉 Firebase debugging completed!');
  } catch (e) {
    print('❌ Error during Firebase debugging: $e');
  }
}

Future<void> debugDropdownDataCollection() async {
  print('📋 Debugging dropdownData Collection...\n');

  try {
    // List all documents in dropdownData collection
    final collection = await FirebaseFirestore.instance
        .collection('dropdownData')
        .get();

    print(
      '📊 Found ${collection.docs.length} documents in dropdownData collection:',
    );

    for (var doc in collection.docs) {
      print('   📄 Document ID: ${doc.id}');
      final data = doc.data();
      print('   📝 Document data keys: ${data.keys.toList()}');

      if (data.containsKey('options')) {
        final options = data['options'];
        print('   📋 Options type: ${options.runtimeType}');
        if (options is List) {
          print('   📊 Options count: ${options.length}');
          if (options.isNotEmpty) {
            print('   📝 First option: ${options.first}');
            print('   📝 First option type: ${options.first.runtimeType}');
            if (options.first is Map) {
              final firstMap = options.first as Map;
              print('   🔑 First option keys: ${firstMap.keys.toList()}');
            }
          }
        }
      }
      print('');
    }
  } catch (e) {
    print('❌ Error debugging dropdownData collection: $e');
  }
}

Future<void> debugJobCategoryDocument() async {
  print('📋 Debugging Job Category Document...\n');

  try {
    final doc = await FirebaseFirestore.instance
        .collection('dropdownData')
        .doc('jobCategory')
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      print('✅ jobCategory document exists');
      print('📝 Document keys: ${data.keys.toList()}');
      print('📄 Full document data: $data');

      if (data.containsKey('options')) {
        final options = data['options'] as List<dynamic>;
        print('📊 Options count: ${options.length}');

        for (int i = 0; i < options.length; i++) {
          final option = options[i];
          print('   Option $i: $option (type: ${option.runtimeType})');

          if (option is Map<String, dynamic>) {
            print('     Keys: ${option.keys.toList()}');
            option.forEach((key, value) {
              print('     $key: $value');
            });
          }
        }
      } else {
        print('❌ No options field found in jobCategory document');
      }
    } else {
      print('❌ jobCategory document does not exist');
    }
  } catch (e) {
    print('❌ Error debugging jobCategory document: $e');
  }
}

Future<void> debugFilterDocuments() async {
  print('🔍 Debugging Filter Documents...\n');

  final filterFields = [
    'jobType',
    'department',
    'candidateDepartment',
    'designation',
    'location',
  ];

  for (String field in filterFields) {
    print('📋 Debugging $field document...');

    try {
      final doc = await FirebaseFirestore.instance
          .collection('dropdownData')
          .doc(field)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        print('   ✅ $field document exists');
        print('   📝 Document keys: ${data.keys.toList()}');
        print('   📄 Full document data: $data');

        if (data.containsKey('options')) {
          final options = data['options'] as List<dynamic>;
          print('   📊 Options count: ${options.length}');

          for (int i = 0; i < options.length && i < 5; i++) {
            final option = options[i];
            print('     Option $i: $option (type: ${option.runtimeType})');

            if (option is Map<String, dynamic>) {
              print('       Keys: ${option.keys.toList()}');
              option.forEach((key, value) {
                print('       $key: $value');
              });
            }
          }

          if (options.length > 5) {
            print('     ... and ${options.length - 5} more options');
          }
        } else {
          print('   ❌ No options field found in $field document');
        }
      } else {
        print('   ❌ $field document does not exist');
      }
    } catch (e) {
      print('   ❌ Error debugging $field document: $e');
    }

    print('');
  }
}

Future<void> debugJobsCollection() async {
  print('💼 Debugging Jobs Collection for Fallback Data...\n');

  try {
    final jobsQuery = await FirebaseFirestore.instance
        .collection('jobs')
        .where('approvalStatus', isEqualTo: 'approved')
        .limit(10) // Limit for debugging
        .get();

    print('📊 Found ${jobsQuery.docs.length} approved jobs (showing first 10)');

    if (jobsQuery.docs.isNotEmpty) {
      final sampleJob = jobsQuery.docs.first.data();
      print('📝 Sample job fields: ${sampleJob.keys.toList()}');

      // Check job categories in jobs
      final jobCategories = <String>{};
      final jobTypes = <String>{};
      final departments = <String>{};
      final locations = <String>{};
      final designations = <String>{};

      for (var doc in jobsQuery.docs) {
        final data = doc.data();

        if (data['jobCategory'] != null) {
          jobCategories.add(data['jobCategory'].toString());
        }
        if (data['jobType'] != null) {
          jobTypes.add(data['jobType'].toString());
        }
        if (data['department'] != null) {
          departments.add(data['department'].toString());
        }
        if (data['location'] != null) {
          locations.add(data['location'].toString());
        }
        if (data['designation'] != null) {
          designations.add(data['designation'].toString());
        }
      }

      print('\n📊 Unique values found in jobs:');
      print('   Job Categories: ${jobCategories.toList()}');
      print('   Job Types: ${jobTypes.toList()}');
      print('   Departments: ${departments.toList()}');
      print('   Locations: ${locations.toList()}');
      print('   Designations: ${designations.toList()}');
    }
  } catch (e) {
    print('❌ Error debugging jobs collection: $e');
  }
}

// Test the parsing logic with different data structures
void testParsingLogic() {
  print('\n🧪 Testing Parsing Logic...\n');

  final testData = [
    {'1': 'Company Jobs'},
    {'0': 'Bank Jobs'},
    {'value': 'School Jobs'},
    {'name': 'Hospital Jobs'},
    'Government Jobs',
    {'someKey': 'Mall Jobs'},
  ];

  for (var option in testData) {
    String? result = parseOption(option);
    print('Input: $option → Output: $result');
  }
}

String? parseOption(dynamic option) {
  if (option is Map<String, dynamic>) {
    if (option.containsKey('1')) {
      return option['1'].toString();
    } else if (option.containsKey('0')) {
      return option['0'].toString();
    } else if (option.containsKey('value')) {
      return option['value'].toString();
    } else if (option.containsKey('name')) {
      return option['name'].toString();
    } else {
      final values = option.values.toList();
      if (values.isNotEmpty) {
        return values.first.toString();
      }
    }
  } else if (option is String) {
    return option;
  }
  return null;
}
