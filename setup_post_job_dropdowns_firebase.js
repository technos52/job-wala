// Script to set up POST JOB dropdown options in Firebase
// This creates the missing dropdown documents needed for the post job screen

const admin = require('firebase-admin');

// Initialize Firebase Admin
try {
  admin.initializeApp();
} catch (error) {
  console.log('Firebase initialization:', error.message);
}

const db = admin.firestore();

async function setupPostJobDropdowns() {
  console.log('🔧 Setting up POST JOB dropdown options in Firebase...');
  
  const postJobDropdowns = {
    // Job Categories - already exists in setup script
    jobCategory: [
      'Software Development',
      'Web Development',
      'Mobile Development',
      'Data Science',
      'Machine Learning',
      'DevOps',
      'Quality Assurance',
      'UI/UX Design',
      'Product Management',
      'Project Management',
      'Business Analysis',
      'Marketing',
      'Digital Marketing',
      'Content Marketing',
      'Sales',
      'Customer Success',
      'Human Resources',
      'Finance',
      'Accounting',
      'Operations',
      'Supply Chain',
      'Legal',
      'Consulting',
      'Research',
      'Healthcare',
      'Education',
      'Other'
    ],
    
    // Job Types - already exists in setup script  
    jobType: [
      'Full Time',
      'Part Time',
      'Contract',
      'Freelance',
      'Internship',
      'Temporary',
      'Remote',
      'Hybrid'
    ],
    
    // Departments - already exists in setup script
    department: [
      'Information Technology',
      'Software Development',
      'Data Science',
      'Engineering',
      'Product',
      'Design',
      'Marketing',
      'Sales',
      'Customer Success',
      'Human Resources',
      'Finance',
      'Accounting',
      'Operations',
      'Supply Chain',
      'Legal',
      'Administration',
      'Research & Development',
      'Quality Assurance',
      'Business Development',
      'Consulting',
      'Other'
    ],
    
    // Experience Levels - NEW
    experienceLevel: [
      'Entry Level (0-1 years)',
      'Junior Level (1-3 years)', 
      'Mid Level (3-5 years)',
      'Senior Level (5-8 years)',
      'Lead Level (8-12 years)',
      'Principal Level (12+ years)',
      'Executive Level'
    ],
    
    // Industry Types - already exists in setup script
    industryType: [
      'Information Technology',
      'Software & Technology',
      'Financial Services',
      'Banking',
      'Insurance',
      'Healthcare',
      'Pharmaceuticals',
      'Biotechnology',
      'Manufacturing',
      'Automotive',
      'Aerospace',
      'Energy',
      'Oil & Gas',
      'Renewable Energy',
      'Retail',
      'E-commerce',
      'Consumer Goods',
      'Food & Beverage',
      'Hospitality',
      'Travel & Tourism',
      'Real Estate',
      'Construction',
      'Architecture',
      'Education',
      'Training',
      'Media & Entertainment',
      'Advertising',
      'Marketing',
      'Telecommunications',
      'Transportation',
      'Logistics',
      'Supply Chain',
      'Agriculture',
      'Government',
      'Non-Profit',
      'Consulting',
      'Legal Services',
      'Accounting',
      'Human Resources',
      'Startup',
      'Other'
    ],
    
    // Salary Ranges - NEW
    salaryRange: [
      'Below ₹3 LPA',
      '₹3-5 LPA',
      '₹5-8 LPA', 
      '₹8-12 LPA',
      '₹12-18 LPA',
      '₹18-25 LPA',
      '₹25-35 LPA',
      '₹35-50 LPA',
      'Above ₹50 LPA',
      'Negotiable'
    ],
    
    // Work Modes - NEW
    workMode: [
      'Work from Office',
      'Work from Home',
      'Hybrid (Office + Remote)',
      'Flexible Location',
      'On-site Client Location',
      'Travel Required'
    ]
  };
  
  try {
    console.log('📝 Creating/updating post job dropdown documents...\n');
    
    for (const [docId, options] of Object.entries(postJobDropdowns)) {
      console.log(`📄 Creating/updating ${docId} with ${options.length} options...`);
      
      await db.collection('dropdown_options').doc(docId).set({
        options: options,
        created_at: admin.firestore.FieldValue.serverTimestamp(),
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true }); // Use merge to update existing documents
      
      console.log(`✅ ${docId} created/updated successfully`);
      console.log(`   Sample options: ${options.slice(0, 3).join(', ')}${options.length > 3 ? '...' : ''}\n`);
    }
    
    console.log('🎉 POST JOB dropdown options setup completed!');
    console.log('💡 All post job dropdowns should now work properly.');
    
    // Verify the setup
    console.log('\n🔍 Verifying post job dropdown setup...');
    const snapshot = await db.collection('dropdown_options').get();
    console.log(`📊 Total documents in dropdown_options: ${snapshot.docs.length}`);
    
    const postJobDocs = ['jobCategory', 'jobType', 'department', 'experienceLevel', 'industryType', 'salaryRange', 'workMode'];
    
    for (const docId of postJobDocs) {
      const doc = await db.collection('dropdown_options').doc(docId).get();
      if (doc.exists) {
        const data = doc.data();
        console.log(`   ✅ ${docId}: ${data.options ? data.options.length : 0} options`);
      } else {
        console.log(`   ❌ ${docId}: Document not found`);
      }
    }
    
  } catch (error) {
    console.error('❌ Error setting up post job dropdown options:', error);
  }
}

// Run the setup
setupPostJobDropdowns()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Script failed:', error);
    process.exit(1);
  });