import 'package:flutter/material.dart';
import 'lib/widgets/searchable_dropdown.dart';

/// Test screen to verify dropdown positioning fix
/// This tests the SearchableDropdown positioning issue where there was
/// a large gap on first tap that disappeared on second tap
class TestDropdownPositioning extends StatefulWidget {
  const TestDropdownPositioning({super.key});

  @override
  State<TestDropdownPositioning> createState() =>
      _TestDropdownPositioningState();
}

class _TestDropdownPositioningState extends State<TestDropdownPositioning> {
  String? _selectedValue1;
  String? _selectedValue2;
  String? _selectedValue3;

  final List<String> _testItems = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
    'Very Long Option Name That Tests Wrapping',
    'Another Option',
    'Final Option',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dropdown Positioning Test'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dropdown Positioning Fix Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Test the dropdown positioning by tapping on each dropdown. '
              'The dropdown should appear immediately below the input field '
              'without any large gap on the first tap.',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 32),

            // Test Case 1: Dropdown at top of screen
            const Text(
              'Test Case 1: Dropdown at top of screen',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 16),
            SearchableDropdown(
              value: _selectedValue1,
              items: _testItems,
              hintText: 'Select an option',
              labelText: 'Top Dropdown',
              prefixIcon: Icons.arrow_drop_down_circle,
              onChanged: (value) {
                setState(() {
                  _selectedValue1 = value;
                });
              },
            ),

            const SizedBox(height: 48),

            // Test Case 2: Dropdown in middle of screen
            const Text(
              'Test Case 2: Dropdown in middle of screen',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 16),
            SearchableDropdown(
              value: _selectedValue2,
              items: _testItems,
              hintText: 'Select another option',
              labelText: 'Middle Dropdown',
              prefixIcon: Icons.list,
              onChanged: (value) {
                setState(() {
                  _selectedValue2 = value;
                });
              },
            ),

            // Add some spacing to push the next dropdown towards bottom
            const SizedBox(height: 200),

            // Test Case 3: Dropdown near bottom of screen (should show above)
            const Text(
              'Test Case 3: Dropdown near bottom (should show above)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 16),
            SearchableDropdown(
              value: _selectedValue3,
              items: _testItems,
              hintText: 'Select bottom option',
              labelText: 'Bottom Dropdown',
              prefixIcon: Icons.vertical_align_bottom,
              onChanged: (value) {
                setState(() {
                  _selectedValue3 = value;
                });
              },
            ),

            const SizedBox(height: 32),

            // Test Results Display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Values:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Top: ${_selectedValue1 ?? 'None selected'}'),
                  Text('Middle: ${_selectedValue2 ?? 'None selected'}'),
                  Text('Bottom: ${_selectedValue3 ?? 'None selected'}'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Test Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF007BFF).withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: const Color(0xFF007BFF),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Test Instructions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF007BFF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '1. Tap on each dropdown field\n'
                    '2. Verify the dropdown appears immediately below the field\n'
                    '3. Check that there is no large gap on first tap\n'
                    '4. The bottom dropdown should appear above the field if there\'s no space below\n'
                    '5. Try typing to filter options\n'
                    '6. Test multiple rapid taps to ensure stability',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 100,
            ), // Extra space for bottom dropdown testing
          ],
        ),
      ),
    );
  }
}

/// Main function to run the test
void main() {
  runApp(
    MaterialApp(
      title: 'Dropdown Positioning Test',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      home: const TestDropdownPositioning(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
