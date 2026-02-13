// Firebase Migration Script - Clean Up Employer Collection
// Run this in Firebase Console Functions or as a one-time script

/*
  This script:
  1. Removes redundant 'isApproved' field from all employer documents
  2. Ensures 'reason' field exists and is empty by default
  3. Standardizes approvalStatus values
*/

const admin = require('firebase-admin');

// Initialize Firebase Admin (uncomment and configure for your project)
/*
const serviceAccount = require('./path/to/serviceAccount.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
*/

const db = admin.firestore();

async function cleanUpEmployerCollection() {
  console.log('🚀 Starting employer collection cleanup...');
  
  try {
    const employersSnapshot = await db.collection('employers').get();
    console.log(`📄 Found ${employersSnapshot.size} employer documents`);
    
    const batch = db.batch();
    let updateCount = 0;
    
    employersSnapshot.forEach((doc) => {
      const data = doc.data();
      const updates = {};
      let needsUpdate = false;
      
      // Remove redundant isApproved field if it exists
      if (data.hasOwnProperty('isApproved')) {
        updates['isApproved'] = admin.firestore.FieldValue.delete();
        needsUpdate = true;
        console.log(`🗑️  Removing 'isApproved' field from: ${data.companyName || doc.id}`);
      }
      
      // Ensure reason field exists
      if (!data.hasOwnProperty('reason')) {
        updates['reason'] = '';
        needsUpdate = true;
        console.log(`➕ Adding 'reason' field to: ${data.companyName || doc.id}`);
      }
      
      // Standardize approvalStatus values
      const currentStatus = data.approvalStatus;
      if (!currentStatus || !['pending', 'approved', 'rejected'].includes(currentStatus)) {
        updates['approvalStatus'] = 'pending';
        needsUpdate = true;
        console.log(`🔧 Fixing approvalStatus for: ${data.companyName || doc.id}`);
      }
      
      if (needsUpdate) {
        batch.update(doc.ref, updates);
        updateCount++;
      }
    });
    
    if (updateCount > 0) {
      await batch.commit();
      console.log(`✅ Successfully updated ${updateCount} employer documents`);
    } else {
      console.log('✨ All employer documents are already clean!');
    }
    
    console.log('🎉 Cleanup completed successfully!');
    
  } catch (error) {
    console.error('❌ Error during cleanup:', error);
  }
}

// Uncomment the line below to run the migration
// cleanUpEmployerCollection();

/*
  Usage Instructions:
  1. Download your Firebase service account key
  2. Update the serviceAccount path above
  3. Uncomment the initialization code
  4. Uncomment the function call at the end
  5. Run: node cleanup-employer-collection.js
  
  OR run directly in Firebase Console Functions panel
*/

module.exports = { cleanUpEmployerCollection };