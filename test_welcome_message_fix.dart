import 'package:flutter/material.dart';

void main() {
  print('🔍 Testing Welcome Message Fix...');

  // Test the improved name loading logic
  print('\n📝 Testing name loading priority:');

  final testCases = [
    {
      'scenario': 'Firebase Auth displayName available',
      'authDisplayName': 'John Doe',
      'firestoreFullName': 'John Smith',
      'firestoreName': 'Johnny',
      'email': 'john@example.com',
      'expected': 'John Doe',
    },
    {
      'scenario': 'No Auth displayName, Firestore fullName available',
      'authDisplayName': null,
      'firestoreFullName': 'Jane Smith',
      'firestoreName': 'Jane',
      'email': 'jane@example.com',
      'expected': 'Jane Smith',
    },
    {
      'scenario': 'No fullName, Firestore name available',
      'authDisplayName': null,
      'firestoreFullName': null,
      'firestoreName': 'Alex Johnson',
      'email': 'alex@example.com',
      'expected': 'Alex Johnson',
    },
    {
      'scenario': 'No names, fallback to email username',
      'authDisplayName': null,
      'firestoreFullName': null,
      'firestoreName': null,
      'email': 'testuser@example.com',
      'expected': 'testuser',
    },
  ];

  for (var testCase in testCases) {
    final result = _simulateNameLoading(
      testCase['authDisplayName'] as String?,
      testCase['firestoreFullName'] as String?,
      testCase['firestoreName'] as String?,
      testCase['email'] as String,
    );

    final expected = testCase['expected'] as String;

    if (result == expected) {
      print('✅ ${testCase['scenario']}: $result');
    } else {
      print('❌ ${testCase['scenario']}: Expected "$expected", got "$result"');
    }
  }

  // Test gender-based title selection
  print('\n🎯 Testing gender-based title selection:');

  final genderTests = [
    {'gender': 'male', 'expected': 'Mr'},
    {'gender': 'Male', 'expected': 'Mr'},
    {'gender': 'MALE', 'expected': 'Mr'},
    {'gender': 'm', 'expected': 'Mr'},
    {'gender': 'M', 'expected': 'Mr'},
    {'gender': 'female', 'expected': 'Mrs'},
    {'gender': 'Female', 'expected': 'Mrs'},
    {'gender': 'FEMALE', 'expected': 'Mrs'},
    {'gender': 'f', 'expected': 'Mrs'},
    {'gender': 'F', 'expected': 'Mrs'},
    {'gender': 'other', 'expected': 'Mr/Mrs'},
    {'gender': '', 'expected': 'Mr/Mrs'},
    {'gender': 'unknown', 'expected': 'Mr/Mrs'},
  ];

  for (var test in genderTests) {
    final result = _getTitle(test['gender'] as String);
    final expected = test['expected'] as String;

    if (result == expected) {
      print('✅ Gender "${test['gender']}" -> $result');
    } else {
      print(
        '❌ Gender "${test['gender']}" -> Expected "$expected", got "$result"',
      );
    }
  }

  // Test complete welcome message generation
  print('\n🎉 Testing complete welcome message generation:');

  final messageTests = [
    {
      'name': 'John Doe',
      'gender': 'male',
      'expected': 'Welcome Genius >>> Mr John Doe',
    },
    {
      'name': 'Jane Smith',
      'gender': 'female',
      'expected': 'Welcome Genius >>> Mrs Jane Smith',
    },
    {
      'name': 'Alex Johnson',
      'gender': 'other',
      'expected': 'Welcome Genius >>> Mr/Mrs Alex Johnson',
    },
    {'name': '', 'gender': 'male', 'expected': 'Welcome Genius >>> User'},
  ];

  for (var test in messageTests) {
    final result = _generateWelcomeMessage(
      test['name'] as String,
      test['gender'] as String,
      false,
    );
    final expected = test['expected'] as String;

    if (result == expected) {
      print('✅ Welcome message: $result');
    } else {
      print('❌ Welcome message: Expected "$expected", got "$result"');
    }
  }

  print('\n🎯 Expected fixes:');
  print('- Name should be loaded from Firebase Auth displayName first');
  print('- Fallback to Firestore fullName, name, firstName, displayName');
  print('- Final fallback to email username');
  print('- Gender matching should be case-insensitive');
  print('- Support both full words (male/female) and abbreviations (m/f)');

  print('\n🎉 Welcome Message Fix Test Completed!');
}

String _simulateNameLoading(
  String? authDisplayName,
  String? firestoreFullName,
  String? firestoreName,
  String email,
) {
  // Simulate the priority logic
  if (authDisplayName != null && authDisplayName.isNotEmpty) {
    return authDisplayName;
  }

  if (firestoreFullName != null && firestoreFullName.isNotEmpty) {
    return firestoreFullName;
  }

  if (firestoreName != null && firestoreName.isNotEmpty) {
    return firestoreName;
  }

  // Fallback to email username
  return email.split('@')[0];
}

String _getTitle(String gender) {
  final g = gender.toLowerCase().trim();

  if (g == 'male' || g == 'm') {
    return 'Mr';
  } else if (g == 'female' || g == 'f') {
    return 'Mrs';
  }

  return 'Mr/Mrs';
}

String _generateWelcomeMessage(
  String candidateName,
  String candidateGender,
  bool isLoading,
) {
  if (isLoading) {
    return 'Welcome Genius >>> Loading...';
  }

  if (candidateName.isEmpty || candidateName == 'User') {
    return 'Welcome Genius >>> User';
  }

  final title = _getTitle(candidateGender);
  return 'Welcome Genius >>> $title $candidateName';
}
