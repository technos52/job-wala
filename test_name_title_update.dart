import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TestNameTitleUpdate());
  }
}

class TestNameTitleUpdate extends StatefulWidget {
  @override
  _TestNameTitleUpdateState createState() => _TestNameTitleUpdateState();
}

class _TestNameTitleUpdateState extends State<TestNameTitleUpdate> {
  final _fullNameController = TextEditingController();
  String? _title;

  final List<String> _titles = ['Mr.', 'Mrs.', 'Ms.', 'Dr.'];

  @override
  void initState() {
    super.initState();
    // Simulate loading existing data
    _loadTestData();
  }

  void _loadTestData() {
    // Simulate the current user data from the screenshot
    setState(() {
      // Simulate data from Firestore: "Dr. sharma"
      String fullName = "Dr. sharma";

      // Remove title prefixes from full name for display
      for (String titlePrefix in _titles) {
        if (fullName.startsWith('$titlePrefix ')) {
          fullName = fullName.substring(titlePrefix.length + 1);
          _title = titlePrefix;
          break;
        }
      }
      _fullNameController.text = fullName;

      print('📊 Loaded data:');
      print('   Full name from DB: "Dr. sharma"');
      print('   Extracted title: "$_title"');
      print('   Name for editing: "${_fullNameController.text}"');
    });
  }

  void _saveProfile() {
    // Construct full name with title if title is selected
    String fullNameToSave = _fullNameController.text.trim();
    if (_title != null && _title!.isNotEmpty) {
      fullNameToSave = '$_title $fullNameToSave';
    }

    print('💾 Saving profile:');
    print('   Name field: "${_fullNameController.text}"');
    print('   Selected title: "$_title"');
    print('   Full name to save: "$fullNameToSave"');

    // Simulate successful save
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile saved: $fullNameToSave'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Name & Title Update')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current state display
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current State:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Title: ${_title ?? "None"}'),
                  Text('Name: "${_fullNameController.text}"'),
                  Text(
                    'Full Name: ${_title != null ? "$_title ${_fullNameController.text}" : _fullNameController.text}',
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Name field
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (value) {
                setState(() {}); // Refresh display
              },
            ),

            SizedBox(height: 16),

            // Title dropdown
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonFormField<String>(
                value: _title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: InputBorder.none,
                ),
                items: _titles.map((title) {
                  return DropdownMenuItem<String>(
                    value: title,
                    child: Text(title),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                  print('🏷️ Title changed to: $value');
                },
              ),
            ),

            SizedBox(height: 20),

            // Save button
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save Profile'),
            ),

            SizedBox(height: 20),

            // Test buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _fullNameController.text = "John Doe";
                      _title = "Mr.";
                    });
                  },
                  child: Text('Test: Mr. John Doe'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _fullNameController.text = "Jane Smith";
                      _title = "Dr.";
                    });
                  },
                  child: Text('Test: Dr. Jane Smith'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }
}
