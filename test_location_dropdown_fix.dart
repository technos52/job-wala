import 'package:flutter/material.dart';
import 'lib/widgets/searchable_dropdown.dart';
import 'lib/data/locations_data.dart';

void main() {
  runApp(const LocationDropdownTestApp());
}

class LocationDropdownTestApp extends StatelessWidget {
  const LocationDropdownTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Dropdown Test',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const LocationDropdownTestScreen(),
    );
  }
}

class LocationDropdownTestScreen extends StatefulWidget {
  const LocationDropdownTestScreen({super.key});

  @override
  State<LocationDropdownTestScreen> createState() =>
      _LocationDropdownTestScreenState();
}

class _LocationDropdownTestScreenState
    extends State<LocationDropdownTestScreen> {
  String? _selectedState;
  String? _selectedDistrict;

  static const primaryBlue = Color(0xFF007BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Dropdown Test'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test Location Dropdowns',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 32),

            // Location Section Header
            Row(
              children: [
                Icon(Icons.location_on_rounded, size: 20, color: primaryBlue),
                const SizedBox(width: 8),
                const Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // State Dropdown
            SearchableDropdown(
              value: _selectedState,
              items: indianStates,
              labelText: 'State',
              hintText: 'Search and select state',
              prefixIcon: Icons.location_city_rounded,
              primaryColor: primaryBlue,
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                  _selectedDistrict = null; // Reset district when state changes
                });
                print('✅ State selected: $value');
                print('🔄 District reset to null');
              },
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please select a state';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // District Dropdown
            SearchableDropdown(
              value: _selectedDistrict,
              items: _selectedState != null
                  ? (districtsByState[_selectedState] ?? <String>[])
                  : <String>[],
              labelText: 'District',
              hintText: _selectedState != null
                  ? 'Search and select district'
                  : 'Select state first',
              prefixIcon: Icons.location_on_rounded,
              primaryColor: primaryBlue,
              enabled: _selectedState != null,
              onChanged: (value) {
                setState(() {
                  _selectedDistrict = value;
                });
                print('✅ District selected: $value');
              },
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please select a district';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Test Results Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Selection:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text('State: ${_selectedState ?? 'Not selected'}'),
                  Text('District: ${_selectedDistrict ?? 'Not selected'}'),
                  const SizedBox(height: 16),
                  const Text(
                    'Test Instructions:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1. Tap State dropdown and select a state\n'
                    '2. Verify dropdown closes immediately\n'
                    '3. Tap District dropdown and select a district\n'
                    '4. Verify dropdown closes immediately\n'
                    '5. Test rapid tapping - should handle gracefully',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Test Status
            if (_selectedState != null && _selectedDistrict != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Location selection complete!',
                      style: TextStyle(
                        color: Color(0xFF065F46),
                        fontWeight: FontWeight.w500,
                      ),
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
