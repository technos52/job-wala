import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'lib/simple_candidate_dashboard.dart';

void main() {
  testWidgets('Filter functionality test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: SimpleCandidateDashboard()));

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Verify that the filter button is present
    expect(find.byIcon(Icons.filter_list), findsOneWidget);

    // Tap the filter button
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();

    // Verify that the filter bottom sheet opens
    expect(find.text('Filter Jobs'), findsOneWidget);
    expect(find.text('Job Type'), findsOneWidget);
    expect(find.text('Department'), findsOneWidget);
    expect(find.text('Candidate Department'), findsOneWidget);
    expect(find.text('Designation'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Company'), findsOneWidget);

    print('✅ Filter dialog components are present');
    print('✅ All filter categories are available');
  });
}
