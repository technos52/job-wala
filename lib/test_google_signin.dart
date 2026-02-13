import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestGoogleSignIn extends StatefulWidget {
  const TestGoogleSignIn({super.key});

  @override
  State<TestGoogleSignIn> createState() => _TestGoogleSignInState();
}

class _TestGoogleSignInState extends State<TestGoogleSignIn> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _status = 'Ready to test';
  bool _isLoading = false;

  Future<void> _testGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _status = 'Starting Google Sign-In test...';
    });

    try {
      // Step 1: Sign out first
      await _googleSignIn.signOut();
      setState(() => _status = 'Step 1: Signed out from previous session');
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 2: Attempt Google Sign-In
      setState(() => _status = 'Step 2: Attempting Google Sign-In...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() => _status = 'Step 2: User canceled sign-in');
        return;
      }

      setState(() => _status = 'Step 3: Got Google user: ${googleUser.email}');
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 3: Get authentication
      setState(() => _status = 'Step 4: Getting authentication tokens...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      setState(
        () => _status =
            'Step 5: Got tokens - Access: ${googleAuth.accessToken != null}, ID: ${googleAuth.idToken != null}',
      );
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 4: Create Firebase credential
      setState(() => _status = 'Step 6: Creating Firebase credential...');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 5: Sign in to Firebase
      setState(() => _status = 'Step 7: Signing in to Firebase...');
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      setState(
        () => _status = 'SUCCESS! Signed in as: ${userCredential.user?.email}',
      );
    } catch (e) {
      setState(() => _status = 'ERROR: $e');
      debugPrint('Test error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign-In Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _testGoogleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Test Google Sign-In'),
            ),
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuration Check:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('• Package: com.shailesh.alljobsopen'),
                    Text(
                      '• SHA-1: 28:2F:96:8B:D0:BA:C4:B3:5E:5F:8F:B4:8A:A4:44:3C:6C:C9:0B:4A',
                    ),
                    Text('• Firebase Project: jobease-edevs'),
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
