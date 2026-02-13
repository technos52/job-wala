import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'company_profile_screen.dart';
import 'help_support_screen.dart';
import 'about_us_screen.dart';

class EmployerProfileOverviewScreen extends StatefulWidget {
  const EmployerProfileOverviewScreen({super.key});

  @override
  State<EmployerProfileOverviewScreen> createState() =>
      _EmployerProfileOverviewScreenState();
}

class _EmployerProfileOverviewScreenState
    extends State<EmployerProfileOverviewScreen> {
  static const primaryBlue = Color(0xFF007BFF);

  String _companyName = '';
  String _email = '';
  String _approvalStatus = 'pending';

  @override
  void initState() {
    super.initState();
    _loadCompanyProfile();
  }

  Future<void> _loadCompanyProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        debugPrint('🔍 Loading company profile for user: ${user.uid}');

        final employerDoc = await FirebaseFirestore.instance
            .collection('employers')
            .doc(user.uid)
            .get();

        if (employerDoc.exists && mounted) {
          final data = employerDoc.data()!;
          setState(() {
            _companyName = data['companyName'] ?? 'Company';
            _email = user.email ?? '';
            _approvalStatus = data['approvalStatus'] ?? 'pending';
          });

          debugPrint('✅ Company profile loaded: $_companyName');
        } else {
          debugPrint('❌ Company document not found');
          if (mounted) {
            setState(() {
              _companyName = 'Company';
              _email = user.email ?? '';
            });
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading company profile: $e');
      if (mounted) {
        setState(() {
          _companyName = 'Company';
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    try {
      await AuthService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    } catch (e) {
      debugPrint('❌ Error logging out: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error logging out: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Blue Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryBlue, Color(0xFF0056CC)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'All Jobs Open',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome\n${_companyName.isNotEmpty ? _companyName : 'Company'}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          // Profile Content Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Company Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: primaryBlue.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.business,
                            size: 40,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Company Name
                        Text(
                          _companyName.isNotEmpty ? _companyName : 'Company',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // Email
                        Text(
                          _email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _approvalStatus == 'approved'
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _approvalStatus == 'approved'
                                  ? Colors.green.withValues(alpha: 0.3)
                                  : Colors.orange.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _approvalStatus == 'approved'
                                    ? Icons.check_circle
                                    : Icons.pending,
                                size: 16,
                                color: _approvalStatus == 'approved'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _approvalStatus == 'approved'
                                    ? 'Verified'
                                    : 'Pending Approval',
                                style: TextStyle(
                                  color: _approvalStatus == 'approved'
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Menu Items
                  _buildProfileMenuItem(
                    icon: Icons.business_outlined,
                    title: 'Company Profile',
                    onTap: () {
                      debugPrint('🔍 Company Profile tapped');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompanyProfileScreen(),
                        ),
                      ).then((_) {
                        // Refresh profile data when returning
                        _loadCompanyProfile();
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildProfileMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      debugPrint('🔍 Help & Support tapped');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpSupportScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildProfileMenuItem(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () {
                      debugPrint('🔍 About Us tapped');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutUsScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        debugPrint('🔍 Logout button tapped');
                        await _handleLogout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Extra bottom padding to avoid overlap with bottom navigation
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryBlue, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
