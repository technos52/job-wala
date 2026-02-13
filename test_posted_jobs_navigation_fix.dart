import 'package:flutter/material.dart';

void main() {
  runApp(const PostedJobsNavigationFixApp());
}

class PostedJobsNavigationFixApp extends StatelessWidget {
  const PostedJobsNavigationFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posted Jobs Navigation Fix Test',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const PostedJobsNavigationFixScreen(),
    );
  }
}

class PostedJobsNavigationFixScreen extends StatefulWidget {
  const PostedJobsNavigationFixScreen({super.key});

  @override
  State<PostedJobsNavigationFixScreen> createState() =>
      _PostedJobsNavigationFixScreenState();
}

class _PostedJobsNavigationFixScreenState
    extends State<PostedJobsNavigationFixScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posted Jobs Navigation Fix'),
        backgroundColor: Colors.blue.shade50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Posted Jobs Button Navigation Fixed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),

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
                    '✅ Problem Fixed:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The "Posted Jobs" button in the profile menu now correctly navigates to the "Manage Jobs" tab instead of the "Post Job" tab.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Changes Made:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            _buildChange(
              '1. Updated navigation to switch to Jobs tab (bottom nav index 0)',
            ),
            _buildChange(
              '2. Added PageController navigation to Manage Jobs (page index 1)',
            ),
            _buildChange('3. Updated _currentJobPageIndex state to 1'),
            _buildChange(
              '4. Added proper animation and curve for smooth transition',
            ),

            const SizedBox(height: 20),

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
                    'Navigation Flow:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. User clicks "Posted Jobs" in profile menu'),
                  Text('2. App switches to Jobs tab (bottom navigation)'),
                  Text(
                    '3. App navigates to "Manage Jobs" page within Jobs tab',
                  ),
                  Text('4. User sees their posted jobs list for management'),
                ],
              ),
            ),

            const SizedBox(height: 20),

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
                    'To Test the Fix:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. Hot restart the app (Ctrl+Shift+F5)'),
                  Text('2. Login as an employer'),
                  Text('3. Go to employer dashboard'),
                  Text('4. Open the profile menu (tap profile icon)'),
                  Text('5. Click "Posted Jobs"'),
                  Text(
                    '6. Should navigate to "Manage Jobs" tab, not "Post Job"',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

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
                    'Technical Implementation:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('• setState() updates both navigation indices'),
                  Text(
                    '• PageController.animateToPage() for smooth transition',
                  ),
                  Text('• Proper mounted check for safety'),
                  Text('• 300ms animation with easeInOut curve'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChange(String change) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(change, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
