import 'package:flutter/material.dart';

void main() {
  print('🔍 Testing Welcome Message Update...');

  // Test the welcome message generation logic
  print('\n📝 Testing welcome message generation:');

  // Test cases
  final testCases = [
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

  for (var testCase in testCases) {
    final name = testCase['name'] as String;
    final gender = testCase['gender'] as String;
    final expected = testCase['expected'] as String;

    String result = _generateWelcomeMessage(name, gender, false);

    if (result == expected) {
      print('✅ Test passed: $result');
    } else {
      print('❌ Test failed: Expected "$expected", got "$result"');
    }
  }

  // Test loading state
  String loadingResult = _generateWelcomeMessage('', '', true);
  if (loadingResult == 'Welcome Genius >>> Loading...') {
    print('✅ Loading state test passed: $loadingResult');
  } else {
    print('❌ Loading state test failed: $loadingResult');
  }

  print('\n🎯 Expected behavior:');
  print('- App bar should show "Welcome Genius >>> Mr/Mrs [Name]"');
  print(
    '- Title should be "Mr" for male, "Mrs" for female, "Mr/Mrs" for others',
  );
  print('- Should show "Loading..." while fetching profile data');
  print('- Should fallback to "User" if name is not available');

  print('\n🎉 Welcome Message Update Test Completed!');
}

String _generateWelcomeMessage(
  String candidateName,
  String candidateGender,
  bool isLoading,
) {
  if (isLoading) {
    return 'Welcome Genius >>> Loading...';
  }

  if (candidateName.isEmpty) {
    return 'Welcome Genius >>> User';
  }

  // Determine title based on gender
  String title = 'Mr/Mrs';
  if (candidateGender.toLowerCase() == 'male') {
    title = 'Mr';
  } else if (candidateGender.toLowerCase() == 'female') {
    title = 'Mrs';
  }

  return 'Welcome Genius >>> $title $candidateName';
}
