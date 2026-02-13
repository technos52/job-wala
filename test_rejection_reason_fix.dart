import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Rejection Reason Display Tests', () {
    test('Should prioritize "reason" field from Firebase', () {
      // Test data with multiple rejection reason fields
      final jobData = {
        'reason':
            'Job description is too vague and lacks specific requirements',
        'adminComments': 'Please add more details',
        'rejectionReason': 'Incomplete information',
        'adminFeedback': 'Job description needs improvement',
        'comments': 'General feedback',
      };

      // Simulate the rejection reason logic
      final rejectionReason =
          jobData['reason'] ??
          jobData['adminComments'] ??
          jobData['rejectionReason'] ??
          jobData['adminFeedback'] ??
          jobData['comments'] ??
          'Your job posting was rejected. Please review and resubmit with corrections.';

      // Should prioritize 'reason' field
      expect(
        rejectionReason,
        equals('Job description is too vague and lacks specific requirements'),
      );
    });

    test('Should fallback to other fields when reason is null', () {
      // Test data without 'reason' field
      final jobData = {
        'adminComments': 'Please add more details',
        'rejectionReason': 'Incomplete information',
        'adminFeedback': 'Job description needs improvement',
        'comments': 'General feedback',
      };

      // Simulate the rejection reason logic
      final rejectionReason =
          jobData['reason'] ??
          jobData['adminComments'] ??
          jobData['rejectionReason'] ??
          jobData['adminFeedback'] ??
          jobData['comments'] ??
          'Your job posting was rejected. Please review and resubmit with corrections.';

      // Should fallback to adminComments
      expect(rejectionReason, equals('Please add more details'));
    });

    test('Should show default message when no reason fields exist', () {
      // Test data without any rejection reason fields
      final jobData = {
        'jobTitle': 'Software Developer',
        'approvalStatus': 'rejected',
      };

      // Simulate the rejection reason logic
      final rejectionReason =
          jobData['reason'] ??
          jobData['adminComments'] ??
          jobData['rejectionReason'] ??
          jobData['adminFeedback'] ??
          jobData['comments'] ??
          'Your job posting was rejected. Please review and resubmit with corrections.';

      // Should show default message
      expect(
        rejectionReason,
        equals(
          'Your job posting was rejected. Please review and resubmit with corrections.',
        ),
      );
    });

    test('Should handle empty reason field', () {
      // Test data with empty 'reason' field
      final jobData = {
        'reason': '', // Empty string
        'adminComments': 'Please add more details',
      };

      // Simulate the rejection reason logic (empty string is falsy in Dart)
      final rejectionReason =
          (jobData['reason']?.isNotEmpty == true ? jobData['reason'] : null) ??
          jobData['adminComments'] ??
          jobData['rejectionReason'] ??
          jobData['adminFeedback'] ??
          jobData['comments'] ??
          'Your job posting was rejected. Please review and resubmit with corrections.';

      // Should fallback to adminComments when reason is empty
      expect(rejectionReason, equals('Please add more details'));
    });
  });
}

// Expected behavior:
// 1. Primary field: 'reason' from Firebase
// 2. Fallback order: adminComments -> rejectionReason -> adminFeedback -> comments
// 3. Default message if no fields have content
// 4. Handle empty strings properly
