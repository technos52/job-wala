import 'package:flutter/material.dart';
import 'lib/widgets/searchable_dropdown.dart';

/// Test to verify the overlay assertion fix
/// This tests that clicking on dropdowns doesn't cause assertion errors
/// and the app doesn't freeze
class TestOverlayAssertionFix extends StatefulWidget {
  const TestOverlayAssertionFix({super.key});

  @override
  State<TestOverlayAssertionFix> createState() =>
      _TestOverlayAssertionFixState();
}

class _TestOverlayAssertionFixState extends State<TestOverlayAssertionFix> {
  String? _selectedQualification;
  String? _selectedJobCategory;
  String? _selectedJobType;

  final List<String> _qualifications = [
    'High School',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'PhD',
    'Diploma',
    'Certificate',
  ];

  final List<String> _jobCategories = [
    'Software Development',
    'Marketing',
    'Sales',
    'Human Resources',
    'Finance',
    'Operations',
    'Customer Service',
    'Design',
  ];

  final List<String> _jobTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Freelance',
    'Internship',
    'Remote',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overlay Assertion Fix Test'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overlay Assertion Error Fix Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Test that clicking on dropdowns doesn\'t cause assertion errors '
              'or freeze the app. Try rapid clicking and multiple interactions.',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 32),

            // Test Case 1: Qualification Dropdown (the one that was causing issues)
            const Text(
              'Test Case 1: Qualification Dropdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 16),
            SearchableDropdown(
              value: _selectedQualification,
              items: _qualifications,
              hintText: 'Select qualification',
              labelText: 'Qualification',
              prefixIcon: Icons.school,
              onChanged: (value) {
                setState(() {
                  _selectedQualification = value;
                });
                print('Qualification selected: $value');
              },
            ),

            const SizedBox(height: 32),

            // Test Case 2: Job Category Dropdown
            const Text(
              'Test Case 2: Job Category Dropdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 16),
            SearchableDropdown(
              value: _selectedJobCategory,
              items: _jobCategories,
              hintText: 'Select job category',
              labelText: 'Job Category',
              prefixIcon: Icons.work,
              onChanged: (value) {
                setState(() {
                  _selectedJobCategory = value;
                });
                print('Job Category selected: $value');
              },
            ),

            const SizedBox(height: 32),

            // Test Case 3: Job Type Dropdown
            const Text(
              'Test Case 3: Job Type Dropdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 16),
            SearchableDropdown(
              value: _selectedJobType,
              items: _jobTypes,
              hintText: 'Select job type',
              labelText: 'Job Type',
              prefixIcon: Icons.schedule,
              onChanged: (value) {
                setState(() {
                  _selectedJobType = value;
                });
                print('Job Type selected: $value');
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
                  Text(
                    'Qualification: ${_selectedQualification ?? 'None selected'}',
                  ),
                  Text(
                    'Job Category: ${_selectedJobCategory ?? 'None selected'}',
                  ),
                  Text('Job Type: ${_selectedJobType ?? 'None selected'}'),
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
                        Icons.bug_report,
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
                    '1. Click on each dropdown multiple times rapidly\n'
                    '2. Try opening multiple dropdowns in sequence\n'
                    '3. Type to filter options in each dropdown\n'
                    '4. Click outside to close dropdowns\n'
                    '5. Verify no assertion errors occur\n'
                    '6. Verify the app doesn\'t freeze\n'
                    '7. Check console for any error messages',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Stress Test Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.speed,
                        color: const Color(0xFFF59E0B),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Stress Test',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Try these stress test scenarios:\n'
                    '• Rapid clicking on qualification dropdown (the problematic one)\n'
                    '• Opening and closing dropdowns very quickly\n'
                    '• Switching between dropdowns rapidly\n'
                    '• Typing and deleting text quickly while dropdown is open\n'
                    '• Scrolling while dropdown is open',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF92400E),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Extra space for testing
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
      title: 'Overlay Assertion Fix Test',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      home: const TestOverlayAssertionFix(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
