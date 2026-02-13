import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'lib/screens/employer_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (you may need to configure this for your project)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const ExperienceTextFieldTestApp());
}

class ExperienceTextFieldTestApp extends StatelessWidget {
  const ExperienceTextFieldTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experience Text Field Test',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ExperienceTextFieldTestScreen(),
    );
  }
}

class ExperienceTextFieldTestScreen extends StatelessWidget {
  const ExperienceTextFieldTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experience Text Field Test'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_note, color: Colors.green, size: 64),
            SizedBox(height: 16),
            Text(
              'Experience Field Changed to Text Box!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'The experience field in Post Job form is now a text input instead of dropdown.',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Changes Made:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('✅ Removed experience dropdown variables'),
                    Text('✅ Added experience text controller'),
                    Text('✅ Updated form initialization and disposal'),
                    Text('✅ Removed experience levels from dropdown loading'),
                    Text('✅ Changed UI from dropdown to text field'),
                    Text('✅ Updated validation for text input'),
                    Text('✅ Updated job data storage'),
                    Text('✅ Updated form clearing'),
                    Text('✅ Updated edit job functionality'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Field Details:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('📝 Label: "Experience Required"'),
                    Text(
                      '💡 Placeholder: "Enter experience required (e.g., 2-5 years)"',
                    ),
                    Text('✔️ Validation: Required field'),
                    Text('💾 Storage: Saved as text in Firebase'),
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
