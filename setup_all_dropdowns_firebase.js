// Script to set up ALL dropdown options in Firebase
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

async function setupAllDropdowns() {
  console.log('🔧 Setting up ALL dropdown options in Firebase...');
  
  const dropdownData = {
    qualification: [
      'Bachelor\'s Degree',
      'Master\'s Degree',
      'PhD',
      'Diploma',
      'Certificate',
    ],
    
    department: [
      'IT',
      'HR', 
      'Finance',
      'Marketing',
      'Sales',
      'Operations'
    ],
    
    designation: [
      'Software Engineer',
      'Manager',
      'Analyst', 
      'Executive',
      'Associate',
    ],
    
    companyType: [
      'Information Technology (IT)',
      'Automobile',
      'Automotive',
      'Pharmaceutical',
      'Healthcare',
      'Banking & Finance',
      'Insurance',
      'Manufacturing',
      'Retail',
      'E-commerce',
      'Education',
      'Consulting',
      'Real Estate',
      'Construction',
      'Telecommunications',
      'Media & Entertainment',
      'Food & Beverage',
      'Textile',
      'Chemical',
      'Oil & Gas',
      'Agriculture',
      'Logistics',
      'Government',
      'Non-Profit',
      'Startup',
      'Other',
    ],
    
    candidateDepartment: [
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
    ],
    
    industryType: [
      'Technology',
      'Healthcare',
      'Finance',
      'Education',
      'Retail',
      'Manufacturing',
    ],
    
    jobCategory: [
      'Software Development',
      'Marketing',
      'Sales',
      'HR',
      'Finance',
      'Operations',
    ],
    
    jobType: [
      'Full Time',
      'Part Time', 
      'Contract',
      'Internship',
      'Remote'
    ],
  };
  
  try {
    console.log('📝 Creating dropdown documents...\n');
    
    for (const [docId, options] of Object.entries(dropdownData)) {
      console.log(`📄 Creating ${docId} with ${options.length} options...`);
      
      await db.collection('dropdown_options').doc(docId).set({
        options: options,
        created_at: admin.firestore.FieldValue.serverTimestamp(),
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
      });
      
      console.log(`✅ ${docId} created successfully`);
      console.log(`   Options: ${options.slice(0, 3).join(', ')}${options.length > 3 ? '...' : ''}\n`);
    }
    
    console.log('🎉 ALL dropdown options setup completed!');
    console.log('💡 All dropdowns should now work properly in the app.');
    
    // Verify the setup
    console.log('\n🔍 Verifying setup...');
    const snapshot = await db.collection('dropdown_options').get();
    console.log(`📊 Total documents created: ${snapshot.docs.length}`);
    
    snapshot.docs.forEach(doc => {
      const data = doc.data();
      console.log(`   ${doc.id}: ${data.options ? data.options.length : 0} options`);
    });
    
  } catch (error) {
    console.error('❌ Error setting up dropdown options:', error);
  }
}

// Run the setup
setupAllDropdowns()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Script failed:', error);
    process.exit(1);
  });