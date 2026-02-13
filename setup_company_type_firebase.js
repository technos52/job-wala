// Script to set up companyType dropdown in Firebase
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

async function setupCompanyTypeDropdown() {
  console.log('🔧 Setting up companyType dropdown in Firebase...');
  
  const companyTypes = [
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
  ];
  
  try {
    // Set the companyType dropdown document
    await db.collection('dropdown_options').doc('companyType').set({
      options: companyTypes,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    console.log('✅ Successfully created companyType dropdown with options:');
    companyTypes.forEach((type, index) => {
      console.log(`  ${index + 1}. ${type}`);
    });
    
    console.log('\n🎉 companyType dropdown setup completed!');
    console.log('💡 The Company Type dropdown should now work properly in candidate registration.');
    
  } catch (error) {
    console.error('❌ Error setting up companyType dropdown:', error);
  }
}

// Run the setup
setupCompanyTypeDropdown()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Script failed:', error);
    process.exit(1);
  });

// If you can't run this script, you can manually add the document in Firebase Console:
// Collection: dropdown_options
// Document ID: companyType  
// Field: options (array)
// Values: [
//   "Information Technology (IT)",
//   "Automobile",
//   "Automotive", 
//   "Pharmaceutical",
//   "Healthcare",
//   "Banking & Finance",
//   "Insurance",
//   "Manufacturing",
//   "Retail",
//   "E-commerce",
//   "Education",
//   "Consulting",
//   "Real Estate",
//   "Construction",
//   "Telecommunications",
//   "Media & Entertainment",
//   "Food & Beverage",
//   "Textile",
//   "Chemical",
//   "Oil & Gas",
//   "Agriculture",
//   "Logistics",
//   "Government",
//   "Non-Profit",
//   "Startup",
//   "Other"
// ]