import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseUtility {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check current user's employer document structure
  static Future<Map<String, dynamic>?> checkCurrentEmployerDocument() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('employers').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        print('📄 Current employer document structure:');
        print('  - approvalStatus: ${data['approvalStatus']}');
        print('  - isApproved: ${data['isApproved']} (should not exist)');
        print(
          '  - reason: ${data['reason']} (should exist and be empty by default)',
        );
        print('  - All fields: ${data.keys.toList()}');
        return data;
      }
    } catch (e) {
      print('❌ Error checking document: $e');
    }
    return null;
  }

  // Fix current user's employer document
  static Future<bool> fixCurrentEmployerDocument() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('❌ No user signed in');
      return false;
    }

    try {
      final docRef = _firestore.collection('employers').doc(user.uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        print('❌ Employer document does not exist');
        return false;
      }

      final data = doc.data()!;
      final updates = <String, dynamic>{};
      bool needsUpdate = false;

      // Remove isApproved field if it exists
      if (data.containsKey('isApproved')) {
        updates['isApproved'] = FieldValue.delete();
        needsUpdate = true;
        print('🗑️ Removing isApproved field');
      }

      // Add reason field if it doesn't exist
      if (!data.containsKey('reason')) {
        updates['reason'] = '';
        needsUpdate = true;
        print('➕ Adding reason field');
      }

      // Ensure approvalStatus is correct
      final currentStatus = data['approvalStatus'];
      if (currentStatus == null ||
          !['pending', 'approved', 'rejected'].contains(currentStatus)) {
        updates['approvalStatus'] = 'pending';
        needsUpdate = true;
        print('🔧 Fixing approvalStatus');
      }

      if (needsUpdate) {
        await docRef.update(updates);
        print('✅ Document updated successfully');
        return true;
      } else {
        print('✨ Document is already clean');
        return true;
      }
    } catch (e) {
      print('❌ Error fixing document: $e');
      return false;
    }
  }

  // Create a test employer document with correct structure
  static Future<void> createTestEmployerDocument() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('❌ No user signed in');
      return;
    }

    try {
      await _firestore.collection('employers').doc(user.uid).set({
        'companyName': 'Test Company',
        'contactPerson': 'Test Person',
        'email': user.email,
        'mobileNumber': '1234567890',
        'industryType': 'Technology',
        'state': 'Test State',
        'district': 'Test District',
        'uid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'emailVerified': true,
        'registrationComplete': true,
        'approvalStatus': 'pending', // Single source of truth
        'approvedAt': null,
        'approvedBy': null,
        'reason': '', // Always present, empty by default
      });

      print('✅ Test employer document created with correct structure');
    } catch (e) {
      print('❌ Error creating test document: $e');
    }
  }
}

class DatabaseTestScreen extends StatefulWidget {
  const DatabaseTestScreen({super.key});

  @override
  State<DatabaseTestScreen> createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  String _output = 'Tap buttons to test database structure';

  void _updateOutput(String text) {
    setState(() {
      _output = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Structure Test'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Database Structure Checker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                _updateOutput('Checking current employer document...');
                final data =
                    await DatabaseUtility.checkCurrentEmployerDocument();
                if (data != null) {
                  final hasIsApproved = data.containsKey('isApproved');
                  final hasReason = data.containsKey('reason');
                  final approvalStatus = data['approvalStatus'];

                  _updateOutput(
                    'Document Structure Analysis:\n\n'
                    '✅ approvalStatus: $approvalStatus\n'
                    '${hasIsApproved ? "❌" : "✅"} isApproved: ${hasIsApproved ? "EXISTS (should be removed)" : "DOES NOT EXIST (good)"}\n'
                    '${hasReason ? "✅" : "❌"} reason: ${hasReason ? "EXISTS" : "MISSING"}\n\n'
                    'Issues found: ${(hasIsApproved ? 1 : 0) + (hasReason ? 0 : 1)}',
                  );
                } else {
                  _updateOutput('❌ No employer document found');
                }
              },
              child: const Text('Check Current Document'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () async {
                _updateOutput('Fixing employer document...');
                final success =
                    await DatabaseUtility.fixCurrentEmployerDocument();
                _updateOutput(
                  success
                      ? '✅ Document fixed successfully!\n\nStructure is now clean.'
                      : '❌ Failed to fix document',
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Fix Current Document'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () async {
                _updateOutput('Creating test document...');
                await DatabaseUtility.createTestEmployerDocument();
                _updateOutput('✅ Test document created with correct structure');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Create Test Document'),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _output,
                    style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
