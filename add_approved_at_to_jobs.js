// Script to add approvedAt field to existing approved jobs
// This will set approvedAt to the current timestamp for all approved jobs

const admin = require('firebase-admin');

// Initialize Firebase Admin (you'll need to configure this with your service account)
// admin.initializeApp({
//   credential: admin.credential.cert(require('./path-to-service-account-key.json')),
//   databaseURL: 'https://your-project-id.firebaseio.com'
// });

const db = admin.firestore();

async function addApprovedAtToJobs() {
  try {
    console.log('🔍 Fetching all approved jobs...');
    
    // Get all approved jobs
    const jobsSnapshot = await db
      .collection('jobs')
      .where('approvalStatus', '==', 'approved')
      .get();
    
    console.log(`✅ Found ${jobsSnapshot.docs.length} approved jobs`);
    
    if (jobsSnapshot.empty) {
      console.log('❌ No approved jobs found');
      return;
    }
    
    const batch = db.batch();
    let updateCount = 0;
    
    for (const doc of jobsSnapshot.docs) {
      const data = doc.data();
      
      // Only update if approvedAt doesn't exist
      if (!data.approvedAt) {
        // Use postedDate as approvedAt if available, otherwise use current time
        const approvedAt = data.postedDate || admin.firestore.FieldValue.serverTimestamp();
        
        batch.update(doc.ref, {
          approvedAt: approvedAt
        });
        
        updateCount++;
        console.log(`📝 Queued update for job: ${data.jobTitle || doc.id}`);
      } else {
        console.log(`⏭️ Job ${data.jobTitle || doc.id} already has approvedAt`);
      }
    }
    
    if (updateCount > 0) {
      console.log(`🚀 Updating ${updateCount} jobs with approvedAt field...`);
      await batch.commit();
      console.log('✅ Successfully added approvedAt to all approved jobs');
    } else {
      console.log('ℹ️ All jobs already have approvedAt field');
    }
    
  } catch (error) {
    console.error('❌ Error adding approvedAt to jobs:', error);
  }
}

// Run the script
addApprovedAtToJobs();