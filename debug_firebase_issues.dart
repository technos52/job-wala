import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Debug script to identify Firebase issues
void main() async {
  print('🐛 Firebase Issues Debug Script...\n');

  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully\n');

    await debugJobCategoryIssue();
    await debugFilterOptionsIssue();
    await testParsingLogic();

    print('\n🎉 Firebase debugging completed!');
  } catch (e) {
    print('❌ Error during Firebase debugging: $e');
  }
}

Future<void> debugJobCategoryIssue() async {
  print('🔍 Debugging Job Category Issue...\n');
  print('Expected: All 8 categories from Firebase');
  print('Actual: Only showing "All Jobs", "Government Jobs", "aaaa"\n');

  try {
    final doc = await FirebaseFirestore.instance
        .collection('dropdownData')
        .doc('jobCategory')
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      print('✅ jobCategory document exists');
      print('📄 Raw document: $data\n');

      // Test the exact parsing logic from the app
      final categories = <String>[];

      if (data.containsKey('options')) {
        final options = data['options'] as List<dynamic>;
        print('📊 Found ${options.length} options in jobCategory');

        for (int i = 0; i < options.length; i++) {
          final option = options[i];
          print('   Option $i: $option (type: ${option.runtimeType})');

          String? categoryValue;

          if (option is Map<String, dynamic>) {
            print('     Map keys: ${option.keys.toList()}');

            // Test the exact logic from the app
            if (option.containsKey('0')) {
              categoryValue = option['0'].toString();
              print('     ✓ Found with key "0": $categoryValue');
            } else if (option.containsKey('1')) {
              categoryValue = option['1'].toString();
              print('     ✓ Found with key "1": $categoryValue');
            } else if (option.containsKey(i.toString())) {
              categoryValue = option[i.toString()].toString();
              print('     ✓ Found with key "$i": $categoryValue');
            } else {
              final values = option.values
                  .where((v) => v != null && v.toString().isNotEmpty)
                  .toList();
              if (values.isNotEmpty) {
                categoryValue = values.first.toString();
                print('     ✓ Found from first value: $categoryValue');
              }
            }
          } else if (option is String) {
            categoryValue = option;
            print('     ✓ Direct string: $categoryValue');
          }

          if (categoryValue != null &&
              categoryValue.isNotEmpty &&
              categoryValue != 'null') {
            categories.add(categoryValue);
            print('     ✅ ADDED: $categoryValue');
          } else {
            print('     ❌ SKIPPED: null/empty value');
          }
        }

        print('\n📊 Final parsed categories: $categories');
        print('📈 Expected 8 categories, got ${categories.length}');

        // Check against expected categories
        final expectedCategories = [
          'Company Jobs',
          'Bank/NBFC Jobs',
          'School Jobs',
          'Hospital Jobs',
          'Hotel/Bar Jobs',
          'Government Jobs',
          'Mall/Shopkeeper Jobs',
          'aaaa',
        ];

        print('\n🔍 Category matching:');
        for (String expected in expectedCategories) {
          bool found = categories.contains(expected);
          print('   ${found ? "✅" : "❌"} $expected');
        }
      } else {
        print('❌ No options field found');
      }
    } else {
      print('❌ jobCategory document does not exist');
    }
  } catch (e) {
    print('❌ Error debugging job categories: $e');
  }
}

Future<void> debugFilterOptionsIssue() async {
  print('\n🔍 Debugging Filter Options Issue...\n');
  print('Expected: Dynamic filter values from Firebase');
  print('Actual: Not all values showing\n');

  final filterFields = [
    'jobType',
    'department',
    'candidateDepartment',
    'designation',
    'location',
  ];

  for (String field in filterFields) {
    print('📋 Debugging $field filter...');

    try {
      final doc = await FirebaseFirestore.instance
          .collection('dropdownData')
          .doc(field)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        print('   ✅ $field document exists');
        print('   📄 Raw document: $data');

        // Test the exact parsing logic from the app
        final fieldOptions = <String>[];

        if (data.containsKey('options')) {
          final options = data['options'] as List<dynamic>;
          print('   📊 Found ${options.length} options in $field');

          for (int i = 0; i < options.length; i++) {
            final option = options[i];
            print('     Option $i: $option (type: ${option.runtimeType})');

            String? optionValue;

            if (option is Map<String, dynamic>) {
              print('       Map keys: ${option.keys.toList()}');

              // Test the exact logic from the app
              if (option.containsKey('0')) {
                optionValue = option['0'].toString();
                print('       ✓ Found with key "0": $optionValue');
              } else if (option.containsKey('1')) {
                optionValue = option['1'].toString();
                print('       ✓ Found with key "1": $optionValue');
              } else if (option.containsKey(i.toString())) {
                optionValue = option[i.toString()].toString();
                print('       ✓ Found with key "$i": $optionValue');
              } else {
                final values = option.values
                    .where((v) => v != null && v.toString().isNotEmpty)
                    .toList();
                if (values.isNotEmpty) {
                  optionValue = values.first.toString();
                  print('       ✓ Found from first value: $optionValue');
                }
              }
            } else if (option is String) {
              optionValue = option;
              print('       ✓ Direct string: $optionValue');
            }

            if (optionValue != null &&
                optionValue.isNotEmpty &&
                optionValue != 'null') {
              fieldOptions.add(optionValue);
              print('       ✅ ADDED: $optionValue');
            } else {
              print('       ❌ SKIPPED: null/empty value');
            }
          }

          print('   📊 Final parsed options for $field: $fieldOptions');
          print('   📈 Got ${fieldOptions.length} filter options');
        } else {
          print('   ❌ No options field found in $field');
        }
      } else {
        print('   ❌ $field document does not exist');
      }
    } catch (e) {
      print('   ❌ Error debugging $field: $e');
    }

    print('');
  }
}

void testParsingLogic() {
  print('\n🧪 Testing Parsing Logic with Sample Data...\n');

  // Test data based on your Firebase screenshot
  final testJobCategories = [
    {'0': 'Company Jobs'},
    {'1': 'Bank/NBFC Jobs'},
    {'2': 'School Jobs'},
    {'3': 'Hospital Jobs'},
    {'4': 'Hotel/Bar Jobs'},
    {'5': 'Government Jobs'},
    {'6': 'Mall/Shopkeeper Jobs'},
    {'7': 'aaaa'},
  ];

  print('🔬 Testing job category parsing:');
  final parsedCategories = <String>[];

  for (int i = 0; i < testJobCategories.length; i++) {
    final option = testJobCategories[i];
    String? result = parseTestOption(option, i);
    print('   Input: $option → Output: $result');

    if (result != null) {
      parsedCategories.add(result);
    }
  }

  print('\n📊 Parsed categories: $parsedCategories');
  print('📈 Expected 8, got ${parsedCategories.length}');

  // Test filter options
  final testFilterOptions = [
    {'0': 'Full Time'},
    {'1': 'Part Time'},
    {'2': 'Contract'},
    {'3': 'Freelance'},
  ];

  print('\n🔬 Testing filter option parsing:');
  final parsedOptions = <String>[];

  for (int i = 0; i < testFilterOptions.length; i++) {
    final option = testFilterOptions[i];
    String? result = parseTestOption(option, i);
    print('   Input: $option → Output: $result');

    if (result != null) {
      parsedOptions.add(result);
    }
  }

  print('\n📊 Parsed filter options: $parsedOptions');
  print('📈 Expected 4, got ${parsedOptions.length}');
}

String? parseTestOption(dynamic option, int index) {
  if (option is Map<String, dynamic>) {
    // Test the exact logic from the app
    if (option.containsKey('0')) {
      return option['0'].toString();
    } else if (option.containsKey('1')) {
      return option['1'].toString();
    } else if (option.containsKey(index.toString())) {
      return option[index.toString()].toString();
    } else {
      final values = option.values
          .where((v) => v != null && v.toString().isNotEmpty)
          .toList();
      if (values.isNotEmpty) {
        return values.first.toString();
      }
    }
  } else if (option is String) {
    return option;
  }
  return null;
}

// Test what happens when we run the app's exact logic
Future<void> simulateAppLogic() async {
  print('\n🎯 Simulating App Logic...\n');

  try {
    // Simulate _loadJobCategories
    print('📋 Simulating _loadJobCategories...');

    final categoryDoc = await FirebaseFirestore.instance
        .collection('dropdownData')
        .doc('jobCategory')
        .get();

    final categories = <String>[];

    if (categoryDoc.exists) {
      final data = categoryDoc.data();
      print('✅ Document exists, processing...');

      if (data != null && data.containsKey('options')) {
        final options = data['options'] as List<dynamic>;
        print('📊 Processing ${options.length} options...');

        for (int i = 0; i < options.length; i++) {
          final option = options[i];
          String? categoryValue;

          if (option is Map<String, dynamic>) {
            if (option.containsKey('0')) {
              categoryValue = option['0'].toString();
            } else if (option.containsKey('1')) {
              categoryValue = option['1'].toString();
            } else if (option.containsKey(i.toString())) {
              categoryValue = option[i.toString()].toString();
            } else {
              final values = option.values
                  .where((v) => v != null && v.toString().isNotEmpty)
                  .toList();
              if (values.isNotEmpty) {
                categoryValue = values.first.toString();
              }
            }
          } else if (option is String && option.isNotEmpty) {
            categoryValue = option;
          }

          if (categoryValue != null &&
              categoryValue.isNotEmpty &&
              categoryValue != 'null') {
            categories.add(categoryValue);
          }
        }
      }
    }

    final finalCategories = ['All Jobs', ...categories];
    print('🎯 Final categories that would be set: $finalCategories');
    print('📊 Total categories: ${finalCategories.length}');
  } catch (e) {
    print('❌ Error simulating app logic: $e');
  }
}
