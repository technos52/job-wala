import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/services/dropdown_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Debugging Dropdown Issues...');
  print('=' * 50);

  // Test 1: Check Firebase dropdown_options collection
  await testFirebaseDropdownCollection();

  // Test 2: Test DropdownService functionality
  await testDropdownService();

  // Test 3: Check specific dropdown categories
  await testSpecificCategories();

  print('=' * 50);
  print('✅ Dropdown debugging completed');
}

Future<void> testFirebaseDropdownCollection() async {
  print('\n📋 Test 1: Firebase dropdown_options Collection');
  print('-' * 40);

  try {
    final collection = await FirebaseFirestore.instance
        .collection('dropdown_options')
        .get();

    print('✅ Collection exists with ${collection.docs.length} documents');

    if (collection.docs.isEmpty) {
      print('❌ No documents found in dropdown_options collection!');
      print('💡 You need to set up the dropdown data in Firebase');
      return;
    }

    print('\n📄 Available documents:');
    for (final doc in collection.docs) {
      final data = doc.data();
      print('   Document ID: ${doc.id}');

      if (data.containsKey('options')) {
        final options = List<String>.from(data['options'] ?? []);
        print('     Structure: New (options field)');
        print('     Count: ${options.length} options');
        if (options.isNotEmpty) {
          print(
            '     Sample: ${options.take(3).join(", ")}${options.length > 3 ? "..." : ""}',
          );
        }
      } else {
        print('     Structure: Legacy (individual fields)');
        print('     Fields: ${data.keys.join(", ")}');
      }
      print('');
    }
  } catch (e) {
    print('❌ Error accessing dropdown_options collection: $e');
    print('💡 Check Firebase configuration and permissions');
  }
}

Future<void> testDropdownService() async {
  print('\n📋 Test 2: DropdownService Functionality');
  print('-' * 40);

  try {
    // Test connection
    final connectionTest = await DropdownService.testFirebaseConnection();
    print('🔗 Firebase Connection:');
    print(
      '   Can read dropdown_options: ${connectionTest['canReadDropdownOptions']}',
    );
    print(
      '   Dropdown options exist: ${connectionTest['dropdownOptionsExists']}',
    );
    if (connectionTest['error'] != null) {
      print('   Error: ${connectionTest['error']}');
    }

    // Test getAllDropdownOptions
    print('\n📊 Testing getAllDropdownOptions():');
    final allOptions = await DropdownService.getAllDropdownOptions();

    if (allOptions.isEmpty) {
      print('❌ No options loaded from DropdownService');
    } else {
      print('✅ Loaded ${allOptions.length} categories:');
      allOptions.forEach((category, options) {
        print('   $category: ${options.length} options');
        if (options.isNotEmpty) {
          print(
            '     Sample: ${options.take(2).join(", ")}${options.length > 2 ? "..." : ""}',
          );
        }
      });
    }
  } catch (e) {
    print('❌ Error testing DropdownService: $e');
  }
}

Future<void> testSpecificCategories() async {
  print('\n📋 Test 3: Specific Dropdown Categories');
  print('-' * 40);

  final categoriesToTest = [
    'qualifications',
    'job_categories',
    'job_types',
    'designations',
    'company_types',
  ];

  for (final category in categoriesToTest) {
    try {
      print('\n🔍 Testing category: $category');
      final options = await DropdownService.getDropdownOptions(category);

      if (options.isEmpty) {
        print('   ❌ No options found');
        print('   💡 Check Firebase document mapping for $category');
      } else {
        print('   ✅ Found ${options.length} options');
        print(
          '   📝 Sample: ${options.take(3).join(", ")}${options.length > 3 ? "..." : ""}',
        );
      }
    } catch (e) {
      print('   ❌ Error loading $category: $e');
    }
  }
}

// Helper function to suggest fixes
void suggestFixes() {
  print('\n🔧 Suggested Fixes:');
  print('=' * 30);

  print('1. If dropdown_options collection is empty:');
  print('   - Run setup_all_dropdowns_firebase.js');
  print('   - Or manually create documents in Firebase Console');

  print('\n2. If documents exist but no data loads:');
  print('   - Check document structure (should have "options" field)');
  print('   - Verify Firestore security rules allow reads');

  print('\n3. If DropdownService fails:');
  print('   - Check Firebase configuration');
  print('   - Verify internet connection');
  print('   - Check authentication state');

  print('\n4. If specific categories fail:');
  print('   - Check document ID mapping in DropdownService');
  print('   - Verify document names match expected format');
}
