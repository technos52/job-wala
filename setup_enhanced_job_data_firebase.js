// Script to set up enhanced job data structure in Firebase
// This ensures all job fields are properly configured for comprehensive display

const admin = require('firebase-admin');

// Initialize Firebase Admin
try {
  admin.initializeApp();
} catch (error) {
  console.log('Firebase initialization:', error.message);
}

const db = admin.firestore();

async function setupEnhancedJobDataStructure() {
  console.log('🔧 Setting up enhanced job data structure in Firebase...');
  
  // Updated job categories (replacing departments)
  const jobCategories = [
    'Information Technology',
    'Marketing & Sales',
    'Finance & Accounting',
    'Human Resources',
    'Operations Management',
    'Customer Service',
    'Engineering',
    'Design & Creative',
    'Content & Writing',
    'Legal & Compliance',
    'Administration',
    'Healthcare',
    'Education & Training',
    'Research & Development',
    'Quality Assurance',
  ];

  // Job types for better categorization
  const jobTypes = [
    'Full Time',
    'Part Time',
    'Contract',
    'Internship',
    'Freelance',
    'Remote',
    'Hybrid',
    'Temporary',
    'Consultant',
  ];

  // Industry types for better job classification
  const industryTypes = [
    'Software Development',
    'Digital Marketing',
    'Financial Services',
    'Healthcare',
    'Education',
    'E-commerce',
    'Manufacturing',
    'Consulting',
    'Media & Entertainment',
    'Real Estate',
    'Automotive',
    'Telecommunications',
    'Banking',
    'Insurance',
    'Retail',
    'Hospitality',
    'Government',
    'Non-Profit',
  ];

  // Qualifications for better matching
  const qualifications = [
    '10th Pass',
    '12th Pass',
    'Diploma',
    'Bachelor\'s Degree',
    'B.Tech/B.E.',
    'BCA',
    'BBA',
    'B.Com',
    'BA',
    'Master\'s Degree',
    'M.Tech/M.E.',
    'MCA',
    'MBA',
    'M.Com',
    'MA',
    'PhD',
    'Professional Certification',
    'Any Graduate',
  ];

  try {
    // Set up job categories (updated from departments)
    await db.collection('dropdown_options').doc('jobCategory').set({
      options: jobCategories
    });
    console.log('✅ Job categories setup completed');

    // Set up job types
    await db.collection('dropdown_options').doc('jobType').set({
      options: jobTypes
    });
    console.log('✅ Job types setup completed');

    // Set up industry types
    await db.collection('dropdown_options').doc('industryType').set({
      options: industryTypes
    });
    console.log('✅ Industry types setup completed');

    // Set up qualifications
    await db.collection('dropdown_options').doc('qualification').set({
      options: qualifications
    });
    console.log('✅ Qualifications setup completed');

    // Create a sample comprehensive job document
    const sampleJob = {
      jobTitle: 'Senior Flutter Developer',
      companyName: 'TechCorp Solutions Pvt Ltd',
      location: 'Bangalore, Karnataka',
      salaryRange: '₹8-15 LPA',
      jobType: 'Full Time',
      jobCategory: 'Information Technology', // Updated from department
      designation: 'Senior Software Engineer',
      experienceRequired: '3-5 years',
      qualification: 'B.Tech/M.Tech in Computer Science',
      industryType: 'Software Development',
      jobDescription: 'We are looking for an experienced Flutter developer to join our mobile development team. You will be responsible for developing cross-platform mobile applications using Flutter framework. The ideal candidate should have strong knowledge of Dart programming language, state management, and mobile app architecture. Key responsibilities include: 1) Developing high-quality mobile applications, 2) Collaborating with cross-functional teams, 3) Writing clean and maintainable code, 4) Participating in code reviews, 5) Staying updated with latest Flutter developments.',
      postedDate: admin.firestore.FieldValue.serverTimestamp(),
      applications: 0,
      approvalStatus: 'approved',
      employerId: 'sample_employer_001',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    // Add sample job to demonstrate the structure
    await db.collection('jobs').add(sampleJob);
    console.log('✅ Sample comprehensive job created');

    console.log('\n🎉 Enhanced job data structure setup completed!');
    console.log('\n📋 Updated Firebase Structure:');
    console.log('==================================');
    console.log('✅ Job Categories (replacing departments):');
    jobCategories.forEach((category, index) => {
      console.log(`   ${index + 1}. ${category}`);
    });
    
    console.log('\n✅ Job Types:');
    jobTypes.forEach((type, index) => {
      console.log(`   ${index + 1}. ${type}`);
    });

    console.log('\n✅ Industry Types:');
    industryTypes.slice(0, 10).forEach((industry, index) => {
      console.log(`   ${index + 1}. ${industry}`);
    });
    console.log(`   ... and ${industryTypes.length - 10} more`);

    console.log('\n📱 Job Document Structure:');
    console.log('==========================');
    console.log('• jobTitle: Job position title');
    console.log('• companyName: Employer company name');
    console.log('• location: Job location');
    console.log('• salaryRange: Salary information');
    console.log('• jobType: Employment type (Full Time, Part Time, etc.)');
    console.log('• jobCategory: Job category (updated from department)');
    console.log('• designation: Specific role/designation');
    console.log('• experienceRequired: Required experience');
    console.log('• qualification: Educational requirements');
    console.log('• industryType: Industry classification');
    console.log('• jobDescription: Detailed job description');
    console.log('• postedDate: When job was posted');
    console.log('• applications: Number of applications received');

    console.log('\n💡 Benefits of Enhanced Structure:');
    console.log('==================================');
    console.log('✅ Better job categorization with jobCategory field');
    console.log('✅ Comprehensive job information display');
    console.log('✅ Enhanced search and filtering capabilities');
    console.log('✅ Industry-specific job classification');
    console.log('✅ Detailed qualification matching');
    console.log('✅ Improved candidate-job matching');
    console.log('✅ Better user experience with complete information');

  } catch (error) {
    console.error('❌ Error setting up enhanced job data structure:', error);
  }
}

// Run the setup
setupEnhancedJobDataStructure()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Script failed:', error);
    process.exit(1);
  });

// Manual Firebase Console Setup Instructions:
console.log('\n📝 Manual Setup Instructions (if script fails):');
console.log('===============================================');
console.log('1. Go to Firebase Console > Firestore Database');
console.log('2. Create collection: dropdown_options');
console.log('3. Create documents with these IDs and structures:');
console.log('');
console.log('Document ID: jobCategory');
console.log('Field: options (array)');
console.log('Values: ["Information Technology", "Marketing & Sales", ...]');
console.log('');
console.log('Document ID: jobType');
console.log('Field: options (array)');
console.log('Values: ["Full Time", "Part Time", "Remote", ...]');
console.log('');
console.log('Document ID: industryType');
console.log('Field: options (array)');
console.log('Values: ["Software Development", "Digital Marketing", ...]');
console.log('');
console.log('4. Update existing job documents to include:');
console.log('   - jobCategory (instead of department)');
console.log('   - jobType');
console.log('   - industryType');
console.log('   - qualification');
console.log('   - experienceRequired');
console.log('   - detailed jobDescription');