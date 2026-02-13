// Script to set up candidateDepartment dropdown in Firebase
// Run this if you have Firebase CLI and admin access

const admin = require('firebase-admin');

// Initialize Firebase Admin
// Make sure you have GOOGLE_APPLICATION_CREDENTIALS set or service account key
try {
  admin.initializeApp();
} catch (error) {
  console.log('Firebase initialization:', error.message);
}

const db = admin.firestore();

async function setupCandidateDepartmentDropdown() {
  console.log('🔧 Setting up candidateDepartment dropdown in Firebase...');
  
  const candidateDepartments = [
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
  
  try {
    // Set the candidateDepartment dropdown document
    await db.collection('dropdown_options').doc('candidateDepartment').set({
      options: candidateDepartments
    });
    
    console.log('✅ Successfully created candidateDepartment dropdown with options:');
    candidateDepartments.forEach((dept, index) => {
      console.log(`  ${index + 1}. ${dept}`);
    });
    
    console.log('\n🎉 candidateDepartment dropdown setup completed!');
    console.log('💡 The Candidate Department filter should now work properly in the app.');
    
  } catch (error) {
    console.error('❌ Error setting up candidateDepartment dropdown:', error);
  }
}

// Run the setup
setupCandidateDepartmentDropdown()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Script failed:', error);
    process.exit(1);
  });

// If you can't run this script, you can manually add the document in Firebase Console:
// Collection: dropdown_options
// Document ID: candidateDepartment  
// Field: options (array)
// Values: [
//   "Information Technology",
//   "Human Resources", 
//   "Finance & Accounting",
//   "Marketing & Sales",
//   "Operations", 
//   "Customer Service",
//   "Engineering",
//   "Design & Creative",
//   "Legal",
//   "Administration"
// ]