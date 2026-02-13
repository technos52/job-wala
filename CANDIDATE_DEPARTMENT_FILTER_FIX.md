# Candidate Department Filter Fix

## Issue
The "Candidate Department" filter section was missing from the candidate search functionality. The filter was previously showing as "Job Search For" instead of "Candidate Department" and may not have had the correct department options.

## Root Cause
1. The filter section title was incorrectly labeled as "Job Search For" instead of "Candidate Department"
2. The Firebase dropdown data for `candidateDepartment` might not be properly set up
3. No fallback data was provided when Firebase data is missing

## Solution Implemented

### 1. Updated Filter Section Title
**File:** `lib/simple_candidate_dashboard.dart`

Changed the filter section from:
```dart
_buildFilterSection(
  'Job Search For',
  'jobSearchFor',
  _getFilterOptions('jobSearchFor'),
  setModalState,
),
```

To:
```dart
_buildFilterSection(
  'Candidate Department',
  'jobSearchFor',
  _getFilterOptions('jobSearchFor'),
  setModalState,
),
```

### 2. Added Fallback Data
Enhanced the `_loadFilterOptions()` method to provide fallback candidate department options when Firebase data is not available:

```dart
// Special handling for candidateDepartment - provide fallback data
if (field == 'candidateDepartment' && fieldOptions.isEmpty) {
  debugPrint('⚠️ No candidateDepartment options from Firebase, using fallback...');
  final fallbackCandidateDepartments = [
    'Information Technology',
    'Human Resources',
    'Finance & Accounting',
    'Marketing & Sales',
    'Operations',
    'Customer Service',
    'Engineering',
    'Design & Creative',
    'Legal',
    'Administration',
  ];
  fieldOptions.addAll(fallbackCandidateDepartments);
  debugPrint('📊 Added ${fieldOptions.length} fallback candidateDepartment options');
}
```

### 3. Firebase Setup Script
Created `setup_candidate_department_firebase.js` to properly set up the Firebase dropdown data.

## Expected Candidate Department Options
The filter should now show these 10 department options:

1. **Information Technology** - IT roles, software development, etc.
2. **Human Resources** - HR, recruitment, employee relations
3. **Finance & Accounting** - Financial roles, accounting, auditing
4. **Marketing & Sales** - Marketing, sales, business development
5. **Operations** - Operations management, logistics
6. **Customer Service** - Support, customer relations
7. **Engineering** - Engineering roles (non-IT)
8. **Design & Creative** - Design, creative, content roles
9. **Legal** - Legal, compliance, regulatory
10. **Administration** - Admin, office management

## Data Flow
1. **Firebase Field:** `candidateDepartment` (in jobs collection and dropdown_options)
2. **UI Filter Key:** `jobSearchFor` (internal mapping for consistency)
3. **Display Name:** "Candidate Department" (user-facing title)

## Testing
The fix includes:
- ✅ Proper filter section title
- ✅ Fallback data when Firebase is empty
- ✅ Maintains existing search functionality
- ✅ Compatible with existing job data structure

## Firebase Setup (Optional)
If you have Firebase admin access, run:
```bash
node setup_candidate_department_firebase.js
```

Or manually add in Firebase Console:
- Collection: `dropdown_options`
- Document ID: `candidateDepartment`
- Field: `options` (array with the 10 department values)

## Result
Users can now filter jobs by candidate department with options like "Information Technology", "Human Resources", "Finance & Accounting", etc., exactly as shown in the original design.