# Welcome Message Update - Replace "Current: Home" with Personalized Greeting

## Issue
The app bar currently shows "Current: Home" which is not personalized. The requirement is to replace this with a personalized welcome message like "Welcome Genius >>> Mr/Mrs [Name]".

## Solution Implemented

### 1. Added Profile Data Variables
**File:** `lib/simple_candidate_dashboard.dart`

Added new state variables to store candidate profile information:
```dart
// Candidate profile data
String _candidateName = '';
String _candidateGender = '';
bool _isLoadingProfile = true;
```

### 2. Added Profile Loading Method
Created `_loadCandidateProfile()` method that:
- Fetches candidate data from Firebase `candidates` collection
- Extracts `fullName` (or `name`) and `gender` fields
- Handles loading states and error cases
- Uses current user's UID to fetch the correct profile

### 3. Added Welcome Message Generator
Created `_getWelcomeMessage()` method that:
- Returns "Welcome Genius >>> Loading..." while fetching data
- Returns "Welcome Genius >>> Mr [Name]" for male candidates
- Returns "Welcome Genius >>> Mrs [Name]" for female candidates  
- Returns "Welcome Genius >>> Mr/Mrs [Name]" for other/unspecified gender
- Returns "Welcome Genius >>> User" as fallback if name is not available

### 4. Updated App Bar
**Before:**
```dart
Text(
  'Current: ${_currentBottomNavIndex == 0 ? "Home" : "Profile"}',
  // ...
),
```

**After:**
```dart
Text(
  _getWelcomeMessage(),
  // ...
),
```

## Expected Behavior

### Welcome Message Examples:
- **Male candidate:** "Welcome Genius >>> Mr John Doe"
- **Female candidate:** "Welcome Genius >>> Mrs Jane Smith"
- **Other/Unknown gender:** "Welcome Genius >>> Mr/Mrs Alex Johnson"
- **Loading state:** "Welcome Genius >>> Loading..."
- **No name available:** "Welcome Genius >>> User"

### Firebase Data Structure Expected:
**Collection:** `candidates`  
**Document ID:** `[user_uid]`  
**Fields:**
```json
{
  "fullName": "John Doe",
  "gender": "male"
}
```

Alternative field names supported:
- `name` (if `fullName` is not available)
- `gender` values: "male", "female", or any other value (defaults to "Mr/Mrs")

## Data Flow
1. **App starts** → Shows "Welcome Genius >>> Loading..."
2. **Profile loads** → Fetches from `candidates/[uid]` document
3. **Success** → Shows personalized message with proper title
4. **Error/No data** → Shows "Welcome Genius >>> User"

## Testing
The implementation includes:
- ✅ Proper loading states
- ✅ Gender-based title selection
- ✅ Fallback handling for missing data
- ✅ Error handling for Firebase failures
- ✅ Maintains existing app functionality

## Result
The app bar now shows a personalized welcome message instead of the generic "Current: Home" text, making the user experience more engaging and personal.