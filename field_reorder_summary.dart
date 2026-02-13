// FIELD REORDERING - CANDIDATE REGISTRATION STEP 2
//
// CHANGE: Moved Experience and Currently Working fields below Designation

void main() {
  print('📝 FIELD REORDERING COMPLETED:');
  print('');

  print('🔄 PREVIOUS ORDER:');
  print('1. Qualification *');
  print('2. Experience * (Years/Months)');
  print('3. Currently Working? *');
  print('4. Job Category *');
  print('5. Job Type *');
  print('6. Designation *');
  print('7. Company Name');
  print('8. Company Type *');
  print('');

  print('✅ NEW ORDER:');
  print('1. Qualification *');
  print('2. Job Category *');
  print('3. Job Type *');
  print('4. Designation *');
  print('5. Experience * (Years/Months)');
  print('6. Currently Working? *');
  print('7. Company Name');
  print('8. Company Type *');
  print('');

  print('🎯 RATIONALE:');
  print('- More logical flow: Job details first, then experience');
  print('- Designation comes before experience for better context');
  print('- Experience and employment status grouped together');
  print('- Company information remains at the end');
  print('');

  print('📱 USER EXPERIENCE:');
  print(
    '- Users first define what job they want (category, type, designation)',
  );
  print('- Then provide their experience level for that role');
  print('- Finally specify current employment status');
  print('- Company details come last as supporting information');
  print('');

  print('✅ FIELD REORDERING SUCCESSFULLY APPLIED!');
}
