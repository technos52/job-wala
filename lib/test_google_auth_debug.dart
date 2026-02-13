import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/auth_service.dart';

class GoogleAuthDebugScreen extends StatefulWidget {
  const GoogleAuthDebugScreen({super.key});

  @override
  State<GoogleAuthDebugScreen> createState() => _GoogleAuthDebugScreenState();
}

class _GoogleAuthDebugScreenState extends State<GoogleAuthDebugScreen> {
  final List<String> _debugLogs = [];
  bool _isLoading = false;

  void _addLog(String message) {
    setState(() {
      _debugLogs.add(
        '${DateTime.now().toString().substring(11, 19)}: $message',
      );
    });
    print('🔍 DEBUG: $message');
  }

  Future<void> _testGoogleAuth() async {
    setState(() {
      _isLoading = true;
      _debugLogs.clear();
    });

    _addLog('Starting Google Authentication Test...');

    try {
      // Test 1: Check current auth state
      _addLog('Test 1: Checking current auth state...');
      final currentUser = FirebaseAuth.instance.currentUser;
      _addLog('Current user: ${currentUser?.email ?? 'None'}');

      // Test 2: Try Google Sign-In for candidate
      _addLog('Test 2: Attempting Google Sign-In for candidate...');
      final userCredential = await AuthService.signInWithGoogleForCandidate();

      if (userCredential != null) {
        _addLog('✅ Google Sign-In successful!');
        _addLog('User email: ${userCredential.user?.email}');
        _addLog('User UID: ${userCredential.user?.uid}');

        // Test 3: Check if user exists in Firestore
        _addLog('Test 3: Checking Firestore for existing candidate...');
        final candidateQuery = await FirebaseFirestore.instance
            .collection('candidates')
            .where('email', isEqualTo: userCredential.user!.email)
            .limit(1)
            .get();

        if (candidateQuery.docs.isNotEmpty) {
          final userData = candidateQuery.docs.first.data();
          final isComplete = userData['registrationComplete'] ?? false;
          _addLog('✅ Found existing candidate');
          _addLog('Registration complete: $isComplete');
          _addLog('Mobile number: ${candidateQuery.docs.first.id}');
        } else {
          _addLog('ℹ️ No existing candidate found - new user');
        }

        // Test 4: Check auth status
        _addLog('Test 4: Checking auth status...');
        final authStatus = await AuthService.checkAuthStatus();
        _addLog('Auth status: $authStatus');
      } else {
        _addLog('❌ Google Sign-In returned null');
      }
    } catch (e) {
      _addLog('❌ Error occurred: $e');

      // Check for existing user exceptions
      if (e.toString().contains('EXISTING_USER_COMPLETE:')) {
        final mobileNumber = e.toString().split(':')[1];
        _addLog('✅ Detected existing complete user: $mobileNumber');
      } else if (e.toString().contains('EXISTING_USER_INCOMPLETE:')) {
        final mobileNumber = e.toString().split(':')[1];
        _addLog('✅ Detected existing incomplete user: $mobileNumber');
      }
    }

    setState(() {
      _isLoading = false;
    });

    _addLog('Test completed!');
  }

  Future<void> _signOut() async {
    _addLog('Signing out...');
    await AuthService.signOut();
    _addLog('✅ Signed out successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Auth Debug'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testGoogleAuth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BFF),
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Test Google Auth'),
                  ),
                ),
                const SizedBox(width: 16),
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
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Debug Logs:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_debugLogs.isEmpty)
                        const Text(
                          'No logs yet. Click "Test Google Auth" to start.',
                          style: TextStyle(color: Colors.grey),
                        )
                      else
                        ..._debugLogs.map(
                          (log) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              log,
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                    ],
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
