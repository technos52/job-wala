import 'package:flutter/material.dart';
import 'lib/dropdown_options/dropdown_options.dart';
import 'lib/dropdown_options/qualification.dart';
import 'lib/dropdown_options/job_category.dart';
import 'lib/dropdown_options/job_type.dart';
import 'lib/dropdown_options/designation.dart';

void main() {
  runApp(const DropdownTestApp());
}

class DropdownTestApp extends StatelessWidget {
  const DropdownTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropdown System Test',
      home: const DropdownTestScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DropdownTestScreen extends StatefulWidget {
  const DropdownTestScreen({super.key});

  @override
  State<DropdownTestScreen> createState() => _DropdownTestScreenState();
}

class _DropdownTestScreenState extends State<DropdownTestScreen> {
  String? selectedQualification;
  String? selectedJobCategory;
  String? selectedJobType;
  String? selectedDesignation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centralized Dropdown Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Testing Centralized Dropdown System',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Test direct access
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Direct Access Test:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Qualifications: ${QualificationOptions.values.length} items',
                    ),
                    Text(
                      'Job Categories: ${JobCategoryOptions.values.length} items',
                    ),
                    Text('Job Types: ${JobTypeOptions.values.length} items'),
                    Text(
                      'Designations: ${DesignationOptions.values.length} items',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Test through DropdownOptions class
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DropdownOptions Class Test:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Qualifications: ${DropdownOptions.getOptions("qualification").length} items',
                    ),
                    Text(
                      'Job Categories: ${DropdownOptions.getOptions("jobCategory").length} items',
                    ),
                    Text(
                      'Job Types: ${DropdownOptions.getOptions("jobType").length} items',
                    ),
                    Text(
                      'Designations: ${DropdownOptions.getOptions("designation").length} items',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Test actual dropdowns
            const Text(
              'Interactive Dropdowns:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Qualification Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Qualification',
                border: OutlineInputBorder(),
              ),
              value: selectedQualification,
              items: QualificationOptions.values.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedQualification = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Job Category Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Job Category',
                border: OutlineInputBorder(),
              ),
              value: selectedJobCategory,
              items: JobCategoryOptions.values.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedJobCategory = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Job Type Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Job Type',
                border: OutlineInputBorder(),
              ),
              value: selectedJobType,
              items: JobTypeOptions.values.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedJobType = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Designation Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Designation',
                border: OutlineInputBorder(),
              ),
              value: selectedDesignation,
              items: DesignationOptions.values.take(10).map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedDesignation = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // Show selections
            if (selectedQualification != null ||
                selectedJobCategory != null ||
                selectedJobType != null ||
                selectedDesignation != null)
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Values:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (selectedQualification != null)
                        Text('Qualification: $selectedQualification'),
                      if (selectedJobCategory != null)
                        Text('Job Category: $selectedJobCategory'),
                      if (selectedJobType != null)
                        Text('Job Type: $selectedJobType'),
                      if (selectedDesignation != null)
                        Text('Designation: $selectedDesignation'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
