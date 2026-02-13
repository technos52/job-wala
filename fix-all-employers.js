// 🔧 FIREBASE CONSOLE SCRIPT - Fix All Employer Documents
// Copy and paste this code in Firebase Console > Firestore > Rules > Test Functions
// Or run it in Cloud Functions

// This script will:
// 1. Remove redundant 'isApproved' field from ALL employer documents
// 2. Add missing 'reason' field to ALL employer documents 
// 3. Fix any invalid approvalStatus values

async function fixAllEmployerDocuments() {
  console.log('🚀 Starting bulk fix of employer documents...');
  
  try {
    // Get all employer documents
    const employersRef = db.collection('employers');
    const snapshot = await employersRef.get();
    
    console.log(`📄 Found ${snapshot.size} employer documents to check`);
    
    const batch = db.batch();
    let fixedCount = 0;
    
    snapshot.forEach((doc) => {
      const data = doc.data();
      const updates = {};
      let needsUpdate = false;
      
      console.log(`🔍 Checking document: ${doc.id} (${data.companyName || 'Unknown Company'})`);
      
      // Remove redundant isApproved field
      if (data.hasOwnProperty('isApproved')) {
        updates.isApproved = firebase.firestore.FieldValue.delete();
        needsUpdate = true;
        console.log(`  🗑️ Removing 'isApproved' field`);
      }
      
      // Add reason field if missing
      if (!data.hasOwnProperty('reason')) {
        updates.reason = '';
        needsUpdate = true;
        console.log(`  ➕ Adding 'reason' field`);
      }
      
      // Fix approvalStatus if invalid
      const currentStatus = data.approvalStatus;
      if (!currentStatus || !['pending', 'approved', 'rejected'].includes(currentStatus)) {
        updates.approvalStatus = 'pending';
        needsUpdate = true;
        console.log(`  🔧 Fixing approvalStatus from '${currentStatus}' to 'pending'`);
      }
      
      if (needsUpdate) {
        batch.update(doc.ref, updates);
        fixedCount++;
        console.log(`  ✅ Document ${doc.id} will be updated`);
      } else {
        console.log(`  ✨ Document ${doc.id} is already clean`);
      }
    });
    
    if (fixedCount > 0) {
      await batch.commit();
      console.log(`🎉 Successfully fixed ${fixedCount} out of ${snapshot.size} documents!`);
      console.log('✅ All employer documents now have clean structure');
    } else {
      console.log('✨ All employer documents are already clean - no updates needed');
    }
    
    return {
      total: snapshot.size,
      fixed: fixedCount,
      success: true
    };
    
  } catch (error) {
    console.error('❌ Error fixing documents:', error);
    return {
      total: 0,
      fixed: 0,
      success: false,
      error: error.message
    };
  }
}

// 🔥 INSTRUCTIONS TO RUN:
/*
1. Go to Firebase Console: https://console.firebase.google.com
2. Select your project (jobease-edevs)
3. Go to Firestore Database
4. Click on "Rules" tab
5. Click on "Playground"
6. Copy this entire script and paste it
7. Replace the function call below and run it:

fixAllEmployerDocuments().then(result => {
  if (result.success) {
    console.log(`✅ COMPLETED: Fixed ${result.fixed} out of ${result.total} documents`);
  } else {
    console.log(`❌ FAILED: ${result.error}`);
  }
});

*/

// Uncomment this line to run the script:
// fixAllEmployerDocuments();