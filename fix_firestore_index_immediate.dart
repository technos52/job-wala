// IMMEDIATE FIRESTORE INDEX FIX
// This file provides immediate solutions for the Firestore index error

/*
PROBLEM: 
The query requires a composite index for:
- Collection: applications (subcollection)
- Fields: jobId (ascending), appliedAt (ascending), __name__ (ascending)

IMMEDIATE SOLUTIONS:

1. CLICK THE FIREBASE CONSOLE LINK (FASTEST):
   Copy and paste this URL in your browser:
   https://console.firebase.google.com/v1/r/project/jobease-edevs/firestore/indexes?create_composite=CkpwcmVqZWN0cy9qb2JlYXNlLWVkZXZzL2RhdGFiYXNlcy8oZGVmYXVsdCkvY29sbGVjdGlvbkdyb3Vwcy9hcHBsaWNhdGlvbnMvaW5kZXhlcy9fEAEaCQoFam9iSWQQARoNCglhcHBsaWVkQXQQARoMCghfX25hbWVfXxAB

2. TEMPORARY QUERY WORKAROUND:
   Modify your query to avoid the compound index requirement temporarily.
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreIndexFix {
  // TEMPORARY WORKAROUND: Split the query into simpler parts
  static Stream<QuerySnapshot> getApplicationsWithoutCompoundIndex({
    required String candidateId,
    required String jobId,
  }) {
    return FirebaseFirestore.instance
        .collection('candidates')
        .doc(candidateId)
        .collection('applications')
        .where('jobId', isEqualTo: jobId)
        // Remove the appliedAt ordering temporarily
        .snapshots();
  }

  // ALTERNATIVE: Use a different query structure
  static Stream<QuerySnapshot> getApplicationsAlternative({
    required String candidateId,
    required String jobId,
  }) {
    return FirebaseFirestore.instance
        .collection('candidates')
        .doc(candidateId)
        .collection('applications')
        .where('jobId', isEqualTo: jobId)
        .limit(50) // Add limit to improve performance
        .snapshots();
  }

  // PROPER QUERY (use after index is created)
  static Stream<QuerySnapshot> getApplicationsWithIndex({
    required String candidateId,
    required String jobId,
    DateTime? afterDate,
  }) {
    Query query = FirebaseFirestore.instance
        .collection('candidates')
        .doc(candidateId)
        .collection('applications')
        .where('jobId', isEqualTo: jobId);

    if (afterDate != null) {
      query = query.where('appliedAt', isGreaterThan: afterDate);
    }

    return query.orderBy('appliedAt', descending: false).snapshots();
  }
}

/*
STEPS TO FIX PERMANENTLY:

1. Click the Firebase Console link above
2. Click "Create Index" in the Firebase Console
3. Wait 2-10 minutes for index to build
4. Replace temporary queries with proper indexed queries

The index has already been added to firestore.indexes.json and deployed,
but Firebase needs time to build it in the background.
*/
