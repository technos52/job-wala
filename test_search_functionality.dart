import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'lib/simple_candidate_dashboard.dart';

void main() {
  testWidgets('Search functionality test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: SimpleCandidateDashboard()));

    // Verify that the search bar is present
    expect(find.byType(TextField), findsOneWidget);

    // Verify the search hint text
    expect(
      find.text('Search by job title, company, location, department...'),
      findsOneWidget,
    );

    // Verify that the search icon is present
    expect(find.byIcon(Icons.search), findsOneWidget);

    print('✅ Search functionality components are present');
  });
}
