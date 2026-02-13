import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import 'welcome_screen.dart';
import 'premium_upgrade_dialog.dart';

class EmployerVerificationScreen extends StatefulWidget {
  final String companyName;

  const EmployerVerificationScreen({super.key, required this.companyName});

  @override
  State<EmployerVerificationScreen> createState() =>
      _EmployerVerificationScreenState();
}

class _EmployerVerificationScreenState extends State<EmployerVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _fadeController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  bool _isListening = false;
  late Stream<DocumentSnapshot> _approvalStream;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startListening();
    // Check status immediately on init to show rejection dialog if needed
    _checkInitialStatus();
  }

  Future<void> _checkInitialStatus() async {
    // Wait a bit for the widget to be fully built
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;

    try {
      final approvalData = await AuthService.getApprovalStatus();
      final status = approvalData['approvalStatus'] as String? ?? 'pending';
      final normalizedStatus = status.toLowerCase();

      if (normalizedStatus == 'rejected' || normalizedStatus == 'declined') {
        // Show rejection dialog immediately
        _showApprovalRejected();
      }
    } catch (e) {
      debugPrint('Error checking initial status: $e');
    }
  }

  void _setupAnimations() {
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _bounceController.forward();
    _fadeController.forward();
  }

  void _startListening() {
    if (!_isListening) {
      _isListening = true;
      _approvalStream = AuthService.getApprovalStatusStream();
      _listenForApproval();
    }
  }

  void _listenForApproval() {
    _approvalStream.listen((snapshot) {
      if (snapshot.exists && mounted) {
        final data = snapshot.data() as Map<String, dynamic>?;
        final approvalStatus = data?['approvalStatus'] as String? ?? 'pending';
        // Normalize status: treat 'declined' the same as 'rejected'
        final normalizedStatus = approvalStatus.toLowerCase();

        if (normalizedStatus == 'approved') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _showApprovalSuccess();
            }
          });
        } else if (normalizedStatus == 'rejected' ||
            normalizedStatus == 'declined') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _showApprovalRejected();
            }
          });
        }
      }
    });
  }

  void _showApprovalSuccess() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(scale: animation, child: child);
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success Icon with Animation - Matching waiting screen style
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.green.withOpacity(0.1),
                                Colors.green.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(color: Colors.green, width: 3),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Title - Matching waiting screen style
                  const Text(
                    '🎉 Congratulations!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.1),
                          Colors.green.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'Application Approved',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description - Matching waiting screen style
                  const Text(
                    'Your company has been verified and approved by our admin team. You can now start posting job openings and managing applications!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Action Button - Matching waiting screen style
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacementNamed('/post_job');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 5,
                        shadowColor: Colors.green.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Start Posting Jobs',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteAccountAndData() async {
    BuildContext? dialogContext;

    try {
      final user = AuthService.currentUser;
      if (user == null) {
        // If no user, just navigate to welcome screen
        if (mounted) {
          await AuthService.signOut();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false,
          );
        }
        return;
      }

      final firestore = FirebaseFirestore.instance;
      final userId = user.uid;

      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogCtx) {
            dialogContext = dialogCtx;
            return const Center(child: CircularProgressIndicator());
          },
        );
      }

      // Delete employer document from Firestore
      await firestore.collection('employers').doc(userId).delete();

      // Delete all job postings by this employer
      final jobsQuery = await firestore
          .collection('jobs')
          .where('employerId', isEqualTo: userId)
          .get();

      for (final doc in jobsQuery.docs) {
        await doc.reference.delete();
      }

      // Delete all applications for this employer's jobs
      final applicationsQuery = await firestore
          .collection('applications')
          .where('employerId', isEqualTo: userId)
          .get();

      for (final doc in applicationsQuery.docs) {
        await doc.reference.delete();
      }

      // Sign out first to clear auth state
      await AuthService.signOut();

      // Delete the Firebase Auth user (after sign out to avoid issues)
      try {
        await user.delete();
      } catch (e) {
        debugPrint('Error deleting auth user (may already be deleted): $e');
      }

      // Close loading dialog explicitly
      if (mounted && dialogContext != null) {
        Navigator.of(dialogContext!).pop();
      }

      // Navigate to welcome screen and clear all routes
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Error deleting account: $e');

      // Close loading dialog if open
      if (mounted && dialogContext != null) {
        Navigator.of(dialogContext!).pop();
      }

      // Still sign out and navigate to welcome screen even if deletion fails
      await AuthService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (route) => false,
        );
      }
    }
  }

  void _showApprovalRejected() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(scale: animation, child: child);
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Rejection Icon with Animation - Matching waiting screen style
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.red.withOpacity(0.1),
                                Colors.red.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(color: Colors.red, width: 3),
                          ),
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Title - Matching waiting screen style
                  const Text(
                    'Application Declined',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Status Badge - Matching waiting screen style
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withOpacity(0.1),
                          Colors.red.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'Registration Declined',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Rejection Reason - Matching waiting screen style
                  StreamBuilder<DocumentSnapshot>(
                    stream: AuthService.getApprovalStatusStream(),
                    builder: (context, snapshot) {
                      String rejectionText =
                          'Unfortunately, your company registration has been declined.\n\nYour account and all associated data will be permanently deleted.';

                      if (snapshot.hasData && snapshot.data!.exists) {
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>?;
                        final reason = data?['reason'] as String? ?? '';

                        if (reason.isNotEmpty) {
                          rejectionText =
                              'Reason: "$reason"\n\nYour account and all associated data will be permanently deleted.';
                        }
                      }

                      return Text(
                        rejectionText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          height: 1.4,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Action Button - Only one button: Ok - Matching waiting screen style
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteAccountAndData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 5,
                        shadowColor: Colors.red.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Ok',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
  void dispose() {
    _bounceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _signOut,
                      icon: const Icon(Icons.logout, color: Color(0xFF007BFF)),
                    ),
                    const Spacer(),
                    const Text(
                      'All Job Open',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF007BFF),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // Balance the logout button
                  ],
                ),
              ),

              // Main Content - Use minimum height instead of Expanded
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      32, // Account for padding
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Welcome Animation
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _bounceAnimation,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF007BFF).withOpacity(0.1),
                                const Color(0xFF007BFF).withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(
                              color: const Color(0xFF007BFF),
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.verified_user,
                            size: 50,
                            color: Color(0xFF007BFF),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Welcome Title
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        '🎉 Welcome to All Job Open!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2937),
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Company Name
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF007BFF).withOpacity(0.1),
                              const Color(0xFF007BFF).withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF007BFF).withOpacity(0.3),
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
                    ),

                    const SizedBox(height: 20),

                    // Main Message Card
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Tea Cup Icon
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '☕',
                                  style: TextStyle(fontSize: 32),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Title
                            const Text(
                              'Grab a Cup of Tea! ☕',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1F2937),
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 12),

                            // Description
                            RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                  height: 1.4,
                                  letterSpacing: 0.2,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        'Your company data is currently being ',
                                  ),
                                  TextSpan(
                                    text: 'verified by our admin team',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF007BFF),
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '. Once approved, you\'ll be able to:\n\n'
                                        '✅ Post job openings\n'
                                        '✅ Manage applications\n'
                                        '✅ Access profiles\n'
                                        '✅ Track analytics\n\n'
                                        'This usually takes a few minutes.',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          // Check Status Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // Show loading indicator
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text('Checking approval status...'),
                                      ],
                                    ),
                                    backgroundColor: Color(0xFF007BFF),
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                                // Check approval status
                                try {
                                  final approvalData =
                                      await AuthService.getApprovalStatus();
                                  final status =
                                      approvalData['approvalStatus']
                                          as String? ??
                                      'pending';
                                  final normalizedStatus = status.toLowerCase();

                                  if (normalizedStatus == 'approved') {
                                    // Status changed to approved, navigate to dashboard
                                    if (mounted) {
                                      Navigator.of(
                                        context,
                                      ).pushReplacementNamed(
                                        '/employer_dashboard',
                                      );
                                    }
                                  } else {
                                    // Still pending or rejected
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            normalizedStatus == 'pending'
                                                ? 'Status: Still under review. Please wait a bit longer.'
                                                : 'Status: $status. Please contact support if needed.',
                                          ),
                                          backgroundColor:
                                              normalizedStatus == 'pending'
                                              ? Colors.orange
                                              : Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Error checking status. Please try again.',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Check Status'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF007BFF),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Sign Out Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _signOut,
                              icon: const Icon(Icons.logout_outlined),
                              label: const Text('Sign Out'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF6B7280),
                                side: const BorderSide(
                                  color: Color(0xFF6B7280),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
