import 'package:flutter/material.dart';
import 'lib/widgets/searchable_dropdown.dart';

/// Test to verify the dropdown gap fix
/// This tests that the dropdown appears immediately below the input field
/// without any large gap, especially on first tap
class TestDropdownGapFix extends StatefulWidget {
  const TestDropdownGapFix({super.key});

  @override
  State<TestDropdownGapFix> createState() => _TestDropdownGapFixState();
}

class _TestDropdownGapFixState extends State<TestDropdownGapFix> {
  String? _selectedJobType;
  String? _selectedDesignation;
  String? _selectedQualification;

  final List<String> _jobTypes = [
    'Full Time',
    'Contract',
    'Part Time',
    'Internship',
    'Remote',
    'Freelance',
  ];

  final List<String> _designations = [
    'Software Developer',
    'Senior Developer',
    'Team Lead',
    'Project Manager',
    'UI/UX Designer',
    'Data Analyst',
  ];

  final List<String> _qualifications = [
    'High School',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'PhD',
    'Diploma',
    'Certificate',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dropdown Gap Fix Test'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dropdown Gap Fix Verification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Test that dropdowns appear immediately below the input field '
              'without any gap. The dropdown should be positioned correctly '
              'on both first and subsequent taps.',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 32),

            // Test Case 1: Job Type Dropdown (the one shown in the image)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Test Case 1: Job Type Dropdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This matches the dropdown shown in your image. '
                    'Click to verify no gap appears.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 16),
                  SearchableDropdown(
                    value: _selectedJobType,
                    items: _jobTypes,
                    hintText: 'Select or type job type',
                    labelText: 'Job Type',
                    prefixIcon: Icons.work_outline,
                    onChanged: (value) {
                      setState(() {
                        _selectedJobType = value;
                      });
                      print('Job Type selected: $value');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Test Case 2: Designation Dropdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Test Case 2: Designation Dropdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Similar to the designation field in candidate registration.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 16),
                  SearchableDropdown(
                    value: _selectedDesignation,
                    items: _designations,
                    hintText: 'Select or type designation',
                    labelText: 'Designation',
                    prefixIcon: Icons.badge_outlined,
                    onChanged: (value) {
                      setState(() {
                        _selectedDesignation = value;
                      });
                      print('Designation selected: $value');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Test Case 3: Qualification Dropdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Test Case 3: Qualification Dropdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Test the qualification dropdown that was causing issues.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 16),
                  SearchableDropdown(
                    value: _selectedQualification,
                    items: _qualifications,
                    hintText: 'Select or type qualification',
                    labelText: 'Qualification',
                    prefixIcon: Icons.school_outlined,
                    onChanged: (value) {
                      setState(() {
                        _selectedQualification = value;
                      });
                      print('Qualification selected: $value');
                    },
                  ),
                ],
              ),
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
                  Text('Job Type: ${_selectedJobType ?? 'None selected'}'),
                  Text(
                    'Designation: ${_selectedDesignation ?? 'None selected'}',
                  ),
                  Text(
                    'Qualification: ${_selectedQualification ?? 'None selected'}',
                  ),
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
                        Icons.check_circle_outline,
                        color: const Color(0xFF007BFF),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Gap Fix Verification Steps',
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
                    '1. Click on each dropdown field\n'
                    '2. Verify dropdown appears immediately below the input field\n'
                    '3. Check that there is NO gap between field and dropdown\n'
                    '4. Test first tap vs subsequent taps (should be identical)\n'
                    '5. Try typing to filter options\n'
                    '6. Test on different screen positions\n'
                    '7. Verify dropdown width matches input field width',
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

            // Expected Behavior
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        color: const Color(0xFF10B981),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Expected Behavior (Fixed)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '✅ Dropdown appears immediately below input field\n'
                    '✅ No gap between input field and dropdown list\n'
                    '✅ Consistent positioning on first and subsequent taps\n'
                    '✅ Dropdown width matches input field width exactly\n'
                    '✅ Proper positioning regardless of screen location\n'
                    '✅ Smooth, professional appearance',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF065F46),
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
      title: 'Dropdown Gap Fix Test',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      home: const TestDropdownGapFix(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
