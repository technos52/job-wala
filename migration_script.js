// This is a one-time migration script to add approval fields to existing employers
// Run this in Firebase console or create a separate utility

/*
const admin = require('firebase-admin');
const serviceAccount = require('./path/to/serviceAccount.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function migrateExistingEmployers() {
  try {
    const employersSnapshot = await db.collection('employers').get();
    
    const batch = db.batch();
    
    employersSnapshot.forEach((doc) => {
      const data = doc.data();
      
      // Only update if approval fields don't exist
      if (!data.hasOwnProperty('approvalStatus')) {
        const updateData = {
          approvalStatus: 'pending',
          isApproved: false,
          approvedAt: null,
          approvedBy: null
        };
        
        batch.update(doc.ref, updateData);
        console.log(`Updating employer: ${data.companyName || doc.id}`);
      }
    });
    
    await batch.commit();
    console.log('Migration completed successfully!');
    
  } catch (error) {
    console.error('Migration failed:', error);
  }
}

// Uncomment the line below to run the migration
// migrateExistingEmployers();
*/

// Alternative: Manual Firestore Console Commands
/*
To run in Firestore console, create a new collection query:
1. Go to Firestore Database
2. Select 'employers' collection
3. For each document that doesn't have 'approvalStatus' field:
   - Edit the document
   - Add these fields:
     * approvalStatus: "pending" (string)
     * isApproved: false (boolean)
     * approvedAt: null
     * approvedBy: null
*/