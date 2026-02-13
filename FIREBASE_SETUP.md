# Firebase Setup for JobEase

## Prerequisites
- Firebase CLI installed (already installed)
- FlutterFire CLI installed (already installed)
- Google account with Firebase access

## Setup Steps

### 1. Login to Firebase
```bash
firebase login
```

### 2. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: **JobEase**
4. Follow the setup wizard
5. Enable Google Analytics (optional)

### 3. Add Android App to Firebase
1. In Firebase Console, click "Add app" → Android
2. Package name: Check `android/app/build.gradle.kts` for `applicationId`
3. Download `google-services.json`
4. Place it in `android/app/` directory

### 4. Add iOS App to Firebase (if needed)
1. In Firebase Console, click "Add app" → iOS
2. Bundle ID: Check `ios/Runner/Info.plist` for `CFBundleIdentifier`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory

### 5. Configure FlutterFire
Run this command in your project directory:
```bash
flutterfire configure --project=jobease
```

This will:
- Automatically detect your Firebase project
- Generate `lib/firebase_options.dart` with correct configuration
- Set up platform-specific configurations

### 6. Enable Firestore Database
1. Go to Firebase Console → Firestore Database
2. Click "Create database"
3. Start in **test mode** (for development)
4. Choose a location closest to your users

### 7. Test the Setup
Run the app and test the registration form. Data should be saved to Firestore under the `candidates` collection.

## Data Structure
The app saves candidate data with the following structure:
```json
{
  "fullName": "Mr. Shailesh Sharma",
  "title": "Mr.",
  "gender": "Male",
  "mobileNumber": "9876543210",
  "birthYear": 1990,
  "age": 35,
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "step": 1
}
```

## Troubleshooting
- If you get "Firebase not initialized" error, make sure `firebase_options.dart` is properly configured
- If data is not saving, check Firestore rules in Firebase Console
- Make sure `google-services.json` is in the correct location for Android

