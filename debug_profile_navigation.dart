import 'package:flutter/material.dart';

/// Debug script to test profile navigation issue
///
/// This script helps identify why clicking the profile tab
/// might be leading directly to the update profile page
/// instead of showing the profile overview first.

void main() {
  print('🔍 Profile Navigation Debug Analysis');
  print('=====================================');

  print('\n📋 Expected Behavior:');
  print('1. Click Profile tab → Show profile overview page');
  print('2. Click "Edit Profile" menu item → Navigate to EditProfileScreen');

  print('\n🐛 Reported Issue:');
  print('- Clicking Profile tab directly goes to update profile page');

  print('\n🔍 Potential Causes:');
  print('1. _currentBottomNavIndex state not updating correctly');
  print('2. _buildProfilePage() not rendering properly');
  print('3. Automatic navigation triggered somewhere');
  print('4. Widget rebuild causing navigation');
  print('5. Navigation stack interference');

  print('\n🛠️ Debug Steps:');
  print('1. Add debug prints to _buildBottomNavItem onTap');
  print('2. Add debug prints to _buildProfilePage');
  print('3. Check if EditProfileScreen is being called automatically');
  print('4. Verify _currentBottomNavIndex value changes');
  print('5. Check for any Navigator.push calls in profile page');

  print('\n📝 Recommended Fixes:');
  print('1. Add debug logging to track navigation flow');
  print('2. Ensure proper state management');
  print('3. Check for any automatic navigation triggers');
  print('4. Verify widget lifecycle methods');
}

/// Debug version of the bottom navigation item with logging
class DebugBottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  const DebugBottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          print('🔍 DEBUG: Bottom nav item tapped');
          print('   - Label: $label');
          print('   - Index: $index');
          print('   - Current Index: $currentIndex');
          print('   - Is Selected: $isSelected');

          if (index == 1) {
            print('🎯 Profile tab tapped - should show profile overview');
          }

          onTap(index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
            Text(
              label,
              style: TextStyle(color: isSelected ? Colors.blue : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Debug version of profile page with logging
class DebugProfilePage extends StatelessWidget {
  const DebugProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    print('🔍 DEBUG: _buildProfilePage called');
    print('   - Should show profile overview, not edit screen');

    return SingleChildScrollView(
      child: Column(
        children: [
          const Text('Profile Overview Page'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              print('🔍 DEBUG: Edit Profile button tapped');
              print('   - Should navigate to EditProfileScreen');

              // This is where navigation to EditProfileScreen should happen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DebugEditProfileScreen(),
                ),
              );
            },
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}

/// Debug version of edit profile screen
class DebugEditProfileScreen extends StatelessWidget {
  const DebugEditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('🔍 DEBUG: EditProfileScreen opened');

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile Screen')),
    );
  }
}
