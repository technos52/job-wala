// Simple Node.js script to test Firebase dropdown data
// Run with: node test_firebase_dropdown.js

const admin = require('firebase-admin');

// Initialize Firebase Admin (you'll need to set up service account)
// For now, this is just a template to show what we need to check

async function testDropdownData() {
  try {
    console.log('🔍 Testing Firebase dropdown data...');
    
    // Get all documents in dropdown_options collection
    const snapshot = await admin.firestore()
      .collection('dropdown_options')
      .get();
    
    console.log(`📄 Found ${snapshot.docs.length} documents in dropdown_options`);
    
    snapshot.docs.forEach(doc => {
      const data = doc.data();
      console.log(`📊 Document: ${doc.id}`);
      console.log(`   Options count: ${data.options ? data.options.length : 0}`);
      console.log(`   Options: ${JSON.stringify(data.options || [])}`);
      console.log('');
    });
    
  } catch (error) {
    console.error('❌ Error testing dropdown data:', error);
  }
}

// Uncomment and run if you have Firebase Admin SDK set up
// testDropdownData();

console.log('This script requires Firebase Admin SDK setup.');
console.log('The dropdown documents should be:');
console.log('- qualification');
console.log('- department'); 
console.log('- designation');
console.log('- companyType');
console.log('- candidateDepartment');
console.log('- industryType');
console.log('- jobCategory');
console.log('- jobType');