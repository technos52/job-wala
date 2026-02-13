# Clean Build Guide - Fix Cache Issues

## Problem
Cache issues can prevent Firebase data changes from being reflected in the app, causing:
- Job categories not loading from Firebase
- Filter options not updating dynamically
- Old cached data being displayed

## Solution: Complete Clean Build

### Option 1: Automated Clean Build (Recommended)

#### For Windows:
```bash
# Run the automated script
clean_build_and_run.bat
```

#### For Mac/Linux:
```bash
# Make script executable
chmod +x clean_build_and_run.sh

# Run the automated script
./clean_build_and_run.sh
```

### Option 2: Manual Clean Build Steps

#### Step 1: Clean Flutter Cache
```bash
flutter clean
```

#### Step 2: Clear Build Directories
```bash
# Windows
rmdir /s /q build
rmdir /s /q .dart_tool

# Mac/Linux
rm -rf build
rm -rf .dart_tool
```

#### Step 3: Get Fresh Dependencies
```bash
flutter pub get
```

#### Step 4: Build Fresh APK
```bash
flutter build apk --debug
```

#### Step 5: Install on Device
```bash
flutter install
```

#### Step 6: Run with Fresh Data
```bash
flutter run --debug
```

## Cache-Busting Features Added

### 1. Force Server Fetch
All Firebase calls now use `Source.server` to bypass cache:

```dart
// Job Categories
final categoryDoc = await FirebaseFirestore.instance
    .collection('dropdownData')
    .doc('jobCategory')
    .get(const GetOptions(source: Source.server)); // Force server fetch

// Filter Options
final doc = await FirebaseFirestore.instance
    .collection('dropdownData')
    .doc(field)
    .get(const GetOptions(source: Source.server)); // Force server fetch

// Jobs Collection
final jobsQuery = await FirebaseFirestore.instance
    .collection('jobs')
    .where('approvalStatus', isEqualTo: 'approved')
    .get(const GetOptions(source: Source.server)); // Force server fetch
```

### 2. Enhanced Debug Logging
Added comprehensive logging to track data loading:

```
🔍 Loading job categories from Firebase (cache-busted)...
✅ jobCategory document exists (fresh from server)
📄 Raw job category data: {...}
📊 Found 8 options in jobCategory
✓ Found category with key "0": Company Jobs
✅ ADDED: Company Jobs
🎉 Job categories loaded successfully: [All Jobs, Company Jobs, ...]
```

## Verification Steps

### 1. Check Console Output
After clean build, look for these messages:
```
🔍 Loading job categories from Firebase (cache-busted)...
✅ jobCategory document exists (fresh from server)
📊 Found 8 job categories from Firebase: [Company Jobs, Bank/NBFC Jobs, ...]
🎉 Job categories loaded successfully: [All Jobs, Company Jobs, Bank/NBFC Jobs, ...]
```

### 2. Verify UI Changes
- **Job Categories**: Should show all 8 categories from Firebase
- **Filter Options**: Should show all values from Firebase dropdownData
- **No Cache Messages**: Should see "fresh from server" in logs

### 3. Test Functionality
- Tap each job category tab
- Open filter dialog and check all options
- Verify all categories are clickable and functional

## Troubleshooting

### If Clean Build Fails
1. **Check Flutter Installation**:
   ```bash
   flutter doctor
   ```

2. **Clear Pub Cache**:
   ```bash
   flutter pub cache clean
   flutter pub get
   ```

3. **Restart IDE**: Close and reopen your development environment

4. **Check Device Connection**:
   ```bash
   flutter devices
   ```

### If Data Still Not Loading
1. **Check Firebase Rules**: Ensure read permissions are correct
2. **Verify Internet Connection**: App needs network access
3. **Check Firebase Project**: Ensure correct project is connected
4. **Review Console Logs**: Look for specific error messages

### Common Issues and Solutions

#### Issue: "Source.server not recognized"
**Solution**: Ensure you have the latest Firebase SDK:
```yaml
dependencies:
  cloud_firestore: ^4.15.0  # or latest version
```

#### Issue: Build fails with cache errors
**Solution**: Complete cache clear:
```bash
flutter clean
flutter pub cache clean
rm -rf ~/.pub-cache  # Mac/Linux
rmdir /s /q %APPDATA%\Pub\Cache  # Windows
flutter pub get
```

#### Issue: App crashes on startup
**Solution**: Check Firebase configuration:
1. Verify `google-services.json` (Android) is in `android/app/`
2. Verify `GoogleService-Info.plist` (iOS) is in `ios/Runner/`
3. Ensure Firebase is initialized in `main.dart`

## Expected Results After Clean Build

### Job Categories
✅ All 8 categories should appear:
- All Jobs
- Company Jobs
- Bank/NBFC Jobs
- School Jobs
- Hospital Jobs
- Hotel/Bar Jobs
- Government Jobs
- Mall/Shopkeeper Jobs
- aaaa

### Filter Options
✅ Dynamic loading from Firebase:
- Job Type options from `dropdownData/jobType`
- Department options from `dropdownData/department`
- Candidate Department options from `dropdownData/candidateDepartment`
- Designation options from `dropdownData/designation`
- Location options from `dropdownData/location`

### Performance
✅ Fresh data loading:
- No cached data interference
- Real-time Firebase synchronization
- Proper error handling and fallbacks

## Next Steps

1. **Run Clean Build**: Use the automated script or manual steps
2. **Monitor Console**: Watch for debug messages during data loading
3. **Test Thoroughly**: Verify all categories and filters work
4. **Report Issues**: If problems persist, check Firebase console and app logs

The clean build process should resolve all cache-related issues and ensure fresh data loading from Firebase.