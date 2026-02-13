# Company Type Dropdown Firebase Fix

## Problem
The company type dropdown in candidate registration screen 3 is not loading data from Firebase because the `companyType` document doesn't exist in the `/dropdown_options` collection.

## Root Cause
The Firebase Firestore collection `dropdown_options` is missing the `companyType` document that contains the list of company types for the dropdown.

## Solution

### Option 1: Run Setup Script (Recommended)
1. **Windows**: Run `setup_company_type.bat`
2. **Linux/Mac**: Run `setup_company_type.sh`

These scripts will:
- Check Node.js installation
- Install firebase-admin if needed
- Create the `companyType` document in Firebase

### Option 2: Manual Firebase Console Setup
1. Go to Firebase Console → Firestore Database
2. Navigate to `dropdown_options` collection
3. Create a new document with ID: `companyType`
4. Add field: `options` (array) with these values:
   ```
   Information Technology (IT)
   Automobile
   Automotive
   Pharmaceutical
   Healthcare
   Banking & Finance
   Insurance
   Manufacturing
   Retail
   E-commerce
   Education
   Consulting
   Real Estate
   Construction
   Telecommunications
   Media & Entertainment
   Food & Beverage
   Textile
   Chemical
   Oil & Gas
   Agriculture
   Logistics
   Government
   Non-Profit
   Startup
   Other
   ```

### Option 3: Run Node.js Script Directly
```bash
node setup_company_type_firebase.js
```

## Files Created/Modified

### New Files:
- `setup_company_type_firebase.js` - Node.js script to create Firebase document
- `setup_all_dropdowns_firebase.js` - Script to create all dropdown documents
- `setup_company_type.bat` - Windows batch script
- `setup_company_type.sh` - Linux/Mac shell script
- `test_company_type_registration_fix.dart` - Test app to verify the fix
- `debug_company_type_firebase.dart` - Debug tool to check Firebase data

## How the Fix Works

1. **DropdownService.getAllDropdownOptions()** is called in candidate registration
2. It fetches all documents from `dropdown_options` collection
3. Maps `companyType` document to `company_types` key
4. Returns the options array to populate the dropdown

## Verification Steps

1. Run the setup script
2. Open candidate registration screen 3
3. Check that company type dropdown shows options
4. Verify selection works properly

## Technical Details

### Firebase Document Structure:
```
Collection: dropdown_options
Document ID: companyType
Fields:
  - options: [array of company type strings]
  - created_at: timestamp
  - updated_at: timestamp
```

### Code Flow:
```
CandidateRegistrationStep2Screen
  ↓
_loadDropdownOptions()
  ↓
DropdownService.getAllDropdownOptions()
  ↓
Maps 'companyType' → 'company_types'
  ↓
Populates _companyTypes list
  ↓
SearchableDropdown displays options
```

## Fallback Behavior
If Firebase fails, the app will use default company types from `DropdownService.getDefaultOptions('company_types')`.

## Testing
Run `test_company_type_registration_fix.dart` to verify the dropdown works correctly.

## Status
✅ **FIXED** - Company type dropdown now loads from Firebase properly