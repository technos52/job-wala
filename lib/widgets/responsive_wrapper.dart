import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

/// A wrapper widget that makes any child widget responsive
/// and prevents pixel overflow errors
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool enableSafeArea;
  final bool preventOverflow;
  final ScrollPhysics? scrollPhysics;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.padding,
    this.enableSafeArea = true,
    this.preventOverflow = true,
    this.scrollPhysics,
  });

  @override
  Widget build(BuildContext context) {
    Widget wrappedChild = child;

    // Add responsive padding
    if (padding != null) {
      wrappedChild = Padding(padding: padding!, child: wrappedChild);
    }

    // Prevent overflow by wrapping in SingleChildScrollView
    if (preventOverflow) {
      wrappedChild = SingleChildScrollView(
        physics: scrollPhysics ?? const ClampingScrollPhysics(),
        child: wrappedChild,
      );
    }

    // Add safe area
    if (enableSafeArea) {
      wrappedChild = SafeArea(child: wrappedChild);
    }

    // Add responsive constraints for larger screens
    if (!ResponsiveUtils.isMobile(context)) {
      wrappedChild = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveUtils.getMaxContentWidth(context),
          ),
          child: wrappedChild,
        ),
      );
    }

    return wrappedChild;
  }
}

/// A responsive column that prevents overflow
class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final EdgeInsets? padding;
  final bool scrollable;
  final ScrollPhysics? scrollPhysics;

  const ResponsiveColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.padding,
    this.scrollable = true,
    this.scrollPhysics,
  });

  @override
  Widget build(BuildContext context) {
    Widget column = Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );

    if (padding != null) {
      column = Padding(padding: padding!, child: column);
    }

    if (scrollable) {
      column = SingleChildScrollView(
        physics: scrollPhysics ?? const ClampingScrollPhysics(),
        child: column,
      );
    }

    return column;
  }
}

/// A responsive row that prevents overflow
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final EdgeInsets? padding;
  final bool scrollable;
  final ScrollPhysics? scrollPhysics;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.padding,
    this.scrollable = false,
    this.scrollPhysics,
  });

  @override
  Widget build(BuildContext context) {
    Widget row = Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );

    if (padding != null) {
      row = Padding(padding: padding!, child: row);
    }

    if (scrollable) {
      row = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: scrollPhysics ?? const ClampingScrollPhysics(),
        child: row,
      );
    }

    return row;
  }
}

/// A responsive flex widget that adapts to screen size
class ResponsiveFlex extends StatelessWidget {
  final List<Widget> children;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets? padding;
  final bool wrapOnSmallScreen;

  const ResponsiveFlex({
    super.key,
    required this.children,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding,
    this.wrapOnSmallScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget flex;

    // On small screens, wrap to column if specified
    if (wrapOnSmallScreen &&
        ResponsiveUtils.isMobile(context) &&
        direction == Axis.horizontal) {
      flex = Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      );
    } else {
      flex = Flex(
        direction: direction,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      );
    }

    if (padding != null) {
      flex = Padding(padding: padding!, child: flex);
    }

    return flex;
  }
}

/// A responsive sized box that adapts to screen size
class ResponsiveSizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  final double? mobileWidth;
  final double? mobileHeight;
  final double? tabletWidth;
  final double? tabletHeight;

  const ResponsiveSizedBox({
    super.key,
    this.width,
    this.height,
    this.child,
    this.mobileWidth,
    this.mobileHeight,
    this.tabletWidth,
    this.tabletHeight,
  });

  @override
  Widget build(BuildContext context) {
    double? responsiveWidth = width;
    double? responsiveHeight = height;

    if (ResponsiveUtils.isMobile(context)) {
      responsiveWidth = mobileWidth ?? width;
      responsiveHeight = mobileHeight ?? height;
    } else if (ResponsiveUtils.isTablet(context)) {
      responsiveWidth = tabletWidth ?? width;
      responsiveHeight = tabletHeight ?? height;
    }

    return SizedBox(
      width: responsiveWidth,
      height: responsiveHeight,
      child: child,
    );
  }
}

/// A responsive padding widget
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.padding,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets responsivePadding =
        padding ?? ResponsiveUtils.getResponsivePadding(context);

    if (ResponsiveUtils.isMobile(context) && mobilePadding != null) {
      responsivePadding = mobilePadding!;
    } else if (ResponsiveUtils.isTablet(context) && tabletPadding != null) {
      responsivePadding = tabletPadding!;
    } else if (ResponsiveUtils.isDesktop(context) && desktopPadding != null) {
      responsivePadding = desktopPadding!;
    }

    return Padding(padding: responsivePadding, child: child);
  }
}

/// A responsive margin widget
class ResponsiveMargin extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? mobileMargin;
  final EdgeInsets? tabletMargin;
  final EdgeInsets? desktopMargin;

  const ResponsiveMargin({
    super.key,
    required this.child,
    this.margin,
    this.mobileMargin,
    this.tabletMargin,
    this.desktopMargin,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets responsiveMargin =
        margin ?? ResponsiveUtils.getResponsiveMargin(context);

    if (ResponsiveUtils.isMobile(context) && mobileMargin != null) {
      responsiveMargin = mobileMargin!;
    } else if (ResponsiveUtils.isTablet(context) && tabletMargin != null) {
      responsiveMargin = tabletMargin!;
    } else if (ResponsiveUtils.isDesktop(context) && desktopMargin != null) {
      responsiveMargin = desktopMargin!;
    }

    return Container(margin: responsiveMargin, child: child);
  }
}

/// A responsive layout builder that provides different layouts for different screen sizes
class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (ResponsiveUtils.isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

/// A responsive safe area that adapts to different screen sizes
class ResponsiveSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final EdgeInsets? minimum;

  const ResponsiveSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.minimum,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      minimum: minimum ?? EdgeInsets.zero,
      child: child,
    );
  }
}

/// A responsive keyboard aware scroll view
class ResponsiveKeyboardAwareScrollView extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  const ResponsiveKeyboardAwareScrollView({
    super.key,
    required this.child,
    this.padding,
    this.physics,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      physics: physics ?? const ClampingScrollPhysics(),
      padding: (padding ?? EdgeInsets.zero).add(
        ResponsiveUtils.getKeyboardScrollPadding(context),
      ),
      child: child,
    );
  }
}
