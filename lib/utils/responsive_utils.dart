import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get safe area height (excluding status bar and navigation bar)
  static double getSafeAreaHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return getScreenWidth(context) < mobileBreakpoint;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return getScreenWidth(context) >= tabletBreakpoint;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    } else {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  /// Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(8);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(12);
    } else {
      return const EdgeInsets.all(16);
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    final screenWidth = getScreenWidth(context);

    if (screenWidth < 360) {
      // Very small screens
      return baseFontSize * 0.85;
    } else if (screenWidth < 400) {
      // Small screens
      return baseFontSize * 0.9;
    } else if (screenWidth > 600) {
      // Large screens
      return baseFontSize * 1.1;
    } else {
      // Normal screens
      return baseFontSize;
    }
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(
    BuildContext context,
    double baseIconSize,
  ) {
    final screenWidth = getScreenWidth(context);

    if (screenWidth < 360) {
      return baseIconSize * 0.8;
    } else if (screenWidth > 600) {
      return baseIconSize * 1.2;
    } else {
      return baseIconSize;
    }
  }

  /// Get responsive spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    if (isMobile(context)) {
      return baseSpacing;
    } else if (isTablet(context)) {
      return baseSpacing * 1.2;
    } else {
      return baseSpacing * 1.5;
    }
  }

  /// Get responsive container width
  static double getResponsiveContainerWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);

    if (isMobile(context)) {
      return screenWidth - 32; // 16px padding on each side
    } else if (isTablet(context)) {
      return screenWidth * 0.8; // 80% of screen width
    } else {
      return 800; // Fixed max width for desktop
    }
  }

  /// Get responsive card elevation
  static double getResponsiveElevation(BuildContext context) {
    if (isMobile(context)) {
      return 2;
    } else {
      return 4;
    }
  }

  /// Get responsive border radius
  static double getResponsiveBorderRadius(
    BuildContext context,
    double baseRadius,
  ) {
    if (isMobile(context)) {
      return baseRadius;
    } else {
      return baseRadius * 1.2;
    }
  }

  /// Get responsive button height
  static double getResponsiveButtonHeight(BuildContext context) {
    if (isMobile(context)) {
      return 48;
    } else if (isTablet(context)) {
      return 52;
    } else {
      return 56;
    }
  }

  /// Get responsive app bar height
  static double getResponsiveAppBarHeight(BuildContext context) {
    if (isMobile(context)) {
      return kToolbarHeight;
    } else {
      return kToolbarHeight + 8;
    }
  }

  /// Get responsive bottom navigation height
  static double getResponsiveBottomNavHeight(BuildContext context) {
    if (isMobile(context)) {
      return 70;
    } else {
      return 80;
    }
  }

  /// Get responsive grid columns
  static int getResponsiveGridColumns(BuildContext context) {
    final screenWidth = getScreenWidth(context);

    if (screenWidth < 600) {
      return 1; // Single column on mobile
    } else if (screenWidth < 900) {
      return 2; // Two columns on tablet
    } else {
      return 3; // Three columns on desktop
    }
  }

  /// Get responsive list tile height
  static double getResponsiveListTileHeight(BuildContext context) {
    if (isMobile(context)) {
      return 72;
    } else {
      return 80;
    }
  }

  /// Get responsive dialog width
  static double getResponsiveDialogWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);

    if (isMobile(context)) {
      return screenWidth * 0.9;
    } else if (isTablet(context)) {
      return 500;
    } else {
      return 600;
    }
  }

  /// Get responsive text scale factor
  static double getResponsiveTextScaleFactor(BuildContext context) {
    final screenWidth = getScreenWidth(context);

    if (screenWidth < 360) {
      return 0.9;
    } else if (screenWidth > 600) {
      return 1.1;
    } else {
      return 1.0;
    }
  }

  /// Get device orientation
  static Orientation getOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return getOrientation(context) == Orientation.landscape;
  }

  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return getOrientation(context) == Orientation.portrait;
  }

  /// Get responsive max width for content
  static double getMaxContentWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);

    if (isMobile(context)) {
      return screenWidth;
    } else if (isTablet(context)) {
      return 700;
    } else {
      return 900;
    }
  }

  /// Get responsive horizontal padding for content
  static double getContentHorizontalPadding(BuildContext context) {
    final screenWidth = getScreenWidth(context);

    if (screenWidth < 360) {
      return 12;
    } else if (screenWidth < 600) {
      return 16;
    } else if (screenWidth < 900) {
      return 24;
    } else {
      return 32;
    }
  }

  /// Get responsive vertical spacing
  static double getVerticalSpacing(
    BuildContext context, {
    double small = 8,
    double medium = 16,
    double large = 24,
  }) {
    if (isMobile(context)) {
      return small;
    } else if (isTablet(context)) {
      return medium;
    } else {
      return large;
    }
  }

  /// Get responsive horizontal spacing
  static double getHorizontalSpacing(
    BuildContext context, {
    double small = 8,
    double medium = 16,
    double large = 24,
  }) {
    if (isMobile(context)) {
      return small;
    } else if (isTablet(context)) {
      return medium;
    } else {
      return large;
    }
  }

  /// Get responsive form field height
  static double getFormFieldHeight(BuildContext context) {
    if (isMobile(context)) {
      return 56;
    } else {
      return 60;
    }
  }

  /// Get responsive card padding
  static EdgeInsets getCardPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(20);
    } else {
      return const EdgeInsets.all(24);
    }
  }

  /// Get responsive list padding
  static EdgeInsets getListPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getContentHorizontalPadding(context),
      vertical: getVerticalSpacing(context),
    );
  }

  /// Get responsive safe area padding for bottom
  static double getBottomSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Get responsive keyboard height
  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// Check if keyboard is visible
  static bool isKeyboardVisible(BuildContext context) {
    return getKeyboardHeight(context) > 0;
  }

  /// Get responsive scroll padding for keyboard
  static EdgeInsets getKeyboardScrollPadding(BuildContext context) {
    final keyboardHeight = getKeyboardHeight(context);
    return EdgeInsets.only(bottom: keyboardHeight);
  }
}
