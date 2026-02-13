const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    // Add your project config here if needed
  });
}

const db = admin.firestore();

/**
 * Migration script to move job application data from subcollections 
 * to main candidate documents for better analytics performance
 */
async function migrateApplicationsToMainDocument() {
  console.log('🚀 Starting migration: Moving applications from subcollections to main documents...\n');

  try {
    // Get all candidates
    const candidatesSnapshot = await db.collection('candidates').get();
    console.log(`📊 Found ${candidatesSnapshot.docs.length} candidates to process\n`);

    let processedCount = 0;
    let errorCount = 0;

    for (const candidateDoc of candidatesSnapshot.docs) {
      const candidateId = candidateDoc.id;
      const candidateData = candidateDoc.data();

      try {
        console.log(`👤 Processing candidate: ${candidateId}`);

        // Get all applications from subcollection
        const applicationsSnapshot = await db
          .collection('candidates')
          .doc(candidateId)
          .collection('applications')
          .get();

        if (applicationsSnapshot.empty) {
          console.log(`   ℹ️  No applications found for ${candidateId}`);
          continue;
        }

        console.log(`   📋 Found ${applicationsSnapshot.docs.length} applications`);

        // Prepare applications array for main document
        const applications = [];
        const applicationStats = {
          totalApplications: 0,
          monthlyApplications: {},
          jobCategoryPreferences: {},
          locationPreferences: {},
          industryPreferences: {},
          statusCounts: {
            pending: 0,
            accepted: 0,
            rejected: 0
          },
          lastApplicationDate: null,
          firstApplicationDate: null
        };

        // Process each application
        for (const appDoc of applicationsSnapshot.docs) {
          const appData = appDoc.data();
          
          // Add application to array with essential data
          const applicationEntry = {
            applicationId: appDoc.id,
            jobId: appData.jobId,
            jobTitle: appData.jobTitle || appData['Job Title'] || 'N/A',
            companyName: appData.companyName || appData['Company Name'] || 'N/A',
            location: appData.location || appData.jobLocation || 'N/A',
            jobCategory: appData.jobCategory || appData['Job Category'] || 'N/A',
            industryType: appData.industryType || 'N/A',
            appliedDate: appData.appliedDate || appData.createdAt || admin.firestore.Timestamp.now(),
            status: appData.status || 'pending',
            salaryRange: appData.salaryRange || appData['Salary Range'] || 'N/A',
            experienceRequired: appData.experienceRequired || appData['Experience Required'] || 'N/A',
            
            // Analytics fields
            applicationSource: appData.applicationSource || 'mobile_app',
            deviceInfo: appData.deviceInfo || 'flutter_mobile',
            
            // Status history if available
            statusHistory: appData.statusHistory || [{
              status: appData.status || 'pending',
              timestamp: appData.appliedDate || appData.createdAt || admin.firestore.Timestamp.now(),
              note: 'Initial application'
            }]
          };

          applications.push(applicationEntry);

          // Update statistics
          applicationStats.totalApplications++;
          
          // Monthly stats
          const appDate = applicationEntry.appliedDate.toDate();
          const monthKey = `${appDate.getFullYear()}_${String(appDate.getMonth() + 1).padStart(2, '0')}`;
          applicationStats.monthlyApplications[monthKey] = (applicationStats.monthlyApplications[monthKey] || 0) + 1;

          // Category preferences
          const category = applicationEntry.jobCategory;
          applicationStats.jobCategoryPreferences[category] = (applicationStats.jobCategoryPreferences[category] || 0) + 1;

          // Location preferences
          const location = applicationEntry.location;
          applicationStats.locationPreferences[location] = (applicationStats.locationPreferences[location] || 0) + 1;

          // Industry preferences
          const industry = applicationEntry.industryType;
          if (industry !== 'N/A') {
            applicationStats.industryPreferences[industry] = (applicationStats.industryPreferences[industry] || 0) + 1;
          }

          // Status counts
          const status = applicationEntry.status.toLowerCase();
          if (applicationStats.statusCounts.hasOwnProperty(status)) {
            applicationStats.statusCounts[status]++;
          }

          // Date tracking
          if (!applicationStats.firstApplicationDate || appDate < applicationStats.firstApplicationDate.toDate()) {
            applicationStats.firstApplicationDate = applicationEntry.appliedDate;
          }
          if (!applicationStats.lastApplicationDate || appDate > applicationStats.lastApplicationDate.toDate()) {
            applicationStats.lastApplicationDate = applicationEntry.appliedDate;
          }
        }

        // Sort applications by date (newest first)
        applications.sort((a, b) => b.appliedDate.toDate() - a.appliedDate.toDate());

        // Update candidate document with applications and stats
        const updateData = {
          ...candidateData,
          applications: applications,
          applicationStats: applicationStats,
          analyticsUpdatedAt: admin.firestore.Timestamp.now(),
          migrationCompleted: true,
          migrationDate: admin.firestore.Timestamp.now()
        };

        // Update the main candidate document
        await db.collection('candidates').doc(candidateId).set(updateData, { merge: true });

        console.log(`   ✅ Successfully migrated ${applications.length} applications for ${candidateId}`);
        processedCount++;

      } catch (error) {
        console.error(`   ❌ Error processing candidate ${candidateId}:`, error.message);
        errorCount++;
      }
    }

    console.log('\n📈 Migration Summary:');
    console.log(`   ✅ Successfully processed: ${processedCount} candidates`);
    console.log(`   ❌ Errors encountered: ${errorCount} candidates`);
    console.log(`   📊 Total candidates: ${candidatesSnapshot.docs.length}`);

    if (errorCount === 0) {
      console.log('\n🎉 Migration completed successfully!');
      console.log('\n📝 Next steps:');
      console.log('   1. Test the new analytics dashboard');
      console.log('   2. Verify application data integrity');
      console.log('   3. Update application submission code to use new structure');
      console.log('   4. Consider removing old subcollections after verification');
    } else {
      console.log('\n⚠️  Migration completed with some errors. Please review the error logs.');
    }

  } catch (error) {
    console.error('💥 Migration failed:', error);
    throw error;
  }
}

/**
 * Cleanup function to remove old subcollections (run after verification)
 */
async function cleanupOldSubcollections() {
  console.log('🧹 Starting cleanup of old subcollections...\n');

  try {
    const candidatesSnapshot = await db.collection('candidates').get();
    let cleanedCount = 0;

    for (const candidateDoc of candidatesSnapshot.docs) {
      const candidateId = candidateDoc.id;
      
      // Check if migration was completed for this candidate
      const candidateData = candidateDoc.data();
      if (!candidateData.migrationCompleted) {
        console.log(`   ⏭️  Skipping ${candidateId} - migration not completed`);
        continue;
      }

      try {
        // Delete applications subcollection
        const applicationsSnapshot = await db
          .collection('candidates')
          .doc(candidateId)
          .collection('applications')
          .get();

        if (!applicationsSnapshot.empty) {
          const batch = db.batch();
          applicationsSnapshot.docs.forEach(doc => {
            batch.delete(doc.ref);
          });
          await batch.commit();
          console.log(`   🗑️  Cleaned up ${applicationsSnapshot.docs.length} application documents for ${candidateId}`);
        }

        // Delete analytics subcollection if it exists
        const analyticsSnapshot = await db
          .collection('candidates')
          .doc(candidateId)
          .collection('analytics')
          .get();

        if (!analyticsSnapshot.empty) {
          const batch = db.batch();
          analyticsSnapshot.docs.forEach(doc => {
            batch.delete(doc.ref);
          });
          await batch.commit();
          console.log(`   🗑️  Cleaned up analytics subcollection for ${candidateId}`);
        }

        cleanedCount++;

      } catch (error) {
        console.error(`   ❌ Error cleaning up ${candidateId}:`, error.message);
      }
    }

    console.log(`\n✅ Cleanup completed for ${cleanedCount} candidates`);

  } catch (error) {
    console.error('💥 Cleanup failed:', error);
    throw error;
  }
}

// Export functions for use
module.exports = {
  migrateApplicationsToMainDocument,
  cleanupOldSubcollections
};

// Run migration if this file is executed directly
if (require.main === module) {
  migrateApplicationsToMainDocument()
    .then(() => {
      console.log('\n🏁 Migration script completed');
      process.exit(0);
    })
    .catch((error) => {
      console.error('\n💥 Migration script failed:', error);
      process.exit(1);
    });
}