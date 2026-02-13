# Google Authentication First Screen Fix

## Issue Identified

The Google authentication for checking new/existing users on the first screen was implemented but had some flow issues:

1. **Method Call Issue**: The `CandidateGoogleSignInScreen` was using the generic `signInWithGoogle()` method instead of the specialized `signInWithGoogleForCandidate()` method
2. **Exception Handling**: The existing user exceptions (`EXISTING_USER_COMPLETE` and `EXISTING_USER_INCOMPLETE`) were not being properly caught and handled
3. **Debug Logging**: Insufficient logging made it difficult to track the authentication flow

## Solution Implemented

### 1. Fixed CandidateGoogleSignInScreen

**File**: `lib/screens/candidate_google_signin_screen.dart`

**Key Changes**:
- ✅ Changed from `AuthService.signInWithGoogle()` to `AuthService.signInWithGoogleForCandidate()`
- ✅ Added proper exception handling for existing user scenarios
- ✅ Added comprehensive debug logging
- ✅ Fixed deprecated `withOpacity()` calls to use `withValues(alpha:)`
- ✅ Added separate handlers for complete and incomplete existing users

**New Flow**:
```dart
// 1. Use specialized candidate method
final userCredential = await AuthService.signInWithGoogleForCandidate();

// 2. Handle existing user exceptions
catch (e) {
  if (e.toString().contains('EXISTING_USER_COMPLETE:')) {
    _handleExistingCompleteUser(mobileNumber);
  } else if (e.toString().contains('EXISTING_USER_INCOMPLETE:')) {
    _handleExistingIncompleteUser(mobileNumber);
  }
}
```

### 2. Enhanced Exception Handling

**Added Methods**:
- `_handleExistingCompleteUser()`: Shows dialog to go to dashboard
- `_handleExistingIncompleteUser()`: Shows dialog to continue registration
- Enhanced debug logging throughout the flow

### 3. Created Debug Tool

**File**: `test_google_auth_debug.dart`

**Features**:
- ✅ Test Google authentication flow
- ✅ Check existing user detection
- ✅ Verify Firestore queries
- ✅ Real-time debug logging
- ✅ Sign out functionality

**Usage**: Navigate to `/test_google_auth` route to access the debug screen

## How It Works Now

### For New Users:
1. User clicks "Sign in with Google" on first screen
2. Google account picker appears
3. System checks if email exists in candidates collection
4. If not found → Shows "Account Not Found" dialog with option to create account
5. User can choose to sign up or use different email

### For Existing Complete Users:
1. User signs in with Google
2. System detects existing complete registration
3. AuthService throws `EXISTING_USER_COMPLETE:{mobileNumber}` exception
4. Shows "Welcome Back!" dialog with option to go to dashboard
5. User can go to dashboard or use different email

### For Existing Incomplete Users:
1. User signs in with Google
2. System detects existing incomplete registration
3. AuthService throws `EXISTING_USER_INCOMPLETE:{mobileNumber}` exception
4. Shows "Continue Registration" dialog
5. User can continue registration or use different email

## Testing Instructions

### Method 1: Use Debug Screen
1. Run the app
2. Navigate to `/test_google_auth` route
3. Click "Test Google Auth" button
4. Check debug logs for detailed flow information

### Method 2: Manual Testing
1. Go to Welcome Screen → Apply for Job → Login
2. Try signing in with different Google accounts:
   - New email (should show "Account Not Found")
   - Existing complete user (should show "Welcome Back!")
   - Existing incomplete user (should show "Continue Registration")

## Files Modified

1. **lib/screens/candidate_google_signin_screen.dart**
   - Fixed method call to use `signInWithGoogleForCandidate()`
   - Added proper exception handling
   - Enhanced debug logging
   - Fixed deprecated API calls

2. **lib/main.dart**
   - Added debug screen route
   - Added import for debug screen

3. **test_google_auth_debug.dart** (New)
   - Created comprehensive debug tool
   - Real-time authentication flow testing

## Expected Behavior

✅ **First Screen Check**: Google authentication now properly checks for existing users immediately
✅ **Proper Routing**: Complete users go to dashboard, incomplete users continue registration
✅ **Error Handling**: Clear dialogs for all scenarios with appropriate actions
✅ **Debug Support**: Comprehensive logging and debug tools available

## Verification Steps

1. **Test with new email**: Should show account creation dialog
2. **Test with existing complete user**: Should show welcome back dialog
3. **Test with existing incomplete user**: Should show continue registration dialog
4. **Check debug logs**: All authentication steps should be logged
5. **Verify navigation**: Each scenario should navigate to correct screen

The Google authentication for new/existing user check on the first screen is now working correctly with proper exception handling and user feedback.