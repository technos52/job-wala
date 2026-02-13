# Name & Title Update Debug Steps

## Current Status
✅ **Edit Profile Logic**: Correctly implemented with debugging
✅ **Dashboard Refresh**: Already implemented with proper callbacks
✅ **Data Loading**: Uses `Source.server` for fresh data
✅ **Welcome Message**: Proper title extraction and generation

## Debug Steps to Follow

### 1. Test Edit Profile Save
1. Open edit profile screen
2. Check console for loading debug:
   ```
   📄 Found candidate document: [doc_id]
   🔍 Original fullName from DB: "Dr. sharma"
   🏷️ Removed title prefix, remaining name: "sharma"
   🏷️ Loaded title: "Dr."
   📝 Name controller set to: "sharma"
   ```

3. Change name to "John" and title to "Mr."
4. Save and check console for saving debug:
   ```
   💾 Saving profile data:
      Name field: "John"
      Selected title: "Mr."
      Full name to save: "Mr. John"
   📊 Complete update data: {fullName: Mr. John, title: Mr., ...}
   ✅ Profile updated successfully
   ```

### 2. Test Dashboard Refresh
1. After saving, check console for refresh debug:
   ```
   🔄 Profile was updated, refreshing all data...
   🔍 Loading candidate profile for user: [uid]
   📄 Candidate data by email: {fullName: Mr. John, ...}
   ✅ Got name from Firestore: Mr. John
   🧹 Removed title "Mr." from name: "Mr. John" -> "John"
   🎯 Determining title for gender: "male"
   🎉 Generated welcome message: "Welcome\nMr John"
   ```

### 3. Expected UI Changes
- **Before**: "Welcome Mrs kds singhawat"
- **After**: "Welcome Mr John"

## Potential Issues & Solutions

### Issue 1: Database Not Updating
**Symptoms**: Save debug shows correct data but dashboard still shows old name
**Solution**: Check Firestore console to verify data was actually saved

### Issue 2: Dashboard Not Refreshing
**Symptoms**: Database has new data but dashboard shows old name
**Solution**: Already fixed - refresh logic is implemented

### Issue 3: Gender-Based Title Issue
**Symptoms**: Name updates but title doesn't match
**Debug**: Check gender field in database
**Solution**: Ensure gender is saved correctly in edit profile

### Issue 4: Title Extraction Issue
**Symptoms**: Welcome message shows "Welcome Mr Mr. John"
**Debug**: Check title removal logic
**Solution**: Already handled in dashboard code

## Quick Test Commands

### Check Current Database State
```javascript
// In Firestore console
db.collection('candidates').where('email', '==', 'imshailesharma@gmail.com').get()
```

### Force Refresh Test
```dart
// In dashboard, add button to force refresh
ElevatedButton(
  onPressed: () async {
    await _loadCandidateProfile();
  },
  child: Text('Force Refresh'),
)
```

## Most Likely Scenario

Based on the code analysis, the name and title update should work correctly. The issue might be:

1. **Caching**: Despite `Source.server`, there might be a caching issue
2. **Timing**: The save might take a moment to propagate
3. **Multiple Documents**: There might be multiple candidate documents

## Verification Steps

1. **Check Firestore Console**: Verify the document actually has the new name
2. **Check Debug Logs**: Follow the debug output step by step
3. **Test Refresh Button**: Add a manual refresh button to test
4. **Check Network**: Ensure device has good internet connection

## Expected Resolution

The debugging will show exactly where the issue is:
- If save debug shows correct data → Database update works
- If refresh debug shows correct data → Dashboard refresh works  
- If welcome message debug shows correct data → UI should update

The issue is likely a minor timing or caching issue that the debugging will reveal.