# Quick Keystore Setup

Since the automated keystore creation had issues, here's a manual approach:

## Option 1: Use Android Studio
1. Open Android Studio
2. Go to Build > Generate Signed Bundle/APK
3. Choose "Android App Bundle"
4. Click "Create new..." to create a keystore
5. Fill in the details and save the keystore

## Option 2: Manual keytool command
Open a new command prompt and run:
```
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
Then enter:
- Keystore password: jobber123
- Key password: jobber123
- First and last name: Jobber App
- Organizational unit: Development
- Organization: Jobber
- City: Your City
- State: Your State
- Country code: US
- Confirm: yes

## Option 3: Use Debug Signing (Temporary)
For testing purposes, the current build.gradle is set to use debug signing.
This will work for testing but you'll need a proper keystore for Play Store.

## Current Status
The app is configured to build with debug signing for now.
Run `build_aab_simple.bat` to create the AAB file.