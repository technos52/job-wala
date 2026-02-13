# Deploy Firestore Indexes

## Issue
The app is showing a Firestore index error because the composite index for `approvalStatus` + `postedDate` ordering is not deployed to the Firebase project.

## Quick Fix Applied
- Temporarily removed server-side `orderBy` clause to avoid the index requirement
- Using client-side sorting to ensure latest jobs appear first
- This will work immediately while you deploy the proper indexes

## Deploy the Indexes

### Option 1: Using Firebase CLI (Recommended)
1. Install Firebase CLI if not already installed:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Initialize Firebase in your project directory (if not done):
   ```bash
   firebase init firestore
   ```

4. Deploy the indexes:
   ```bash
   firebase deploy --only firestore:indexes
   ```

### Option 2: Manual Creation via Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to Firestore Database → Indexes → Composite
4. Click "Create Index"
5. Set up the index:
   - Collection ID: `jobs`
   - Field 1: `approvalStatus` (Ascending)
   - Field 2: `postedDate` (Descending)
   - Query scope: Collection

### Option 3: Use the Error Link
The error message provides a direct link to create the index. Click on the link in the error message to automatically create the required index.

## After Index Deployment
Once the index is deployed (usually takes a few minutes), you can:

1. Update the job fetching query to use server-side ordering:
   ```dart
   final jobsQuery = await FirebaseFirestore.instance
       .collection('jobs')
       .where('approvalStatus', isEqualTo: 'approved')
       .orderBy('postedDate', descending: true)
       .get();
   ```

2. This will provide better performance and ensure consistent ordering across all devices.

## Current Status
✅ **App works now** - Latest jobs appear first using client-side sorting
⏳ **Deploy indexes** - For better performance and server-side ordering
🎯 **Future-ready** - Index configuration already exists in `firestore.indexes.json`

## Verification
After deploying indexes, the app should work without any errors and show latest jobs at the top with improved performance.