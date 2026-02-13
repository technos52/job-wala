import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class FirebaseDebugScreen extends StatefulWidget {
  const FirebaseDebugScreen({super.key});

  @override
  State<FirebaseDebugScreen> createState() => _FirebaseDebugScreenState();
}

class _FirebaseDebugScreenState extends State<FirebaseDebugScreen> {
  final _output = StringBuffer();
  bool _isRunning = false;

  void _log(String message) {
    setState(() {
      _output.writeln(message);
    });
    print(message);
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _isRunning = true;
      _output.clear();
    });

    _log('🔍 FIREBASE DIAGNOSTICS STARTING...\n');

    try {
      // 1. Check Firebase Auth
      _log('1️⃣ CHECKING FIREBASE AUTH');
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _log('❌ No user signed in');
        setState(() {
          _isRunning = false;
        });
        return;
      }
      _log('✅ User signed in: ${user.email}');
      _log('   UID: ${user.uid}');
      _log('   Email verified: ${user.emailVerified}');

      // 2. Check Firestore connectivity
      _log('\n2️⃣ CHECKING FIRESTORE CONNECTIVITY');
      try {
        await FirebaseFirestore.instance
            .collection('test')
            .doc('connectivity')
            .get();
        _log('✅ Firestore connection successful');
      } catch (e) {
        _log('❌ Firestore connection failed: $e');
        setState(() {
          _isRunning = false;
        });
        return;
      }

      // 3. Check employer document
      _log('\n3️⃣ CHECKING EMPLOYER DOCUMENT');
      try {
        final employerDoc = await FirebaseFirestore.instance
            .collection('employers')
            .doc(user.uid)
            .get();

        if (!employerDoc.exists) {
          _log('❌ Employer document does NOT exist for UID: ${user.uid}');
          _log('   This is likely the main issue!');
          _log('   User may need to complete registration.');
          return;
        }

        _log('✅ Employer document EXISTS');
        final data = employerDoc.data()!;

        _log('   📄 Document fields:');
        for (final entry in data.entries) {
          _log('      ${entry.key}: ${entry.value}');
        }

        // 4. Validate document structure
        _log('\n4️⃣ VALIDATING DOCUMENT STRUCTURE');

        final requiredFields = ['approvalStatus', 'companyName', 'reason'];
        final missingFields = <String>[];

        for (final field in requiredFields) {
          if (!data.containsKey(field)) {
            missingFields.add(field);
          }
        }

        if (missingFields.isNotEmpty) {
          _log('❌ Missing required fields: ${missingFields.join(', ')}');
        } else {
          _log('✅ All required fields present');
        }

        // Check approvalStatus value
        final approvalStatus = data['approvalStatus'];
        final validStatuses = ['pending', 'approved', 'rejected'];
        if (approvalStatus == null || !validStatuses.contains(approvalStatus)) {
          _log('❌ Invalid approvalStatus: "$approvalStatus"');
          _log('   Valid values: ${validStatuses.join(', ')}');
        } else {
          _log('✅ approvalStatus is valid: "$approvalStatus"');
        }

        // Check for redundant fields
        if (data.containsKey('isApproved')) {
          _log('⚠️  Redundant field found: "isApproved" (should be removed)');
        }
      } catch (e) {
        _log('❌ Error accessing employer document: $e');
      }

      // 5. Test AuthService methods
      _log('\n5️⃣ TESTING AUTH SERVICE METHODS');
      try {
        final approvalStatus = await AuthService.getApprovalStatus();
        _log('✅ AuthService.getApprovalStatus() result:');
        for (final entry in approvalStatus.entries) {
          _log('   ${entry.key}: ${entry.value}');
        }

        final userData = await AuthService.getUserData();
        _log('✅ AuthService.getUserData() result:');
        if (userData != null) {
          for (final entry in userData.entries) {
            _log('   ${entry.key}: ${entry.value}');
          }
        } else {
          _log('   null (no user data found)');
        }
      } catch (e) {
        _log('❌ Error testing AuthService: $e');
      }

      // 6. Test real-time listener
      _log('\n6️⃣ TESTING REAL-TIME LISTENER');
      try {
        final stream = AuthService.getApprovalStatusStream();
        final subscription = stream.listen((snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data() as Map<String, dynamic>?;
            _log('✅ Real-time update received:');
            _log('   Document exists: ${snapshot.exists}');
            if (data != null) {
              _log('   approvalStatus: ${data['approvalStatus']}');
              _log('   companyName: ${data['companyName']}');
            }
          } else {
            _log('❌ Real-time listener: document does not exist');
          }
        });

        // Cancel after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          subscription.cancel();
          _log('✅ Real-time listener test completed');
        });
      } catch (e) {
        _log('❌ Error testing real-time listener: $e');
      }

      // 7. List all employers (for debugging)
      _log('\n7️⃣ CHECKING ALL EMPLOYERS IN DATABASE');
      try {
        final employersSnapshot = await FirebaseFirestore.instance
            .collection('employers')
            .limit(5) // Limit to avoid too much data
            .get();

        _log('✅ Found ${employersSnapshot.docs.length} employer documents:');
        for (final doc in employersSnapshot.docs) {
          final data = doc.data();
          _log('   📄 ${doc.id}:');
          _log('      Company: ${data['companyName'] ?? 'Unknown'}');
          _log('      Status: ${data['approvalStatus'] ?? 'No status'}');
          _log('      Email: ${data['email'] ?? 'No email'}');
        }
      } catch (e) {
        _log('❌ Error checking all employers: $e');
      }
    } catch (e) {
      _log('❌ CRITICAL ERROR: $e');
    } finally {
      setState(() {
        _isRunning = false;
      });
      _log('\n🏁 DIAGNOSTICS COMPLETED');
    }
  }

  Future<void> _createTestDocument() async {
    _log('\n🛠️ CREATING TEST EMPLOYER DOCUMENT...');

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _log('❌ No user signed in');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('employers')
          .doc(user.uid)
          .set({
            'companyName':
                'Test Company ${DateTime.now().millisecondsSinceEpoch}',
            'contactPerson': 'Test User',
            'email': user.email,
            'mobileNumber': '1234567890',
            'industryType': 'Technology',
            'state': 'Test State',
            'district': 'Test District',
            'uid': user.uid,
            'createdAt': FieldValue.serverTimestamp(),
            'emailVerified': true,
            'registrationComplete': true,
            'approvalStatus': 'pending',
            'approvedAt': null,
            'approvedBy': null,
            'reason': '',
          });

      _log('✅ Test employer document created successfully!');
      _log('   UID: ${user.uid}');
      _log('   Email: ${user.email}');
    } catch (e) {
      _log('❌ Error creating test document: $e');
    }
  }

  Future<void> _deleteTestDocument() async {
    _log('\n🗑️ DELETING EMPLOYER DOCUMENT...');

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _log('❌ No user signed in');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('employers')
          .doc(user.uid)
          .delete();

      _log('✅ Employer document deleted successfully!');
    } catch (e) {
      _log('❌ Error deleting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Debug Tool'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Firebase Connectivity & Data Diagnostic Tool',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _runDiagnostics,
                  icon: _isRunning
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(_isRunning ? 'Running...' : 'Run Diagnostics'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007BFF),
                    foregroundColor: Colors.white,
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: _createTestDocument,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Test Doc'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: _deleteTestDocument,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Doc'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _output.clear();
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade600),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _output.toString(),
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 12,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Tip: Check the console/debug output for additional details',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
