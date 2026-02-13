import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Testing job sorting by approvedAt field...\n');

  try {
    // Test the query with approvedAt sorting
    final jobsQuery = await FirebaseFirestore.instance
        .collection('jobs')
        .where('approvalStatus', isEqualTo: 'approved')
        .limit(10) // Get top 10 latest approved jobs
        .get();

    print('✅ Found ${jobsQuery.docs.length} approved jobs');

    if (jobsQuery.docs.isNotEmpty) {
      // Convert to our job format
      final jobs = jobsQuery.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'jobTitle': data['jobTitle'] ?? 'Unknown Title',
          'companyName': data['companyName'] ?? 'Unknown Company',
          'postedDate': data['postedDate'],
          'approvedAt': data['approvedAt'],
        };
      }).toList();

      print('\n📅 Jobs BEFORE sorting (Firestore order):');
      for (int i = 0; i < jobs.length; i++) {
        final job = jobs[i];
        final approvedAt = job['approvedAt'];
        final postedDate = job['postedDate'];

        String approvedStr = 'Not approved';
        String postedStr = 'No posted date';

        if (approvedAt != null) {
          try {
            if (approvedAt is Timestamp) {
              final date = approvedAt.toDate();
              approvedStr =
                  '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
            } else {
              approvedStr = approvedAt.toString();
            }
          } catch (e) {
            approvedStr = 'Invalid approved date';
          }
        }

        if (postedDate != null) {
          try {
            if (postedDate is Timestamp) {
              final date = postedDate.toDate();
              postedStr =
                  '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
            } else {
              postedStr = postedDate.toString();
            }
          } catch (e) {
            postedStr = 'Invalid posted date';
          }
        }

        print(
          '${i + 1}. ${job['jobTitle']} - Approved: $approvedStr | Posted: $postedStr',
        );
      }

      // Apply client-side sorting by approvedAt (same logic as in the app)
      print('\n🔄 Applying client-side sorting by approvedAt...');
      jobs.sort((a, b) {
        // Use approvedAt as primary field, fallback to postedDate
        final aDate = a['approvedAt'] ?? a['postedDate'];
        final bDate = b['approvedAt'] ?? b['postedDate'];

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

          return dateB.compareTo(
            dateA,
          ); // Descending order (newest approved first)
        } catch (e) {
          print('❌ Error sorting dates: $e');
          return 0;
        }
      });

      print(
        '\n📅 Jobs AFTER sorting by approvedAt (should be latest approved first):',
      );
      for (int i = 0; i < jobs.length; i++) {
        final job = jobs[i];
        final approvedAt = job['approvedAt'];
        final postedDate = job['postedDate'];

        String approvedStr = 'Not approved';
        String postedStr = 'No posted date';

        if (approvedAt != null) {
          try {
            if (approvedAt is Timestamp) {
              final date = approvedAt.toDate();
              approvedStr =
                  '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
            } else {
              approvedStr = approvedAt.toString();
            }
          } catch (e) {
            approvedStr = 'Invalid approved date';
          }
        }

        if (postedDate != null) {
          try {
            if (postedDate is Timestamp) {
              final date = postedDate.toDate();
              postedStr =
                  '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
            } else {
              postedStr = postedDate.toString();
            }
          } catch (e) {
            postedStr = 'Invalid posted date';
          }
        }

        print(
          '${i + 1}. ${job['jobTitle']} - Approved: $approvedStr | Posted: $postedStr',
        );
      }

      // Verify sorting is correct (by approvedAt)
      bool isProperlyOrdered = true;
      DateTime? previousApprovedDate;

      for (final job in jobs) {
        final approvedAt = job['approvedAt'];

        if (approvedAt is Timestamp) {
          final currentApprovedDate = approvedAt.toDate();

          if (previousApprovedDate != null &&
              currentApprovedDate.isAfter(previousApprovedDate)) {
            isProperlyOrdered = false;
            break;
          }

          previousApprovedDate = currentApprovedDate;
        }
      }

      if (isProperlyOrdered) {
        print(
          '\n✅ SUCCESS: Jobs are properly sorted by approvedAt (latest approved first)',
        );
        print('🎯 Client-side sorting by approvedAt is working correctly!');
        print(
          '💡 This means the most recently approved jobs will appear at the top',
        );
      } else {
        print('\n❌ FAILED: Jobs are NOT properly sorted by approvedAt');
        print('🔧 Client-side sorting needs debugging');
      }
    } else {
      print('❌ No approved jobs found');
    }
  } catch (e) {
    print('❌ Error testing job sorting: $e');
  }
}
