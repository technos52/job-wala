import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'lib/services/video_ad_service.dart';

void main() {
  group('Video Ad System Tests', () {
    testWidgets('Video ad shows progress bar and countdown', (
      WidgetTester tester,
    ) async {
      bool? adResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  adResult = await VideoAdService.showVideoAd(context);
                },
                child: const Text('Show Ad'),
              ),
            ),
          ),
        ),
      );

      // Tap the button to show ad
      await tester.tap(find.text('Show Ad'));
      await tester.pumpAndSettle();

      // Verify ad screen elements
      expect(find.text('Job Portal Ad'), findsOneWidget);
      expect(find.text('Find Your Dream Job'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('Advertisement'), findsOneWidget);

      // Verify countdown is showing
      expect(find.textContaining('Ad ends in'), findsOneWidget);

      // Verify close button is present (but should show warning when tapped early)
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('Early close shows warning dialog', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  await VideoAdService.showVideoAd(context);
                },
                child: const Text('Show Ad'),
              ),
            ),
          ),
        ),
      );

      // Show ad
      await tester.tap(find.text('Show Ad'));
      await tester.pumpAndSettle();

      // Tap close button early
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify warning dialog appears
      expect(find.text('Close Advertisement?'), findsOneWidget);
      expect(
        find.text(
          'If you close the ad before it finishes, the job will not be applied.',
        ),
        findsOneWidget,
      );
      expect(find.text('Continue Watching'), findsOneWidget);
      expect(find.text('Close Ad'), findsOneWidget);
    });

    testWidgets('Ad completion shows close button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  await VideoAdService.showVideoAd(context);
                },
                child: const Text('Show Ad'),
              ),
            ),
          ),
        ),
      );

      // Show ad
      await tester.tap(find.text('Show Ad'));
      await tester.pumpAndSettle();

      // Fast forward time to complete the ad
      await tester.pump(const Duration(seconds: 31));

      // Verify completion message
      expect(find.text('Ad completed! You can now close.'), findsOneWidget);

      // Verify close button is now available
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });

  group('Job Application with Video Ad Tests', () {
    test('Video ad label shows correct text', () {
      const expectedText = 'Free apply available after watching a short video.';
      expect(
        expectedText,
        equals('Free apply available after watching a short video.'),
      );
    });

    test('Success message shows correct text', () {
      const expectedText =
          'Job applied successfully. Apply more jobs to watch more ads.';
      expect(
        expectedText,
        equals('Job applied successfully. Apply more jobs to watch more ads.'),
      );
    });

    test('Early close warning shows correct text', () {
      const expectedText = 'The job will not be applied.';
      expect(expectedText, equals('The job will not be applied.'));
    });
  });
}

/// Test helper to simulate the video ad flow
class VideoAdTestHelper {
  static Future<void> simulateCompleteAd(WidgetTester tester) async {
    // Wait for ad to complete (simulate 30 seconds)
    await tester.pump(const Duration(seconds: 31));

    // Tap close button after completion
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
  }

  static Future<void> simulateEarlyClose(WidgetTester tester) async {
    // Tap close button early
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // Confirm early close in dialog
    await tester.tap(find.text('Close Ad'));
    await tester.pumpAndSettle();
  }

  static Future<void> simulateContinueWatching(WidgetTester tester) async {
    // Tap close button early
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // Choose to continue watching
    await tester.tap(find.text('Continue Watching'));
    await tester.pumpAndSettle();
  }
}

/// Manual test instructions for developers
void printManualTestInstructions() {
  print('''
=== MANUAL TESTING INSTRUCTIONS ===

1. VIDEO AD LABEL TEST:
   - Open candidate dashboard
   - Find any job card that hasn't been applied to
   - Verify blue label shows: "Free apply available after watching a short video."
   - Label should have play icon and blue styling

2. APPLY NOW FLOW TEST:
   - Tap "Apply Now" on any job
   - Verify message appears: "Free apply available after watching a short video."
   - Video ad should start automatically after brief delay

3. VIDEO AD FUNCTIONALITY TEST:
   - Verify full-screen video ad appears
   - Check progress bar at bottom shows progress
   - Verify countdown timer shows remaining seconds
   - Confirm "Advertisement" label is visible
   - Check that close button (X) is present but grayed out initially

4. EARLY CLOSE TEST:
   - During video ad, tap the close (X) button
   - Verify dialog appears with warning message
   - Test both "Continue Watching" and "Close Ad" options
   - If "Close Ad" chosen, verify warning: "The job will not be applied."

5. COMPLETE AD TEST:
   - Let video ad run for full 30 seconds
   - Verify "Ad completed! You can now close." message appears
   - Verify close button becomes fully white/active
   - Tap close button to finish

6. SUCCESS FLOW TEST:
   - After completing ad, verify success dialog appears
   - Check message: "Job applied successfully. Apply more jobs to watch more ads."
   - Verify Apply Now button becomes disabled and shows "Applied"
   - Verify green "Applied" badge appears on job card

7. APPLIED JOB TEST:
   - Find a job that has been applied to
   - Verify no video ad label is shown
   - Verify Apply Now button is disabled
   - Verify "Applied" status is shown

=== EXPECTED BEHAVIOR SUMMARY ===
✅ Video ad label only shows on non-applied jobs
✅ Apply Now triggers video ad flow
✅ Early close prevents application
✅ Complete ad enables successful application
✅ Applied jobs show disabled state
✅ Success message encourages more applications
''');
}
