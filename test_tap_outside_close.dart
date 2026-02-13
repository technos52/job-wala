import 'package:flutter/material.dart';
import 'lib/widgets/searchable_dropdown.dart';

void main() {
  runApp(const TapOutsideTestApp());
}

class TapOutsideTestApp extends StatelessWidget {
  const TapOutsideTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap Outside Close Test',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TapOutsideTestScreen(),
    );
  }
}

class TapOutsideTestScreen extends StatefulWidget {
  const TapOutsideTestScreen({super.key});

  @override
  State<TapOutsideTestScreen> createState() => _TapOutsideTestScreenState();
}

class _TapOutsideTestScreenState extends State<TapOutsideTestScreen> {
  String? selectedState;
  String? selectedCity;
  String? selectedCategory;

  final List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  final List<String> cities = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Kolkata',
    'Pune',
    'Ahmedabad',
    'Jaipur',
    'Surat',
    'Lucknow',
    'Kanpur',
    'Nagpur',
    'Indore',
    'Thane',
    'Bhopal',
    'Visakhapatnam',
    'Pimpri-Chinchwad',
    'Patna',
    'Vadodara',
  ];

  final List<String> categories = [
    'Software Development',
    'Data Science',
    'Digital Marketing',
    'Graphic Design',
    'Project Management',
    'Sales & Marketing',
    'Human Resources',
    'Finance & Accounting',
    'Customer Support',
    'Business Analysis',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap Outside to Close Test'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test Tap Outside to Close Dropdowns',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try opening a dropdown and then tapping outside of it. The dropdown should close automatically.',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 32),

            // State Dropdown
            SearchableDropdown(
              value: selectedState,
              items: states,
              hintText: 'Select your state',
              labelText: 'State',
              prefixIcon: Icons.location_on,
              primaryColor: const Color(0xFF007BFF),
              onChanged: (value) {
                setState(() {
                  selectedState = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a state';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // City Dropdown
            SearchableDropdown(
              value: selectedCity,
              items: cities,
              hintText: 'Select your city',
              labelText: 'City',
              prefixIcon: Icons.location_city,
              primaryColor: const Color(0xFF007BFF),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a city';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Category Dropdown
            SearchableDropdown(
              value: selectedCategory,
              items: categories,
              hintText: 'Select a category',
              labelText: 'Job Category',
              prefixIcon: Icons.work,
              primaryColor: const Color(0xFF007BFF),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Test Instructions
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
                    'Test Instructions:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Tap on any dropdown to open it',
                    style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                  ),
                  const Text(
                    '2. Tap anywhere outside the dropdown',
                    style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                  ),
                  const Text(
                    '3. The dropdown should close automatically',
                    style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                  ),
                  const Text(
                    '4. Only one dropdown can be open at a time',
                    style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: const Color(0xFF007BFF),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'The tap-outside-to-close feature uses an invisible barrier that detects taps outside the dropdown area.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Selected Values Display
            if (selectedState != null ||
                selectedCity != null ||
                selectedCategory != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF007BFF).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Values:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (selectedState != null)
                      Text(
                        'State: $selectedState',
                        style: const TextStyle(fontSize: 14),
                      ),
                    if (selectedCity != null)
                      Text(
                        'City: $selectedCity',
                        style: const TextStyle(fontSize: 14),
                      ),
                    if (selectedCategory != null)
                      Text(
                        'Category: $selectedCategory',
                        style: const TextStyle(fontSize: 14),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
