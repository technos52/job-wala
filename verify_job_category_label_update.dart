import 'dart:io';

void main() async {
  print('🔍 Verifying Job Category Label Update');
  print('=' * 50);

  // Read the candidate registration step 2 file
  final file = File('lib/screens/candidate_registration_step2_screen.dart');

  if (!await file.exists()) {
    print(
      '❌ File not found: lib/screens/candidate_registration_step2_screen.dart',
    );
    return;
  }

  final content = await file.readAsString();

  // Check for the updated label
  final hasCorrectLabel = content.contains(
    "labelText: 'Department / Job Category *'",
  );
  final hasCorrectHint = content.contains(
    "hintText: 'Select or type department/job category'",
  );
  final hasCorrectValidation = content.contains(
    "Please select your department/job category",
  );

  print('📋 Verification Results:');
  print('');

  if (hasCorrectLabel) {
    print('✅ Label Text: "Department / Job Category *" - FOUND');
  } else {
    print('❌ Label Text: "Department / Job Category *" - NOT FOUND');
  }

  if (hasCorrectHint) {
    print('✅ Hint Text: "Select or type department/job category" - FOUND');
  } else {
    print('❌ Hint Text: "Select or type department/job category" - NOT FOUND');
  }

  if (hasCorrectValidation) {
    print('✅ Validation: "Please select your department/job category" - FOUND');
  } else {
    print(
      '❌ Validation: "Please select your department/job category" - NOT FOUND',
    );
  }

  print('');

  if (hasCorrectLabel && hasCorrectHint && hasCorrectValidation) {
    print(
      '🎉 SUCCESS: All Job Category label updates are correctly implemented!',
    );
    print('');
    print('📱 Next Steps:');
    print('   1. Hot restart the app (press R in Flutter terminal)');
    print('   2. Navigate to candidate registration step 2');
    print('   3. Verify the field shows "Department / Job Category *"');
    print('   4. If still showing old label, try:');
    print('      • Clear app data');
    print('      • Restart the app completely');
    print('      • Check device cache');
  } else {
    print('⚠️  Some updates may be missing. Please check the file manually.');
  }

  print('');
  print('🔧 Additional Checks:');

  // Check edit profile screen
  final editProfileFile = File('lib/screens/edit_profile_screen.dart');
  if (await editProfileFile.exists()) {
    final editContent = await editProfileFile.readAsString();
    final hasEditProfileLabel = editContent.contains(
      "label: 'Department / Job Category'",
    );

    if (hasEditProfileLabel) {
      print('✅ Edit Profile Screen: Label is correctly updated');
    } else {
      print('❌ Edit Profile Screen: Label may need updating');
    }
  }

  print('');
  print('📍 File Locations:');
  print(
    '   • Registration: lib/screens/candidate_registration_step2_screen.dart (line ~1036)',
  );
  print('   • Edit Profile: lib/screens/edit_profile_screen.dart (line ~912)');
}
