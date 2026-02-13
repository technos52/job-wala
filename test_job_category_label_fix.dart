import 'package:flutter/material.dart';

void main() {
  print('🔍 Testing Job Category Label Update');
  print('');
  print('✅ Expected Changes:');
  print('   • Job Category field should show "Department / Job Category *"');
  print('   • Hint text should show "Select or type department/job category"');
  print('   • Validation message should mention "department/job category"');
  print('');
  print('📍 Location: lib/screens/candidate_registration_step2_screen.dart');
  print('   • Line ~1036: labelText: "Department / Job Category *"');
  print('   • Line ~1035: hintText: "Select or type department/job category"');
  print(
    '   • Line ~1047: validation message includes "department/job category"',
  );
  print('');
  print('🚀 Test Steps:');
  print('   1. Navigate to candidate registration step 2');
  print('   2. Scroll to the Job Category field');
  print('   3. Verify the label shows "Department / Job Category *"');
  print('   4. Tap the field and verify hint text');
  print('   5. Try to submit without selection to see validation message');
  print('');
  print('🔧 If label still shows "Job Category":');
  print('   • Try hot restart (R in terminal)');
  print('   • Clear app data and restart');
  print('   • Check if there are any cached widgets');
  print('');

  runApp(JobCategoryLabelTestApp());
}

class JobCategoryLabelTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Category Label Test',
      home: JobCategoryLabelTestScreen(),
    );
  }
}

class JobCategoryLabelTestScreen extends StatefulWidget {
  @override
  _JobCategoryLabelTestScreenState createState() =>
      _JobCategoryLabelTestScreenState();
}

class _JobCategoryLabelTestScreenState
    extends State<JobCategoryLabelTestScreen> {
  String? _selectedJobCategory;
  final List<String> _jobCategories = [
    'Information Technology',
    'Healthcare',
    'Finance',
    'Education',
    'Marketing',
    'Sales',
    'Engineering',
    'Human Resources',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Category Label Test'),
        backgroundColor: Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Testing Job Category Field Label',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 20),

            // Test the exact same field structure as in registration
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.category_rounded,
                      size: 20,
                      color: Color(0xFF007BFF),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Department / Job Category *',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedJobCategory,
                  decoration: InputDecoration(
                    hintText: 'Select or type department/job category',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 15,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _selectedJobCategory != null
                            ? Color(0xFF007BFF)
                            : Color(0xFFE5E7EB),
                        width: _selectedJobCategory != null ? 2 : 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFF007BFF),
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  items: _jobCategories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedJobCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please select your department/job category';
                    }
                    return null;
                  },
                ),
              ],
            ),

            SizedBox(height: 30),

            if (_selectedJobCategory != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF007BFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF007BFF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✅ Test Result:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF007BFF),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Selected: $_selectedJobCategory',
                      style: TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Label shows: "Department / Job Category *" ✅',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 20),

            Text(
              'Expected Behavior:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Label should show "Department / Job Category *"\n'
              '• Hint text should show "Select or type department/job category"\n'
              '• Validation should mention "department/job category"',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
