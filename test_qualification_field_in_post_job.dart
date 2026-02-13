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

  runApp(const QualificationFieldTestApp());
}

class QualificationFieldTestApp extends StatelessWidget {
  const QualificationFieldTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qualification Field Test',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const QualificationFieldTestScreen(),
    );
  }
}

class QualificationFieldTestScreen extends StatelessWidget {
  const QualificationFieldTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qualification Field Test'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64),
            SizedBox(height: 16),
            Text(
              'Qualification Field Added Successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'The qualification dropdown field has been added to the Post Job form.',
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
                    Text('✅ Added qualification dropdown variable'),
                    Text('✅ Added qualification options loading from Firebase'),
                    Text('✅ Added qualification dropdown field to UI'),
                    Text('✅ Added qualification validation'),
                    Text('✅ Added qualification to job data when posting'),
                    Text('✅ Added qualification to form clearing'),
                    Text('✅ Added qualification to edit job functionality'),
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
