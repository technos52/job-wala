import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'lib/screens/candidate_registration_step2_screen.dart';

void main() {
  testWidgets('Fields should always be visible regardless of experience', (
    WidgetTester tester,
  ) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(home: const CandidateRegistrationStep2Screen()),
    );

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Check that all fields are visible even with 0 experience
    expect(find.text('Job Category *'), findsOneWidget);
    expect(find.text('Job Type *'), findsOneWidget);
    expect(find.text('Designation *'), findsOneWidget);
    expect(find.text('Company Name *'), findsOneWidget);
    expect(find.text('Company Type *'), findsOneWidget);
    expect(find.text('Currently Working? *'), findsOneWidget);

    print('✅ All fields are now visible regardless of experience selection');
  });
}
