import 'package:flutter/material.dart';

void main() {
  runApp(const TabHeaderResetFixApp());
}

class TabHeaderResetFixApp extends StatelessWidget {
  const TabHeaderResetFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab Header Reset Fix',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TabHeaderResetFixScreen(),
    );
  }
}

class TabHeaderResetFixScreen extends StatefulWidget {
  const TabHeaderResetFixScreen({super.key});

  @override
  State<TabHeaderResetFixScreen> createState() =>
      _TabHeaderResetFixScreenState();
}

class _TabHeaderResetFixScreenState extends State<TabHeaderResetFixScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab Header Reset Fix'),
        backgroundColor: Colors.blue.shade50,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎯 Tab Header Reset Issue Fixed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),

            // Exact Issue Identified
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔍 Exact Issue Identified:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('• User switches: Profile tab → Jobs tab'),
                  Text('• Content: Shows Post Job form (CORRECT)'),
                  Text(
                    '• Tab header: Remains on previously selected tab (INCORRECT)',
                  ),
                  Text('• Expected: Tab header should reset to "Post Job"'),
                  Text(
                    '• Problem: Tab state not reset when switching to Jobs tab',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Scenario Example
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📋 Scenario Example:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. User is on Jobs tab → Switches to "Manage Jobs"'),
                  Text('2. User switches to Profile tab'),
                  Text('3. User switches back to Jobs tab'),
                  Text('4. Content: Post Job form (correct)'),
                  Text(
                    '5. Tab header: Still shows "Manage Jobs" selected (wrong)',
                  ),
                  Text('6. Expected: Should show "Post Job" selected'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Root Cause
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🚨 Root Cause:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Bottom navigation only updated _currentBottomNavIndex',
                  ),
                  Text('• Did not reset _currentJobPageIndex to 0 (Post Job)'),
                  Text('• Tab header state persisted from previous session'),
                  Text('• PageController showed correct content (index 0)'),
                  Text('• But tab highlighting showed wrong tab'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Solution Applied
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✅ Solution Applied:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('• Added explicit tab reset in bottom navigation'),
                  Text('• When switching to Jobs tab (index 0):'),
                  Text('  - Set _currentJobPageIndex = 0 (Post Job)'),
                  Text('• Ensures tab header always resets to Post Job'),
                  Text('• Maintains consistency between content and tab UI'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Code Change
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                border: Border.all(color: Colors.purple.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💻 Code Change:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Bottom Navigation onTap:'),
                  Text(''),
                  Text('setState(() {'),
                  Text('  _currentBottomNavIndex = index;'),
                  Text(
                    '  // When switching to Jobs tab, reset to Post Job tab',
                  ),
                  Text('  if (index == 0) {'),
                  Text(
                    '    _currentJobPageIndex = 0; // Reset to Post Job tab',
                  ),
                  Text('  }'),
                  Text('});'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Expected Behavior
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                border: Border.all(color: Colors.teal.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎯 Expected Behavior Now:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '✅ Profile → Jobs: Shows Post Job content + Post Job tab',
                  ),
                  Text(
                    '✅ Tab header always resets to "Post Job" when switching',
                  ),
                  Text('✅ Content and tab header are always synchronized'),
                  Text('✅ No more "ghost" tab selections from previous state'),
                  Text(
                    '✅ Consistent behavior regardless of previous tab state',
                  ),
                  Text('✅ Users see expected tab highlighting'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Testing Scenario
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                border: Border.all(color: Colors.indigo.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🧪 Testing Scenario:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. Hot restart app'),
                  Text('2. Login as employer'),
                  Text('3. Go to Jobs tab → Switch to "Manage Jobs"'),
                  Text('4. Switch to Profile tab'),
                  Text('5. Switch back to Jobs tab'),
                  Text('6. Verify:'),
                  Text('   • Content shows Post Job form'),
                  Text('   • "Post Job" tab is highlighted (not Manage Jobs)'),
                  Text('7. Repeat test multiple times'),
                  Text('8. Try different tab combinations'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Why This Fix Works
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.cyan.shade50,
                border: Border.all(color: Colors.cyan.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚡ Why This Fix Works:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('• Explicit state reset on Jobs tab selection'),
                  Text('• Ensures _currentJobPageIndex matches PageController'),
                  Text(
                    '• Prevents tab state from persisting across navigation',
                  ),
                  Text('• Simple, targeted fix for specific issue'),
                  Text('• No complex timing or animation logic needed'),
                  Text('• Immediate state update in same setState call'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📋 Summary:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The issue was that when switching to the Jobs tab, the tab header remained on the previously selected job tab (like Manage Jobs) while the content correctly showed Post Job form. The fix explicitly resets the job page index to 0 (Post Job) whenever the user switches to the Jobs tab, ensuring the tab header always matches the displayed content.',
                    style: TextStyle(fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
