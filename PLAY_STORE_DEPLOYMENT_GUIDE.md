# Play Store Deployment Guide

## Prerequisites
1. Flutter SDK installed
2. Android SDK installed
3. Java Development Kit (JDK) installed

## Step-by-Step Process

### 1. Create Keystore (First Time Only)
```bash
# Run the keystore creation script
create_keystore.bat  # Windows
# OR
./create_keystore.sh  # Linux/Mac
```

**Important Notes:**
- Use a strong password for both keystore and key
- Keep the same password for keystore and key (recommended)
- Store the keystore file and passwords securely
- You'll need these for all future app updates

### 2. Configure Key Properties
Edit `android/key.properties` with your actual passwords:
```properties
storePassword=YOUR_ACTUAL_KEYSTORE_PASSWORD
keyPassword=YOUR_ACTUAL_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
```

### 3. Build AAB File
```bash
# Run the build script
build_aab.bat  # Windows
# OR
./build_aab.sh  # Linux/Mac
```

### 4. Locate Your AAB File
The AAB file will be created at:
`build/app/outputs/bundle/release/app-release.aab`

### 5. Upload to Google Play Console
1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app or create a new one
3. Go to "Release" > "Production"
4. Click "Create new release"
5. Upload the `app-release.aab` file
6. Fill in release notes and other required information
7. Review and publish

## Troubleshooting

### Common Issues:
1. **Keystore not found**: Ensure the keystore file path is correct in `key.properties`
2. **Build fails**: Run `flutter doctor` to check for issues
3. **Signing errors**: Verify passwords in `key.properties` are correct

### Testing Your AAB (Optional)
You can test your AAB file using bundletool:
```bash
# Download bundletool from Google
# Generate APKs from AAB
java -jar bundletool.jar build-apks --bundle=app-release.aab --output=app.apks

# Install on device
java -jar bundletool.jar install-apks --apks=app.apks
```

## Security Notes
- Never commit `key.properties` or keystore files to version control
- Keep backups of your keystore file in a secure location
- If you lose your keystore, you cannot update your app on Play Store

## Version Management
- Update version in `pubspec.yaml` before each release
- Version format: `major.minor.patch+build`
- Example: `1.0.1+2` (version 1.0.1, build 2)