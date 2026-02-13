import 'package:flutter/material.dart';

/// Test to verify employer dashboard jobs page is working correctly
/// This will help identify if the issue is with the jobs page content or navigation

void main() {
  runApp(const TestEmployerDashboardApp());
}

class TestEmployerDashboardApp extends StatelessWidget {
  const TestEmployerDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employer Dashboard Test',
      home: const TestEmployerDashboard(),
    );
  }
}

class TestEmployerDashboard extends StatefulWidget {
  const TestEmployerDashboard({super.key});

  @override
  State<TestEmployerDashboard> createState() => _TestEmployerDashboardState();
}

class _TestEmployerDashboardState extends State<TestEmployerDashboard> {
  int _currentBottomNavIndex = 0;
  static const primaryBlue = Color(0xFF007BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          // Main content
          Builder(
            builder: (context) {
              debugPrint(
                '🔍 Building employer main content for index: $_currentBottomNavIndex',
              );

              if (_currentBottomNavIndex == 0) {
                debugPrint('🏠 Showing jobs page');
                return _buildJobsPage();
              } else {
                debugPrint('👤 Showing profile overview page');
                return _buildProfilePage();
              }
            },
          ),

          // Bottom navigation
          Positioned(
            left: 40,
            right: 40,
            bottom: 20,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.1),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomNavItem(
                    icon: Icons.work_rounded,
                    label: 'Jobs',
                    index: 0,
                  ),
                  _buildBottomNavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    index: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentBottomNavIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          debugPrint('🔍 Employer bottom nav tapped: $label (index: $index)');
          debugPrint('🔍 Current index: $_currentBottomNavIndex');

          setState(() {
            _currentBottomNavIndex = index;
          });

          debugPrint('✅ Employer nav updated: $_currentBottomNavIndex');
          if (index == 1) {
            debugPrint(
              '👤 Profile tab selected - should show profile overview',
            );
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 26,
                color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobsPage() {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [primaryBlue, Color(0xFF0056CC)]),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'All Jobs Open',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome\\nTest Company',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),

        // Tab buttons
        Container(
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: _buildJobTabButton(
                  'Post Job',
                  Icons.add_circle_outline,
                  0,
                ),
              ),
              Expanded(
                child: _buildJobTabButton('Manage Jobs', Icons.list_alt, 1),
              ),
            ],
          ),
        ),

        // Content area
        Expanded(
          child: Container(
            color: Colors.white,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Jobs Management',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Post new jobs and manage existing ones',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJobTabButton(String title, IconData icon, int index) {
    final isSelected = index == 0; // Default to first tab

    return InkWell(
      onTap: () {
        debugPrint('🔍 Job tab tapped: $title');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title tab tapped')));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? primaryBlue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryBlue : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? primaryBlue : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    return Container(
      color: Colors.grey[50],
      child: Column(
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Jobs Open',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Welcome\\nTest Company',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          // Profile Content
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
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        // Company Icon
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFFE3F2FD),
                          child: Icon(
                            Icons.business,
                            size: 40,
                            color: primaryBlue,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Company Name
                        Text(
                          'Test Company',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),

                        // Email
                        Text(
                          'test@company.com',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),

                        // Verified Badge
                        _VerifiedBadge(),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Menu Items
                  _ProfileMenuItem(
                    icon: Icons.business_outlined,
                    title: 'Company Profile',
                  ),
                  SizedBox(height: 12),
                  _ProfileMenuItem(
                    icon: Icons.star_outline,
                    title: 'Subscription',
                  ),
                  SizedBox(height: 12),
                  _ProfileMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                  ),
                  SizedBox(height: 12),
                  _ProfileMenuItem(icon: Icons.info_outline, title: 'About Us'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green),
          SizedBox(width: 6),
          Text(
            'Verified',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ProfileMenuItem({required this.icon, required this.title});

  static const primaryBlue = Color(0xFF007BFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            color: primaryBlue.withOpacity(0.1),
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
        onTap: () {
          debugPrint('🔍 $title tapped');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$title tapped')));
        },
      ),
    );
  }
}
