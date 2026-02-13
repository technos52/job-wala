import 'dart:io';
import 'package:flutter/material.dart';
import 'lib/services/dropdown_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Starting Company Type Data Debug...');

  try {
    // Test 1: Check default options
    print('\n📋 Test 1: Default Company Types');
    final defaultCompanyTypes = DropdownService.getDefaultOptions(
      'company_types',
    );
    print('Default company types count: ${defaultCompanyTypes.length}');
    print('First 5 default types: ${defaultCompanyTypes.take(5).toList()}');

    // Test 2: Try to load from Firebase
    print('\n🔥 Test 2: Firebase Company Types');
    try {
      final firebaseOptions = await DropdownService.getAllDropdownOptions();
      print('Firebase categories loaded: ${firebaseOptions.keys.toList()}');

      if (firebaseOptions.containsKey('company_types')) {
        final firebaseCompanyTypes = firebaseOptions['company_types']!;
        print('Firebase company types count: ${firebaseCompanyTypes.length}');
        print(
          'First 5 Firebase types: ${firebaseCompanyTypes.take(5).toList()}',
        );
      } else {
        print('❌ No company_types found in Firebase data');
      }
    } catch (e) {
      print('❌ Firebase error: $e');
    }

    // Test 3: Test specific company type loading
    print('\n🎯 Test 3: Direct Company Type Loading');
    try {
      final directCompanyTypes = await DropdownService.getDropdownOptions(
        'company_types',
      );
      print('Direct company types count: ${directCompanyTypes.length}');
      print('First 5 direct types: ${directCompanyTypes.take(5).toList()}');
    } catch (e) {
      print('❌ Direct loading error: $e');
    }

    // Test 4: Firebase connection test
    print('\n📡 Test 4: Firebase Connection Test');
    try {
      final connectionTest = await DropdownService.testFirebaseConnection();
      print('Connection test results:');
      connectionTest.forEach((key, value) {
        print('  $key: $value');
      });
    } catch (e) {
      print('❌ Connection test error: $e');
    }

    print('\n✅ Debug completed successfully');
  } catch (e) {
    print('❌ Debug failed: $e');
  }

  exit(0);
}
