import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Testing client-side job sorting fix...\n');

  // Simulate the job loading and sorting process
  await testJobSorting();
}

Future<void> testJobSorting() async {
  try {
    // Fetch jobs without server-side ordering (like our current implementation)
    final jobsQuery = await FirebaseFirestore.instance
        .collection('jobs')
        .where('approvalStatus', isEqualTo: 'approved')
        .limit(10)
        .get();

    print('✅ Found ${jobsQuery.docs.length} approved jobs');

    if (jobsQuery.docs.isEmpty) {
      print('❌ No jobs found to test sorting');
      return;
    }

    // Convert to our job format
    final jobs = jobsQuery.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'jobTitle': data['jobTitle'] ?? 'Unknown Title',
        'companyName': data['companyName'] ?? 'Unknown Company',
        'postedDate': data['postedDate'],
      };
    }).toList();

    print('\n📅 Jobs BEFORE client-side sorting:');
    for (int i = 0; i < jobs.length; i++) {
      final job = jobs[i];
      final postedDate = job['postedDate'];
      String dateStr = 'No date';

      if (postedDate != null) {
        try {
          if (postedDate is Timestamp) {
            final date = postedDate.toDate();
            dateStr =
                '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
          } else {
            dateStr = postedDate.toString();
          }
        } catch (e) {
          dateStr = 'Invalid date: $postedDate';
        }
      }

      print('${i + 1}. ${job['jobTitle']} - Posted: $dateStr');
    }

    // Apply client-side sorting (same logic as in the app)
    print('\n🔄 Applying client-side sorting...');
    jobs.sort((a, b) {
      final aDate = a['postedDate'];
      final bDate = b['postedDate'];

      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;

      try {
        DateTime dateA = aDate is Timestamp
            ? aDate.toDate()
            : DateTime.parse(aDate.toString());
        DateTime dateB = bDate is Timestamp
            ? bDate.toDate()
            : DateTime.parse(bDate.toString());

        return dateB.compareTo(dateA); // Descending order (newest first)
      } catch (e) {
        print('❌ Error sorting dates: $e');
        return 0;
      }
    });

    print('\n📅 Jobs AFTER client-side sorting (should be latest first):');
    for (int i = 0; i < jobs.length; i++) {
      final job = jobs[i];
      final postedDate = job['postedDate'];
      String dateStr = 'No date';

      if (postedDate != null) {
        try {
          if (postedDate is Timestamp) {
            final date = postedDate.toDate();
            dateStr =
                '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
          } else {
            dateStr = postedDate.toString();
          }
        } catch (e) {
          dateStr = 'Invalid date: $postedDate';
        }
      }

      print('${i + 1}. ${job['jobTitle']} - Posted: $dateStr');
    }

    // Verify sorting is correct
    bool isProperlyOrdered = true;
    DateTime? previousDate;

    for (final job in jobs) {
      final postedDate = job['postedDate'];

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
      print('\n✅ SUCCESS: Jobs are properly sorted (latest first)');
      print('🎯 Client-side sorting is working correctly!');
    } else {
      print('\n❌ FAILED: Jobs are NOT properly sorted');
      print('🔧 Client-side sorting needs debugging');
    }
  } catch (e) {
    print('❌ Error testing job sorting: $e');
  }
}
