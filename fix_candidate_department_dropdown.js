// Script to check and fix candidateDepartment dropdown options in Firebase
const admin = require('firebase-admin');

// Initialize Firebase Admin (make sure you have the service account key)
try {
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    // Add your project ID if needed
  });
} catch (error) {
  console.log('Firebase already initialized or error:', error.message);
}

const db = admin.firestore();

async function fixCandidateDepartmentDropdown() {
  console.log('🔍 Checking and fixing candidateDepartment dropdown...');
  
  try {
    // Check if candidateDepartment dropdown exists
    const candidateDeptRef = db.collection('dropdown_options').doc('candidateDepartment');
    const candidateDeptDoc = await candidateDeptRef.get();
    
    const expectedDepartments = [
      'Information Technology',
      'Human Resources',
      'Finance & Accounting', 
      'Marketing & Sales',
      'Operations',
      'Customer Service',
      'Engineering',
      'Design & Creative',
      'Legal',
      'Administration',
    ];
    
    if (candidateDeptDoc.exists) {
      const data = candidateDeptDoc.data();
      console.log('✅ candidateDepartment document exists:', data);
      
      // Check if it has the expected structure
      let needsUpdate = false;
      
      if (!data.options || !Array.isArray(data.options)) {
        needsUpdate = true;
        console.log('⚠️ candidateDepartment document missing options array');
      } else {
        const currentOptions = data.options;
        const missingDepts = expectedDepartments.filter(dept => !currentOptions.includes(dept));
        
        if (missingDepts.length > 0) {
          needsUpdate = true;
          console.log('⚠️ Missing departments:', missingDepts);
        }
      }
      
      if (needsUpdate) {
        await candidateDeptRef.update({
          options: expectedDepartments
        });
        console.log('✅ Updated candidateDepartment dropdown with all expected options');
      } else {
        console.log('✅ candidateDepartment dropdown is already properly configured');
      }
    } else {
      console.log('❌ candidateDepartment document does not exist, creating it...');
      
      await candidateDeptRef.set({
        options: expectedDepartments
      });
      
      console.log('✅ Created candidateDepartment dropdown with options:', expectedDepartments);
    }
    
    // Now check some jobs to see if they have candidateDepartment field
    console.log('\n📊 Checking jobs for candidateDepartment field usage...');
    
    const jobsSnapshot = await db.collection('jobs')
      .where('approvalStatus', '==', 'approved')
      .limit(10)
      .get();
    
    console.log(`Found ${jobsSnapshot.docs.length} approved jobs to check`);
    
    const candidateDeptValues = new Set();
    let jobsWithCandidateDept = 0;
    
    jobsSnapshot.docs.forEach(doc => {
      const data = doc.data();
      const candidateDept = data.candidateDepartment;
      
      if (candidateDept && candidateDept !== 'null' && candidateDept.trim() !== '') {
        candidateDeptValues.add(candidateDept);
        jobsWithCandidateDept++;
        console.log(`📋 Job "${data.jobTitle}" has candidateDepartment: "${candidateDept}"`);
      }
    });
    
    if (jobsWithCandidateDept === 0) {
      console.log('⚠️ No jobs found with candidateDepartment field populated');
      console.log('💡 You may need to update job posting forms to include this field');
    } else {
      console.log(`✅ Found ${jobsWithCandidateDept} jobs with candidateDepartment field`);
      console.log('📊 Unique candidate departments in jobs:', Array.from(candidateDeptValues));
    }
    
    console.log('\n🎉 candidateDepartment dropdown check/fix completed!');
    
  } catch (error) {
    console.error('❌ Error fixing candidateDepartment dropdown:', error);
  }
}

// Run the fix
fixCandidateDepartmentDropdown()
  .then(() => {
    console.log('Script completed successfully');
    process.exit(0);
  })
  .catch((error) => {
    console.error('Script failed:', error);
    process.exit(1);
  });