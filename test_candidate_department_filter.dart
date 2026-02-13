import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Testing Candidate Department Filter...');

  try {
    // Test 1: Check if candidateDepartment dropdown options exist in Firebase
    print('\n📋 Checking Firebase dropdown options for candidateDepartment...');

    final candidateDeptDoc = await FirebaseFirestore.instance
        .collection('dropdown_options')
        .doc('candidateDepartment')
        .get();

    if (candidateDeptDoc.exists) {
      final data = candidateDeptDoc.data();
      print('✅ candidateDepartment document exists: $data');

      if (data != null) {
        for (var key in data.keys) {
          final value = data[key];
          if (value is List) {
            print('📊 Found list in field "$key" with ${value.length} items:');
            for (var item in value) {
              print('  - $item');
            }
          }
        }
      }
    } else {
      print('❌ candidateDepartment document does not exist');

      // Create the document with expected values
      print('🔧 Creating candidateDepartment dropdown options...');

      final candidateDepartments = [
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

      await FirebaseFirestore.instance
          .collection('dropdown_options')
          .doc('candidateDepartment')
          .set({'options': candidateDepartments});

      print(
        '✅ Created candidateDepartment dropdown with ${candidateDepartments.length} options',
      );
    }

    // Test 2: Check jobs collection for candidateDepartment field usage
    print('\n📊 Checking jobs collection for candidateDepartment field...');

    final jobsQuery = await FirebaseFirestore.instance
        .collection('jobs')
        .where('approvalStatus', isEqualTo: 'approved')
        .limit(5)
        .get();

    print('Found ${jobsQuery.docs.length} approved jobs to check');

    final candidateDeptValues = <String>{};

    for (var doc in jobsQuery.docs) {
      final data = doc.data();
      final candidateDept = data['candidateDepartment']?.toString();
      if (candidateDept != null &&
          candidateDept.isNotEmpty &&
          candidateDept != 'null') {
        candidateDeptValues.add(candidateDept);
        print(
          '📋 Job "${data['jobTitle']}" has candidateDepartment: "$candidateDept"',
        );
      }
    }

    if (candidateDeptValues.isEmpty) {
      print('⚠️ No jobs found with candidateDepartment field populated');
    } else {
      print(
        '✅ Found ${candidateDeptValues.length} unique candidate departments in jobs:',
      );
      for (var dept in candidateDeptValues) {
        print('  - $dept');
      }
    }

    print('\n🎉 Candidate Department Filter test completed!');
  } catch (e) {
    print('❌ Error testing candidate department filter: $e');
  }
}
