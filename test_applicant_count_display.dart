import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Applicant Count Display',
      home: const TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Applicant Count Display')),
      body: const Center(
        child: Text(
          'Test implementation for applicant count display in job cards.\n\n'
          'Changes made:\n'
          '1. Added StreamBuilder to count applications for each job\n'
          '2. Display count as a blue badge next to "Applicants" text\n'
          '3. Maintained existing red dot for new applications\n'
          '4. Count updates in real-time as applications are added/removed',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
