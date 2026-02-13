// Debug helper to understand navigation issues

import 'package:flutter/material.dart';

class NavigationDebugHelper {
  static void debugNavigation(
    String action, {
    required int currentBottomNavIndex,
    required int currentJobPageIndex,
    required bool pageControllerHasClients,
    required bool mounted,
  }) {
    print('=== Navigation Debug ===');
    print('Action: $action');
    print('Current Bottom Nav Index: $currentBottomNavIndex');
    print('Current Job Page Index: $currentJobPageIndex');
    print('PageController has clients: $pageControllerHasClients');
    print('Widget mounted: $mounted');
    print('========================');
  }
}

// Common navigation issues and solutions:
/*
1. PageController not initialized:
   - Check if _pageController = PageController() is called in initState()
   - Ensure PageController is not null

2. PageController has no clients:
   - This happens when trying to use PageController before PageView is built
   - Use WidgetsBinding.instance.addPostFrameCallback() to wait for build

3. Widget not mounted:
   - Check if (mounted) before calling setState or PageController methods
   - This prevents errors when widget is disposed

4. Timing issues:
   - Use Future.delayed() or addPostFrameCallback() for proper timing
   - Ensure state changes happen before PageController operations

5. State not updating:
   - Make sure setState() is called to trigger rebuild
   - Check if the correct variables are being updated

Recommended navigation pattern:
```dart
onTap: () {
  // 1. Update state immediately
  setState(() {
    _currentBottomNavIndex = newIndex;
    _currentJobPageIndex = targetPageIndex;
  });
  
  // 2. Navigate after frame is built
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted && _pageController.hasClients) {
      _pageController.animateToPage(
        targetPageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  });
}
```
*/
