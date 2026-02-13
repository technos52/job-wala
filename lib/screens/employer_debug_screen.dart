import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class EmployerDebugScreen extends StatefulWidget {
  const EmployerDebugScreen({super.key});

  @override
  State<EmployerDebugScreen> createState() => _EmployerDebugScreenState();
}

class _EmployerDebugScreenState extends State<EmployerDebugScreen> {
  String _debugInfo = 'Loading debug info...';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  Future<void> _loadDebugInfo() async {
    setState(() {
      _isLoading = true;
      _debugInfo = 'Loading debug info...';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _debugInfo = 'No user is currently signed in.\n\nPlease sign in first.';
          _isLoading = false;
        });
        return;
      }

      String info = '=== DEBUG INFO ===\n\n';
      info += 'Current User:\n';
      info += '- Email: ${user.email}\n';
      info += '- UID: ${user.uid}\n';
      info += '- Display Name: ${user.displayName}\n\n';

      // Check employer document
      info += 'Employer Document Check:\n';
      try {
        final employerDoc = await FirebaseFirestore.instance
            .collection('employers')
            .doc(user.uid)
            .get();
        
        if (employerDoc.exists) {
          info += '- Employer document EXISTS ✓\n';
          final data = employerDoc.data()!;
          info += '- Company Name: ${data['companyName'] ?? 'Not set'}\n';
          info += '- Approval Status: ${data['approvalStatus'] ?? 'Not set'}\n';
          info += '- Registration Complete: ${data['registrationComplete'] ?? 'Not set'}\n';
          info += '- Full Data: $data\n\n';
        } else {
          info += '- Employer document NOT FOUND ✗\n\n';
        }
      } catch (e) {
        info += '- Error checking employer document: $e\n\n';
      }

      // Check candidate documents
      info += 'Candidate Document Check:\n';
      try {
        final candidateQuery = await FirebaseFirestore.instance
            .collection('candidates')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();
        
        if (candidateQuery.docs.isNotEmpty) {
          info += '- Candidate document EXISTS ✓\n';
          final candidateData = candidateQuery.docs.first.data();
          info += '- Candidate Name: ${candidateData['name'] ?? 'Not set'}\n';
          info += '- Candidate Data: $candidateData\n\n';
        } else {
          info += '- Candidate document NOT FOUND ✓\n\n';
        }
      } catch (e) {
        info += '- Error checking candidate document: $e\n\n';
      }

      // Check approval status
      info += 'Approval Status Check:\n';
      try {
        final approvalData = await AuthService.getApprovalStatus();
        info += '- Approval Data: $approvalData\n\n';
      } catch (e) {
        info += '- Error checking approval status: $e\n\n';
      }

      // Check auth status
      info += 'Auth Status Check:\n';
      try {
        final authData = await AuthService.checkAuthStatus();
        info += '- Auth Data: $authData\n\n';
      } catch (e) {
        info += '- Error checking auth status: $e\n\n';
      }

      setState(() {
        _debugInfo = info;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _debugInfo = 'Error loading debug info: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _createTestEmployer() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in first')),
        );
        return;
      }

      // Create test employer document
      await FirebaseFirestore.instance
          .collection('employers')
          .doc(user.uid)
          .set({
        'companyName': 'Test Company',
        'email': user.email,
        'approvalStatus': 'approved', // Set to approved for testing
        'registrationComplete': true,
        'createdAt': FieldValue.serverTimestamp(),
        'uid': user.uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test employer created with approved status'),
          backgroundColor: Colors.green,
        ),
      );

      _loadDebugInfo(); // Refresh debug info
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating test employer: $e')),
      );
    }
  }

  Future<void> _signOut() async {
    await AuthService.signOut();
    Navigator.of(context).pushReplacementNamed('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employer Debug'),
        actions: [
          IconButton(
            onPressed: _loadDebugInfo,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _createTestEmployer,
                    child: const Text('Create Test Employer'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _signOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Debug info
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Text(
                          _debugInfo,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
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
