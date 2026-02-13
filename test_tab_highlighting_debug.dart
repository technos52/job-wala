import 'package:flutter/material.dart';

void main() {
  runApp(const TabHighlightingDebugApp());
}

class TabHighlightingDebugApp extends StatelessWidget {
  const TabHighlightingDebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab Highlighting Debug',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TabHighlightingDebugScreen(),
    );
  }
}

class TabHighlightingDebugScreen extends StatefulWidget {
  const TabHighlightingDebugScreen({super.key});

  @override
  State<TabHighlightingDebugScreen> createState() =>
      _TabHighlightingDebugScreenState();
}

class _TabHighlightingDebugScreenState
    extends State<TabHighlightingDebugScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab Highlighting Debug'),
        backgroundColor: Colors.blue.shade50,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🐛 Tab Highlighting Issue Debug',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),

            // Current Issue
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
                    '🚨 Current Issue:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('• Content: Shows Post Job form (CORRECT)'),
                  Text('• Tab UI: Shows "Manage Jobs" selected (INCORRECT)'),
                  Text('• Expected: "Post Job" tab should be highlighted'),
                  Text('• Problem: Tab highlighting doesn\'t match content'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Debug Information
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
                    '🔍 Debug Information:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Current State:'),
                  Text('• PageController(initialPage: 0) ✅'),
                  Text('• _currentJobPageIndex = 0 ✅'),
                  Text('• Tab buttons: Post Job (0), Manage Jobs (1) ✅'),
                  Text('• PageView children: [PostJob(0), ManageJobs(1)] ✅'),
                  Text('• isSelected = _currentJobPageIndex == index ✅'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Possible Causes
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
                    '🤔 Possible Causes:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. PageController position vs _currentJobPageIndex mismatch',
                  ),
                  Text('2. onPageChanged not firing during initialization'),
                  Text('3. Some code is setting _currentJobPageIndex to 1'),
                  Text('4. Tab highlighting logic is inverted'),
                  Text('5. Visual issue - wrong tab is styled as selected'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Debugging Steps
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
                    '🔧 Debugging Steps:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. Add debug prints to see actual values:'),
                  Text(
                    '   • print("_currentJobPageIndex: \$_currentJobPageIndex")',
                  ),
                  Text(
                    '   • print("PageController.page: \${_pageController.page}")',
                  ),
                  Text('2. Check onPageChanged callback:'),
                  Text('   • Add print in onPageChanged'),
                  Text('3. Check tab button isSelected logic:'),
                  Text('   • Add print in _buildJobTabButton'),
                  Text('4. Verify initialization order'),
                  Text('5. Check if any setState is overriding values'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Fix Attempt
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
                    '⚡ Quick Fix Attempt:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('If _currentJobPageIndex is somehow getting set to 1:'),
                  Text(
                    '• Force it to 0 in initState after PageController init',
                  ),
                  Text('• Add explicit setState in initState'),
                  Text('• Ensure onPageChanged fires with correct value'),
                  SizedBox(height: 8),
                  Text('Code to add in initState:'),
                  Text('WidgetsBinding.instance.addPostFrameCallback((_) {'),
                  Text('  setState(() { _currentJobPageIndex = 0; });'),
                  Text('});'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Testing Instructions
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
                    '🧪 Testing Instructions:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. Hot restart app'),
                  Text('2. Login as employer'),
                  Text('3. Go to Jobs tab'),
                  Text('4. Check console for debug prints'),
                  Text('5. Verify which tab is highlighted'),
                  Text('6. Verify which content is shown'),
                  Text('7. Try switching tabs manually'),
                  Text('8. Check if highlighting follows correctly'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Expected vs Actual
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
                    '📊 Expected vs Actual:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Expected:'),
                  Text('• _currentJobPageIndex = 0'),
                  Text('• "Post Job" tab highlighted'),
                  Text('• Post Job form content'),
                  SizedBox(height: 8),
                  Text('Actual:'),
                  Text('• _currentJobPageIndex = ? (need to debug)'),
                  Text('• "Manage Jobs" tab highlighted'),
                  Text('• Post Job form content'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
