// Force red dot test - manually set the red dot to appear for testing
// This will help determine if the issue is with the logic or the UI rendering

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ForceRedDotTest()));
}

class ForceRedDotTest extends StatefulWidget {
  @override
  _ForceRedDotTestState createState() => _ForceRedDotTestState();
}

class _ForceRedDotTestState extends State<ForceRedDotTest> {
  bool _hasNewApplications = false;
  int _currentJobPageIndex = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Force Red Dot Test'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Control Panel
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              children: [
                Text(
                  'Red Dot Control Panel',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _hasNewApplications = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('FORCE RED DOT ON'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _hasNewApplications = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: Text('FORCE RED DOT OFF'),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Current Status: ${_hasNewApplications ? "RED DOT SHOULD SHOW" : "RED DOT SHOULD HIDE"}',
                ),
              ],
            ),
          ),

          // Tab Buttons (copied from employer dashboard)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
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
                  child: _buildJobTabButton(
                    'Manage Jobs',
                    Icons.work_outline,
                    1,
                  ),
                ),
              ],
            ),
          ),

          // Page Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentJobPageIndex = index;
                });
              },
              children: [
                Center(
                  child: Text('Post Job Page', style: TextStyle(fontSize: 24)),
                ),
                Center(
                  child: Text(
                    'Manage Jobs Page',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),

          // Debug Info
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DEBUG INFO:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('_hasNewApplications: $_hasNewApplications'),
                Text('_currentJobPageIndex: $_currentJobPageIndex'),
                Text(
                  'showRedDot condition: ${_currentJobPageIndex == 1 && _hasNewApplications}',
                ),
                SizedBox(height: 8),
                Text(
                  'EXPECTED BEHAVIOR:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('- Click "FORCE RED DOT ON" button'),
                Text('- Click "Manage Jobs" tab'),
                Text('- Red dot should appear next to the work icon'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTabButton(String title, IconData icon, int index) {
    final isSelected = _currentJobPageIndex == index;
    final showRedDot =
        index == 1 && _hasNewApplications; // Same logic as employer dashboard

    return InkWell(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.blue : Colors.grey.shade600,
                  size: 20,
                ),
                if (showRedDot)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.blue : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Instructions for testing:
// 1. Run this test app
// 2. Click "FORCE RED DOT ON" button
// 3. Click "Manage Jobs" tab
// 4. You should see a red dot next to the work icon
// 5. If you don't see it, there's a UI rendering issue
// 6. If you do see it, the issue is with the data logic in the main app
