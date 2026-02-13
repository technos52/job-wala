import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'welcome_screen.dart';

class ApprovalPendingScreen extends StatefulWidget {
  final String companyName;
  final String approvalStatus;

  const ApprovalPendingScreen({
    super.key,
    required this.companyName,
    required this.approvalStatus,
  });

  @override
  State<ApprovalPendingScreen> createState() => _ApprovalPendingScreenState();
}

class _ApprovalPendingScreenState extends State<ApprovalPendingScreen> {
  late Stream<DocumentSnapshot> _approvalStream;
  bool _hasShownApprovalNotification = false;

  @override
  void initState() {
    super.initState();
    _approvalStream = AuthService.getApprovalStatusStream();
  }

  void _showApprovalNotification() {
    if (!_hasShownApprovalNotification) {
      _hasShownApprovalNotification = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Congratulations! Your company has been approved by admin.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );

      // Navigate to employer dashboard after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/employer_dashboard');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _approvalStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final approvalStatus =
              data?['approvalStatus'] as String? ?? 'pending';

          // If approved, show notification and navigate
          if (approvalStatus == 'approved') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showApprovalNotification();
            });
          }
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await AuthService.signOut();
                              if (mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const WelcomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.logout,
                              color: Color(0xFF007BFF),
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'All Job Open',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF007BFF),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(
                            width: 48,
                          ), // Balance the logout button
                        ],
                      ),

                      const SizedBox(height: 60),

                      // Main Content
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Status Icon
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.approvalStatus == 'rejected'
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : Colors.orange.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: widget.approvalStatus == 'rejected'
                                      ? Colors.red
                                      : Colors.orange,
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                widget.approvalStatus == 'rejected'
                                    ? Icons.cancel_outlined
                                    : Icons.hourglass_empty,
                                size: 60,
                                color: widget.approvalStatus == 'rejected'
                                    ? Colors.red
                                    : Colors.orange,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Title
                            Text(
                              widget.approvalStatus == 'rejected'
                                  ? 'Application Rejected'
                                  : 'Pending Admin Approval',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1F2937),
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 16),

                            // Company Name
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF007BFF,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFF007BFF,
                                  ).withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                widget.companyName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF007BFF),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Description
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    widget.approvalStatus == 'rejected'
                                        ? Icons.info_outline
                                        : Icons.admin_panel_settings_outlined,
                                    size: 32,
                                    color: widget.approvalStatus == 'rejected'
                                        ? Colors.red
                                        : const Color(0xFF007BFF),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    widget.approvalStatus == 'rejected'
                                        ? 'Your company registration has been rejected by the admin. Please contact support for more information or try registering again with correct details.'
                                        : 'Your company details are under admin review. Once approved, you will receive a notification and gain access to the employer dashboard. You can post jobs and manage applications after approval.',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF6B7280),
                                      height: 1.6,
                                      letterSpacing: 0.3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Action Buttons
                            if (widget.approvalStatus == 'rejected')
                              Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await AuthService.signOut();
                                        if (mounted) {
                                          Navigator.of(
                                            context,
                                          ).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const WelcomeScreen(),
                                            ),
                                            (route) => false,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF007BFF,
                                        ),
                                        foregroundColor: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Register Again',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  OutlinedButton(
                                    onPressed: () {
                                      // Contact support functionality
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Contact support at support@alljobopen.com',
                                          ),
                                          backgroundColor: Color(0xFF007BFF),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF007BFF),
                                      side: const BorderSide(
                                        color: Color(0xFF007BFF),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Contact Support',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            if (widget.approvalStatus == 'pending')
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () async {
                                        await AuthService.signOut();
                                        if (mounted) {
                                          Navigator.of(
                                            context,
                                          ).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const WelcomeScreen(),
                                            ),
                                            (route) => false,
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.logout_outlined),
                                      label: const Text('Sign Out'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(
                                          0xFF6B7280,
                                        ),
                                        side: const BorderSide(
                                          color: Color(0xFF6B7280),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Refresh'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF007BFF,
                                        ),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
