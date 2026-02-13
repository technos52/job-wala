# Job Category Label Update

## Change Made
Updated the "Job Category" field label to "Department / Job Category" in both candidate registration and edit profile screens as requested.

## Files Modified

### 1. Candidate Registration Step 2 Screen
**File**: `lib/screens/candidate_registration_step2_screen.dart`

**Changes Made**:
- **Label**: Changed from `'Job Category *'` to `'Department / Job Category *'`
- **Hint Text**: Changed from `'Select or type job category'` to `'Select or type department/job category'`
- **Validation Message**: Changed from `'Please select your job category'` to `'Please select your department/job category'`

### 2. Edit Profile Screen
**File**: `lib/screens/edit_profile_screen.dart`

**Changes Made**:
- **Label**: Changed from `'Job Category'` to `'Department / Job Category'`

## Before and After

### Before:
```dart
labelText: 'Job Category *',
hintText: 'Select or type job category',
// Validation message: 'Please select your job category'
```

### After:
```dart
labelText: 'Department / Job Category *',
hintText: 'Select or type department/job category',
// Validation message: 'Please select your department/job category'
```

## User Experience Impact

### Benefits:
1. **Clearer Context**: Users now understand they can select either a department or job category
2. **Better Guidance**: The label provides more specific direction about what to enter
3. **Consistent Terminology**: Aligns with business terminology where departments and job categories are related concepts
4. **Improved Usability**: Reduces confusion about what type of information is expected

### Visual Changes:
- The field label now shows "Department / Job Category *" instead of just "Job Category *"
- Hint text is more descriptive and inclusive
- Error messages are updated to match the new terminology

## Technical Details

### Field Behavior:
- **Functionality**: No change in functionality, only label updates
- **Validation**: Same validation rules apply, just updated error messages
- **Data Storage**: No change in how data is stored (still saved as 'jobCategory')
- **Dropdown Options**: Same dropdown options from Firebase/local data

### Consistency:
- Updated in both registration and edit profile screens
- All related text (labels, hints, validation messages) updated consistently
- Maintains the same styling and behavior

## Testing
- ✅ App compiles and runs successfully
- ✅ Field displays new label correctly
- ✅ Validation messages updated appropriately
- ✅ No functional changes, only cosmetic label updates

This change improves user understanding by making it clear that the field accepts both department names and job categories, providing better guidance for form completion.