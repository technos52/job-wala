import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'welcome_screen.dart';

class EmployerStatusScreen extends StatefulWidget {
  const EmployerStatusScreen({super.key});

  @override
  State<EmployerStatusScreen> createState() => _EmployerStatusScreenState();
}

class _EmployerStatusScreenState extends State<EmployerStatusScreen> {
  bool _isLoading = true;
  String _status = '';
  String _error = '';
  Map<String, dynamic>? _employerData;

  @override
  void initState() {
    super.initState();
    _checkEmployerStatus();
  }

  Future<void> _checkEmployerStatus() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _error = 'No user signed in';
          _isLoading = false;
        });
        return;
      }

      print('🔍 Checking employer status for UID: ${user.uid}');

      // Check if employer document exists
      final docSnapshot = await FirebaseFirestore.instance
          .collection('employers')
          .doc(user.uid)
          .get();

      if (!docSnapshot.exists) {
        setState(() {
          _error = 'No employer document found for this user';
          _isLoading = false;
        });
        return;
      }

      final data = docSnapshot.data()!;
      final approvalStatus = data['approvalStatus'] as String? ?? 'unknown';
      final companyName = data['companyName'] as String? ?? 'Unknown Company';
      final reason = data['reason'] as String? ?? '';

      print('📄 Employer document found:');
      print('  - Company: $companyName');
      print('  - Status: $approvalStatus');
      print('  - Reason: $reason');
      print('  - All fields: ${data.keys.toList()}');

      setState(() {
        _employerData = data;
        _status = approvalStatus;
        _isLoading = false;
      });

      // Show appropriate status dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showStatusDialog();
      });
    } catch (e) {
      print('❌ Error checking employer status: $e');
      setState(() {
        _error = 'Error checking status: $e';
        _isLoading = false;
      });
    }
  }

  void _showStatusDialog() {
    if (_status == 'approved') {
      _showApprovalDialog();
    } else if (_status == 'rejected') {
      _showRejectionDialog();
    } else if (_status == 'pending') {
      _showPendingDialog();
    } else {
      _showUnknownStatusDialog();
    }
  }

  void _showApprovalDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '🎉 Congratulations!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.green,
              ),
            ),
          ],
        ),
        content: Text(
          'Your company "${_employerData?['companyName'] ?? 'Your Company'}" has been approved by our admin team!\n\nYou can now:\n• Post job openings\n• Manage applications\n• Access candidate profiles\n• Track hiring analytics',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(
                  context,
                ).pushReplacementNamed('/employer_dashboard');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Go to Dashboard',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectionDialog() {
    final reason = _employerData?['reason'] as String? ?? '';
    String message =
        'Unfortunately, your company registration has been rejected.';

    if (reason.isNotEmpty) {
      message =
          'Your registration was rejected for the following reason:\n\n"$reason"\n\nPlease address this issue and try registering again.';
    } else {
      message +=
          '\n\nPlease contact our support team for more information or try registering again with correct details.';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cancel, color: Colors.red, size: 50),
            ),
            const SizedBox(height: 16),
            const Text(
              'Application Rejected',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _signOut();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.pending, color: Colors.orange, size: 50),
            ),
            const SizedBox(height: 16),
            const Text(
              'Under Review',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        content: Text(
          'Your company "${_employerData?['companyName'] ?? 'Your Company'}" registration is currently under admin review.\n\nThis usually takes a few minutes. You will receive a notification once approved!',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _signOut();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Sign Out'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _checkEmployerStatus();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Refresh'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUnknownStatusDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.help_outline, color: Colors.grey, size: 50),
            SizedBox(height: 16),
            Text(
              'Status Unknown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        content: Text(
          'Unable to determine your approval status. Current status: "$_status"\n\nPlease contact support or try refreshing.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _signOut();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Sign Out'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _checkEmployerStatus();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Refresh'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await AuthService.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Title
                const Text(
                  'All Job Open',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF007BFF),
                    letterSpacing: 1.0,
                  ),
                ),

                const SizedBox(height: 40),

                if (_isLoading) ...[
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF007BFF),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Checking your employment status...',
                    style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                    textAlign: TextAlign.center,
                  ),
                ] else if (_error.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _error,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _signOut,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Sign Out'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _checkEmployerStatus,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007BFF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Retry'),
                        ),
                      ),
                    ],
                  ),
                ] else if (_employerData != null) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          _employerData!['companyName'] ?? 'Your Company',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _getStatusColor()),
                          ),
                          child: Text(
                            'Status: ${_status.toUpperCase()}',
                            style: TextStyle(
                              color: _getStatusColor(),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: _checkEmployerStatus,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Check Status'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BFF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (_status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
