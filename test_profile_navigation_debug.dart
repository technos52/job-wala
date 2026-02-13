import 'package:flutter/material.dart';

/// Test script to debug profile navigation issue
///
/// Run this to test the profile navigation behavior and see debug output

void main() {
  runApp(const ProfileNavigationTestApp());
}

class ProfileNavigationTestApp extends StatelessWidget {
  const ProfileNavigationTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Navigation Test',
      home: const ProfileNavigationTest(),
    );
  }
}

class ProfileNavigationTest extends StatefulWidget {
  const ProfileNavigationTest({super.key});

  @override
  State<ProfileNavigationTest> createState() => _ProfileNavigationTestState();
}

class _ProfileNavigationTestState extends State<ProfileNavigationTest> {
  int _currentBottomNavIndex = 0;
  static const primaryBlue = Color(0xFF007BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Navigation Test'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Main content
          Positioned.fill(
            child: Builder(
              builder: (context) {
                debugPrint(
                  '🔍 Building main content for index: $_currentBottomNavIndex',
                );

                if (_currentBottomNavIndex == 0) {
                  debugPrint('🏠 Showing home page');
                  return _buildHomePage();
                } else {
                  debugPrint('👤 Showing profile page (overview, not edit)');
                  return _buildProfilePage();
                }
              },
            ),
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
                    icon: Icons.home_rounded,
                    label: 'Home',
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
          // DEBUG: Add logging to track navigation
          debugPrint('🔍 Bottom nav tapped: $label (index: $index)');
          debugPrint('🔍 Current index: $_currentBottomNavIndex');

          if (mounted) {
            final previousIndex = _currentBottomNavIndex;

            // DEBUG: Log state change
            debugPrint('🔄 Changing from index $previousIndex to $index');

            setState(() {
              _currentBottomNavIndex = index;
            });

            // DEBUG: Confirm state change
            debugPrint(
              '✅ State updated: _currentBottomNavIndex = $_currentBottomNavIndex',
            );

            if (index == 1) {
              debugPrint(
                '👤 Profile tab selected - should show profile overview',
              );
            }
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

  Widget _buildHomePage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Home Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('This is the home/jobs page'),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    // DEBUG: Log when profile page is built
    debugPrint('🔍 _buildProfilePage called');
    debugPrint('🔍 Should show profile overview, NOT EditProfileScreen');

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 100, // Space for bottom navigation
      ),
      child: Column(
        children: [
          // Profile Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryBlue, Color(0xFF0056CC)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Column(
              children: [
                // Profile Avatar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: primaryBlue),
                ),
                SizedBox(height: 16),

                // Name and Email
                Text(
                  'Test User',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'test@example.com',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Menu Items
          _buildProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () {
              // DEBUG: Log when Edit Profile is tapped
              debugPrint('🔍 Edit Profile menu item tapped');
              debugPrint('🔍 This should navigate to EditProfileScreen');

              // Show a dialog instead of navigating for testing
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Profile'),
                  content: const Text(
                    'This would navigate to EditProfileScreen',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          _buildProfileMenuItem(
            icon: Icons.work_outline,
            title: 'My Applications',
            subtitle: 'View your job applications',
            onTap: () {
              debugPrint('🔍 My Applications tapped');
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('My Applications'),
                  content: const Text('This would show applications'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          _buildProfileMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: () {
              debugPrint('🔍 Logout tapped');
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('This would log out the user'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primaryBlue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
