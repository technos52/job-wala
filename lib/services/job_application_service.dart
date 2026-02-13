import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';

class JobApplicationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Apply for a job and store it in /candidates/{userId}/applications/{applicationId}
  static Future<String?> applyForJob({
    required String jobId,
    required String jobTitle,
    required String companyName,
    required String employerId,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ User not authenticated');
        throw Exception('User not authenticated');
      }

      print('🚀 Starting job application process...');
      print('👤 User email: ${user.email}');
      print('🎯 Job ID: $jobId');

      // Get the actual document ID for this user's email
      final userId = await FirebaseService.getUserDocumentIdByEmail(
        user.email!,
      );

      if (userId == null) {
        print('❌ User document not found for email: ${user.email}');
        print('💡 This usually means the candidate profile is incomplete');
        throw Exception(
          'User profile not found. Please complete your profile first.',
        );
      }

      print('✅ Found user document ID: $userId');
      print('📍 Target: candidates/$userId/applications/');

      // Check if the user document exists first
      print('🔍 Verifying user document exists...');
      final userDocRef = _firestore.collection('candidates').doc(userId);
      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        print('❌ User document does not exist at candidates/$userId');
        print('🚫 Cannot create subcollection without existing user document');
        throw Exception(
          'User profile not found. Please complete your profile first.',
        );
      }

      print('✅ User document exists at candidates/$userId');
      print('📊 User document data keys: ${userDoc.data()?.keys.toList()}');

      final applicationData = {
        'jobId': jobId,
        'jobTitle': jobTitle,
        'companyName': companyName,
        'employerId': employerId,
        'candidateId': userId, // Use consistent userId
        'candidateEmail': user.email,
        'appliedAt': FieldValue.serverTimestamp(),
        'status': 'pending', // pending, reviewed, accepted, rejected
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        ...?additionalData,
      };

      print('📝 Creating application document...');
      // Store in candidate's applications subcollection using existing user document
      final docRef = await userDocRef
          .collection('applications')
          .add(applicationData);

      print('✅ Application stored successfully!');
      print('📍 Full path: candidates/$userId/applications/${docRef.id}');
      print('🔑 Application ID: ${docRef.id}');

      // Update candidate analytics data
      await _updateCandidateAnalytics(
        userId: userId,
        applicationId: docRef.id,
        jobData: {
          'jobId': jobId,
          'jobTitle': jobTitle,
          'companyName': companyName,
          'employerId': employerId,
          ...?additionalData,
        },
      );

      return docRef.id;
    } catch (e) {
      print('❌ Error applying for job: $e');
      print('🔍 Error type: ${e.runtimeType}');
      return null;
    }
  }

  /// Get all applications for the current user
  static Stream<QuerySnapshot> getUserApplications() async* {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Get the actual document ID for this user's email
    final userId = await FirebaseService.getUserDocumentIdByEmail(user.email!);
    if (userId == null) {
      throw Exception('User profile not found');
    }

    yield* _firestore
        .collection('candidates')
        .doc(userId)
        .collection('applications')
        .orderBy('appliedAt', descending: true)
        .snapshots();
  }

  /// Check if user has already applied for a specific job
  static Future<bool> hasAppliedForJob(String jobId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Get the actual document ID for this user's email
      final userId = await FirebaseService.getUserDocumentIdByEmail(
        user.email!,
      );
      if (userId == null) return false;

      final querySnapshot = await _firestore
          .collection('candidates')
          .doc(userId)
          .collection('applications')
          .where('jobId', isEqualTo: jobId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking application status: $e');
      return false;
    }
  }

  /// Update application status
  static Future<bool> updateApplicationStatus({
    required String applicationId,
    required String status,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Get the actual document ID for this user's email
      final userId = await FirebaseService.getUserDocumentIdByEmail(
        user.email!,
      );
      if (userId == null) return false;

      await _firestore
          .collection('candidates')
          .doc(userId)
          .collection('applications')
          .doc(applicationId)
          .update({
            'status': status,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      return true;
    } catch (e) {
      print('Error updating application status: $e');
      return false;
    }
  }

  /// Get application by ID
  static Future<DocumentSnapshot?> getApplication(String applicationId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Get the actual document ID for this user's email
      final userId = await FirebaseService.getUserDocumentIdByEmail(
        user.email!,
      );
      if (userId == null) return null;

      return await _firestore
          .collection('candidates')
          .doc(userId)
          .collection('applications')
          .doc(applicationId)
          .get();
    } catch (e) {
      print('Error getting application: $e');
      return null;
    }
  }

  /// Delete an application
  static Future<bool> deleteApplication(String applicationId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Get the actual document ID for this user's email
      final userId = await FirebaseService.getUserDocumentIdByEmail(
        user.email!,
      );
      if (userId == null) return false;

      await _firestore
          .collection('candidates')
          .doc(userId)
          .collection('applications')
          .doc(applicationId)
          .delete();

      return true;
    } catch (e) {
      print('Error deleting application: $e');
      return false;
    }
  }

  /// Update candidate analytics data when a new application is created
  static Future<void> _updateCandidateAnalytics({
    required String userId,
    required String applicationId,
    required Map<String, dynamic> jobData,
  }) async {
    try {
      final candidateDocRef = _firestore.collection('candidates').doc(userId);

      await _firestore.runTransaction((transaction) async {
        final candidateDoc = await transaction.get(candidateDocRef);

        if (!candidateDoc.exists) {
          // If candidate document doesn't exist, create it with analytics data
          transaction.set(candidateDocRef, {
            'totalApplications': 1,
            'recentApplications': [
              {
                'applicationId': applicationId,
                'jobTitle': jobData['jobTitle'],
                'companyName': jobData['companyName'],
                'location': jobData['location'] ?? 'Location not specified',
                'jobCategory': jobData['jobCategory'] ?? jobData['department'],
                'jobType': jobData['jobType'],
                'salaryRange': jobData['salary'] ?? jobData['salaryRange'],
                'appliedAt': DateTime.now(),
                'status': 'pending',
              },
            ],
            'jobCategoryPreferences': {
              (jobData['jobCategory'] ?? jobData['department'] ?? 'Other'): 1,
            },
            'locationPreferences': {(jobData['location'] ?? 'Other'): 1},
            'monthlyApplications': {_getMonthKey(DateTime.now()): 1},
            'applicationSuccessMetrics': {
              'totalApplications': 1,
              'pendingApplications': 1,
              'acceptedApplications': 0,
              'rejectedApplications': 0,
            },
            'analyticsLastUpdated': FieldValue.serverTimestamp(),
          });
        } else {
          // Update existing candidate document
          final currentData = candidateDoc.data() as Map<String, dynamic>;

          // Update total applications
          final totalApplications = (currentData['totalApplications'] ?? 0) + 1;

          // Update recent applications list
          final recentApplications = List<Map<String, dynamic>>.from(
            currentData['recentApplications'] ?? [],
          );
          recentApplications.insert(0, {
            'applicationId': applicationId,
            'jobTitle': jobData['jobTitle'],
            'companyName': jobData['companyName'],
            'location': jobData['location'] ?? 'Location not specified',
            'jobCategory': jobData['jobCategory'] ?? jobData['department'],
            'jobType': jobData['jobType'],
            'salaryRange': jobData['salary'] ?? jobData['salaryRange'],
            'appliedAt': DateTime.now(),
            'status': 'pending',
          });

          // Keep only last 10 applications
          if (recentApplications.length > 10) {
            recentApplications.removeRange(10, recentApplications.length);
          }

          // Update job category preferences
          final jobCategoryPreferences = Map<String, dynamic>.from(
            currentData['jobCategoryPreferences'] ?? {},
          );
          final jobCategory =
              jobData['jobCategory'] ?? jobData['department'] ?? 'Other';
          jobCategoryPreferences[jobCategory] =
              (jobCategoryPreferences[jobCategory] ?? 0) + 1;

          // Update location preferences
          final locationPreferences = Map<String, dynamic>.from(
            currentData['locationPreferences'] ?? {},
          );
          final location = jobData['location'] ?? 'Other';
          locationPreferences[location] =
              (locationPreferences[location] ?? 0) + 1;

          // Update monthly applications
          final monthlyApplications = Map<String, dynamic>.from(
            currentData['monthlyApplications'] ?? {},
          );
          final monthKey = _getMonthKey(DateTime.now());
          monthlyApplications[monthKey] =
              (monthlyApplications[monthKey] ?? 0) + 1;

          // Update success metrics
          final applicationSuccessMetrics = Map<String, dynamic>.from(
            currentData['applicationSuccessMetrics'] ?? {},
          );
          applicationSuccessMetrics['totalApplications'] = totalApplications;
          applicationSuccessMetrics['pendingApplications'] =
              (applicationSuccessMetrics['pendingApplications'] ?? 0) + 1;

          transaction.update(candidateDocRef, {
            'totalApplications': totalApplications,
            'recentApplications': recentApplications,
            'jobCategoryPreferences': jobCategoryPreferences,
            'locationPreferences': locationPreferences,
            'monthlyApplications': monthlyApplications,
            'applicationSuccessMetrics': applicationSuccessMetrics,
            'analyticsLastUpdated': FieldValue.serverTimestamp(),
          });
        }
      });

      print('✅ Candidate analytics updated successfully');
    } catch (e) {
      print('❌ Error updating candidate analytics: $e');
      // Don't throw error as the main application was successful
    }
  }

  /// Helper method to generate month key for analytics
  static String _getMonthKey(DateTime date) {
    return '${date.year}_${date.month.toString().padLeft(2, '0')}';
  }
}
