# Registration Authentication Fix

## Problem
Users getting "Failed to save your basic information" error when clicking Next in candidate registration step 1.

## Root Cause
The Firestore security rules require authentication (`request.auth != null`) but users were trying to register without being authenticated first.

## Solution Applied

### 1. Fixed Firebase Service
- Added proper authentication check in `saveCandidateStep1Data`
- Added token refresh to ensure valid authentication
- Added user email and UID to saved candidate data
- Improved error messages to guide users

### 2. Updated Registration Screen
- Enhanced error handling to detect authentication errors
- Added dialog to guide users back to sign-in when authentication is required

### 3. Authentication Flow
The correct flow should be:
1. User goes to `CandidateAuthScreen`
2. User clicks "Sign in with Google" → goes to `CandidateGoogleSignInScreen`
3. User completes Google Sign-In (this authenticates them)
4. User is redirected to `CandidateRegistrationStep1Screen` (now authenticated)
5. User fills form and clicks Next (now works because they're authenticated)

## Testing
Run `test_registration_auth_fix.dart` to verify the fix works correctly.

## User Instructions
If you encounter the registration error:

1. **Go back to the sign-in screen**
2. **Click "Sign in with Google"** 
3. **Complete the Google sign-in process**
4. **Then proceed with registration**

The registration will only work after you've signed in with Google first.

## Technical Details

### Firestore Rules
```javascript
match /candidates/{candidateId} {
  allow read, write: if request.auth != null;
}
```

### Authentication Check
```dart
final user = FirebaseAuth.instance.currentUser;
if (user == null) {
  throw Exception('Please sign in with Google first to continue registration.');
}
```

### Error Handling
The app now detects authentication errors and shows a helpful dialog instead of a generic error message.