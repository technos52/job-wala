# Candidate Existing User Check - Immediate Detection Fix

## Problem
Previously, the candidate registration flow was checking if a user is existing only at the 2nd screen. This meant users had to:
1. Sign in with Google
2. Fill out the basic information form 
3. Click "Next" to go to step 2
4. Only then discover they were an existing user

This was inconsistent with the employer registration flow, which checks for existing users immediately after Google authentication.

## Solution Implemented

### 1. Enhanced AuthService.signInWithGoogleForCandidate()

**Key Changes:**
- Moved existing user check to happen BEFORE Firebase authentication
- Check for existing candidates in Firestore using the Google email
- Throw appropriate exceptions immediately if existing user is found
- Only proceed with Firebase authentication for truly new users

**New Flow:**
```dart
// 1. Google Sign-In (account picker)
final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

// 2. IMMEDIATE check for existing candidate (BEFORE Firebase auth)
final existingCandidateQuery = await _firestore
    .collection('candidates')
    .where('email', isEqualTo: googleUser.email)
    .limit(1)
    .get();

// 3. If existing user found, authenticate them and throw appropriate exception
if (existingCandidateQuery.docs.isNotEmpty) {
  // Authenticate the existing user
  final userCredential = await _auth.signInWithCredential(credential);
  
  // Check registration status and throw exception
  if (registrationComplete) {
    throw Exception('EXISTING_USER_COMPLETE:$mobileNumber');
  } else {
    throw Exception('EXISTING_USER_INCOMPLETE:$mobileNumber');
  }
}

// 4. Only new users reach this point for normal authentication
```

### 2. Updated CandidateRegistrationStep1Screen

**Key Changes:**
- Split the existing user dialog handling into separate methods
- Handle existing user scenarios immediately after Google sign-in
- Redirect complete users directly to dashboard
- Load existing data for incomplete users automatically

**New Methods:**
```dart
void _handleExistingCompleteUser(String mobileNumber) {
  // Show dialog and redirect to dashboard immediately
}

void _handleExistingIncompleteUser(String mobileNumber) {
  // Show dialog and load existing data to continue registration
}
```

### 3. Consistent with Employer Registration Pattern

The candidate registration now follows the same pattern as employer registration:
- Immediate existing user detection after Google authentication
- Appropriate error handling and user redirection
- No need to fill forms before discovering existing account status

## Benefits

1. **Better User Experience**: Users know immediately if they're existing users
2. **Consistent Flow**: Same pattern as employer registration
3. **Reduced Friction**: No need to fill forms unnecessarily
4. **Immediate Feedback**: Clear messaging about account status right after sign-in

## Testing Instructions

To test the fix:

1. **Test with Existing Complete User:**
   - Try to register with an email that already has a complete candidate profile
   - Should show "Welcome Back!" dialog immediately after Google sign-in
   - Should offer to go directly to dashboard

2. **Test with Existing Incomplete User:**
   - Try to register with an email that has incomplete registration
   - Should show "Continue Registration" dialog immediately after Google sign-in
   - Should load existing data and allow continuation

3. **Test with New User:**
   - Try to register with a completely new email
   - Should proceed normally to the registration form

## Implementation Files Modified

1. **lib/services/auth_service.dart**
   - Enhanced `signInWithGoogleForCandidate()` method
   - Added immediate existing user check before Firebase authentication

2. **lib/screens/candidate_registration_step1_screen.dart**
   - Updated `_handleGoogleSignIn()` method
   - Added separate handlers for complete and incomplete existing users
   - Improved user experience with immediate redirection

## Technical Details

- **Database Query**: Uses Firestore query to check for existing candidates by email
- **Authentication Flow**: Authenticates existing users properly before throwing exceptions
- **Exception Handling**: Uses specific exception messages to differentiate between complete and incomplete users
- **State Management**: Properly manages loading states and UI updates
- **Navigation**: Handles navigation appropriately for different user scenarios

This fix ensures that candidate registration now behaves consistently with employer registration, providing immediate feedback about existing user status right after Google authentication.