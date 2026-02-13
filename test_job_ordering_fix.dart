import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Testing job ordering with latest jobs first...\n');

  try {
    // Test the new query with server-side ordering
    final jobsQuery = await FirebaseFirestore.instance
        .collection('jobs')
        .where('approvalStatus', isEqualTo: 'approved')
        .orderBy('postedDate', descending: true) // Latest jobs first
        .limit(10) // Get top 10 latest jobs
        .get();

    print('✅ Found ${jobsQuery.docs.length} approved jobs');

    if (jobsQuery.docs.isNotEmpty) {
      print('\n📅 Job posting dates (should be in descending order):');

      for (int i = 0; i < jobsQuery.docs.length; i++) {
        final doc = jobsQuery.docs[i];
        final data = doc.data();
        final jobTitle = data['jobTitle'] ?? 'Unknown Title';
        final companyName = data['companyName'] ?? 'Unknown Company';
        final postedDate = data['postedDate'];

        String dateStr = 'No date';
        if (postedDate != null) {
          if (postedDate is Timestamp) {
            final date = postedDate.toDate();
            dateStr =
                '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
          } else {
            dateStr = postedDate.toString();
          }
        }

        print('${i + 1}. $jobTitle at $companyName - Posted: $dateStr');
      }

      // Verify ordering
      bool isProperlyOrdered = true;
      DateTime? previousDate;

      for (final doc in jobsQuery.docs) {
        final data = doc.data();
        final postedDate = data['postedDate'];

        if (postedDate is Timestamp) {
          final currentDate = postedDate.toDate();

          if (previousDate != null && currentDate.isAfter(previousDate)) {
            isProperlyOrdered = false;
            break;
          }

          previousDate = currentDate;
        }
      }

      if (isProperlyOrdered) {
        print('\n✅ Jobs are properly ordered (latest first)');
      } else {
        print('\n❌ Jobs are NOT properly ordered');
      }
    } else {
      print('❌ No approved jobs found');
    }
  } catch (e) {
    print('❌ Error testing job ordering: $e');

    if (e.toString().contains('index')) {
      print(
        '\n💡 Firestore index might be needed. Check firestore.indexes.json',
      );
      print(
        '   Required index: jobs collection with approvalStatus (ASC) + postedDate (DESC)',
      );
    }
  }
}
