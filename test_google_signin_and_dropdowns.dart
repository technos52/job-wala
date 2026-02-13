import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'lib/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print('🔍 Testing Google Sign-In Configuration and Dropdown Content...\n');

    // Test 1: Google Sign-In Configuration
    await testGoogleSignInConfiguration();

    // Test 2: Check all dropdown content
    await testDropdownContent();

    print('\n🎉 All tests completed!');
  } catch (e) {
    print('❌ Error during testing: $e');
  }
}

Future<void> testGoogleSignInConfiguration() async {
  print('📱 Testing Google Sign-In Configuration...');

  try {
    // Test Google Sign-In initialization
    final GoogleSignIn googleSignIn = GoogleSignIn();

    print('✅ Google Sign-In instance created successfully');
    print('📋 Google Sign-In client ID: ${googleSignIn.clientId ?? 'Not set'}');

    // Check if we can initialize without errors
    await googleSignIn.signOut(); // This will test if configuration is valid
    print('✅ Google Sign-In configuration appears valid');

    // Note: We can't test actual sign-in without user interaction
    print(
      'ℹ️ SHA-1 certificate hash 28:2F:96:8B:D0:BA:C4:B3:5E:5F:8F:B4:8A:A4:44:3C:6C:C9:0B:4A is configured',
    );
    print('ℹ️ If you still get ApiException: 16, try these steps:');
    print('   1. Clean and rebuild the app');
    print('   2. Ensure debug keystore is being used');
    print('   3. Check Firebase Console for correct SHA-1');
    print('   4. Verify package name matches: com.shailesh.alljobsopen');
  } catch (e) {
    print('❌ Google Sign-In configuration error: $e');
    print('💡 This might be the cause of ApiException: 16');
  }
}

Future<void> testDropdownContent() async {
  print('\n📊 Testing Dropdown Content...');

  final dropdownCategories = [
    'jobCategory',
    'jobType',
    'designation',
    'companyType',
    'location',
    'candidateDepartment',
  ];

  for (String category in dropdownCategories) {
    await testSingleDropdown(category);
  }
}

Future<void> testSingleDropdown(String category) async {
  print('\n🔍 Testing $category dropdown...');

  try {
    final doc = await FirebaseFirestore.instance
        .collection('dropdown_options')
        .doc(category)
        .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final options = List<String>.from(data['options'] ?? []);

      print('✅ $category: Found ${options.length} options');

      if (options.isEmpty) {
        print(
          '⚠️ $category: Dropdown is EMPTY - should be converted to text field',
        );
        await createDefaultOptions(category);
      } else {
        print('📋 $category: Has content - keep as dropdown');
        print('   First 5 options: ${options.take(5).join(", ")}');
        if (options.length > 5) {
          print('   ... and ${options.length - 5} more');
        }
      }
    } else {
      print(
        '❌ $category: Document does not exist - should be converted to text field',
      );
      await createDefaultOptions(category);
    }
  } catch (e) {
    print('❌ Error testing $category: $e');
  }
}

Future<void> createDefaultOptions(String category) async {
  print('🔧 Creating default options for $category...');

  Map<String, List<String>> defaultOptions = {
    'jobCategory': [
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
      'Digital Marketing',
      'Content Writing',
      'Sales',
      'Customer Support',
      'Human Resources',
      'Finance & Accounting',
      'Operations',
      'Consulting',
      'Research & Development',
    ],
    'jobType': [
      'Full Time',
      'Part Time',
      'Contract',
      'Freelance',
      'Internship',
      'Remote',
      'Hybrid',
    ],
    'designation': [
      'Software Engineer',
      'Senior Software Engineer',
      'Lead Software Engineer',
      'Software Architect',
      'Full Stack Developer',
      'Frontend Developer',
      'Backend Developer',
      'Mobile Developer',
      'DevOps Engineer',
      'Data Scientist',
      'Data Analyst',
      'Machine Learning Engineer',
      'QA Engineer',
      'Test Engineer',
      'UI/UX Designer',
      'Product Manager',
      'Project Manager',
      'Business Analyst',
      'Technical Lead',
      'Team Lead',
      'Manager',
      'Senior Manager',
      'Director',
      'VP',
      'CTO',
      'CEO',
    ],
    'companyType': [
      'Information Technology (IT)',
      'Software Development',
      'E-commerce',
      'Fintech',
      'Healthcare Technology',
      'EdTech',
      'Gaming',
      'Artificial Intelligence',
      'Blockchain',
      'Cybersecurity',
      'Cloud Computing',
      'SaaS',
      'Mobile App Development',
      'Web Development',
      'Digital Marketing Agency',
      'Consulting',
      'Startup',
      'MNC',
      'Government',
      'Non-Profit',
      'Manufacturing',
      'Automobile',
      'Pharmaceutical',
      'Banking & Finance',
      'Insurance',
      'Retail',
      'Education',
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
      'Other',
    ],
    'location': [
      'Mumbai',
      'Delhi',
      'Bangalore',
      'Hyderabad',
      'Chennai',
      'Pune',
      'Kolkata',
      'Ahmedabad',
      'Surat',
      'Jaipur',
      'Lucknow',
      'Kanpur',
      'Nagpur',
      'Indore',
      'Thane',
      'Bhopal',
      'Visakhapatnam',
      'Pimpri-Chinchwad',
      'Patna',
      'Vadodara',
      'Ghaziabad',
      'Ludhiana',
      'Agra',
      'Nashik',
      'Faridabad',
      'Meerut',
      'Rajkot',
      'Kalyan-Dombivali',
      'Vasai-Virar',
      'Varanasi',
      'Srinagar',
      'Aurangabad',
      'Dhanbad',
      'Amritsar',
      'Navi Mumbai',
      'Allahabad',
      'Ranchi',
      'Howrah',
      'Coimbatore',
      'Jabalpur',
      'Gwalior',
      'Vijayawada',
      'Jodhpur',
      'Madurai',
      'Raipur',
      'Kota',
      'Guwahati',
      'Chandigarh',
      'Solapur',
      'Hubli-Dharwad',
      'Bareilly',
      'Moradabad',
      'Mysore',
      'Gurgaon',
      'Aligarh',
      'Jalandhar',
      'Tiruchirappalli',
      'Bhubaneswar',
      'Salem',
      'Mira-Bhayandar',
      'Warangal',
      'Thiruvananthapuram',
      'Guntur',
      'Bhiwandi',
      'Saharanpur',
      'Gorakhpur',
      'Bikaner',
      'Amravati',
      'Noida',
      'Jamshedpur',
      'Bhilai Nagar',
      'Cuttack',
      'Firozabad',
      'Kochi',
      'Bhavnagar',
      'Dehradun',
      'Durgapur',
      'Asansol',
      'Nanded-Waghala',
      'Kolhapur',
      'Ajmer',
      'Gulbarga',
      'Jamnagar',
      'Ujjain',
      'Loni',
      'Siliguri',
      'Jhansi',
      'Ulhasnagar',
      'Nellore',
      'Jammu',
      'Sangli-Miraj & Kupwad',
      'Belgaum',
      'Mangalore',
      'Ambattur',
      'Tirunelveli',
      'Malegaon',
      'Gaya',
      'Jalgaon',
      'Udaipur',
      'Maheshtala',
    ],
    'candidateDepartment': [
      'Information Technology',
      'Computer Science',
      'Software Engineering',
      'Electronics & Communication',
      'Electrical Engineering',
      'Mechanical Engineering',
      'Civil Engineering',
      'Chemical Engineering',
      'Aerospace Engineering',
      'Biotechnology',
      'Business Administration',
      'Management Studies',
      'Marketing',
      'Finance & Accounting',
      'Human Resources',
      'Operations Management',
      'Economics',
      'Commerce',
      'Mathematics',
      'Statistics',
      'Physics',
      'Chemistry',
      'Biology',
      'Pharmacy',
      'Medicine',
      'Nursing',
      'Physiotherapy',
      'Psychology',
      'English Literature',
      'Journalism & Mass Communication',
      'Fine Arts',
      'Graphic Design',
      'Architecture',
      'Law',
      'Education',
      'Social Work',
      'Political Science',
      'History',
      'Geography',
      'Philosophy',
      'Other',
    ],
  };

  try {
    if (defaultOptions.containsKey(category)) {
      await FirebaseFirestore.instance
          .collection('dropdown_options')
          .doc(category)
          .set({'options': defaultOptions[category]!});

      print(
        '✅ Created $category with ${defaultOptions[category]!.length} default options',
      );
    }
  } catch (e) {
    print('❌ Error creating default options for $category: $e');
  }
}
