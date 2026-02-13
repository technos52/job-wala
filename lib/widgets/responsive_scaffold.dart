import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final EdgeInsets? padding;
  final bool safeArea;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.padding,
    this.safeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget responsiveBody = body;

    // Add responsive padding if specified
    if (padding != null) {
      responsiveBody = Padding(padding: padding!, child: responsiveBody);
    }

    // Add safe area if needed
    if (safeArea) {
      responsiveBody = SafeArea(child: responsiveBody);
    }

    // Wrap in responsive container for larger screens
    if (!ResponsiveUtils.isMobile(context)) {
      responsiveBody = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveUtils.getMaxContentWidth(context),
          ),
          child: responsiveBody,
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: responsiveBody,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor ?? Colors.grey.shade50,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.width,
    this.height,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
      margin: margin ?? ResponsiveUtils.getResponsiveMargin(context),
      decoration: decoration,
      color: color,
      child: child,
    );
  }
}

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? elevation;
  final ShapeBorder? shape;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? ResponsiveUtils.getResponsiveElevation(context),
      color: color,
      margin: margin ?? ResponsiveUtils.getResponsiveMargin(context),
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(context, 12),
            ),
          ),
      child: Padding(
        padding: padding ?? ResponsiveUtils.getCardPadding(context),
        child: child,
      ),
    );
  }
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? baseFontSize;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.baseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveFontSize = baseFontSize != null
        ? ResponsiveUtils.getResponsiveFontSize(context, baseFontSize!)
        : null;

    return Text(
      text,
      style:
          style?.copyWith(fontSize: responsiveFontSize) ??
          TextStyle(fontSize: responsiveFontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class ResponsiveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final double? width;
  final double? height;

  const ResponsiveButton({
    super.key,
    required this.child,
    this.onPressed,
    this.style,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight =
        height ?? ResponsiveUtils.getResponsiveButtonHeight(context);

    return SizedBox(
      width: width,
      height: buttonHeight,
      child: ElevatedButton(onPressed: onPressed, style: style, child: child),
    );
  }
}

class ResponsiveFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool enabled;
  final bool readOnly;

  const ResponsiveFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxLines == 1
          ? ResponsiveUtils.getFormFieldHeight(context)
          : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getResponsiveBorderRadius(context, 12),
        ),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        maxLines: maxLines,
        enabled: enabled,
        readOnly: readOnly,
        style: TextStyle(
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
          fontWeight: FontWeight.w500,
          color: enabled ? const Color(0xFF1F2937) : Colors.grey.shade600,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getHorizontalSpacing(
              context,
              small: 12,
              medium: 16,
              large: 20,
            ),
            vertical: ResponsiveUtils.getVerticalSpacing(
              context,
              small: 12,
              medium: 16,
              large: 20,
            ),
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
          ),
          labelStyle: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class ResponsiveListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;

  const ResponsiveListView({
    super.key,
    required this.children,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding ?? ResponsiveUtils.getListPadding(context),
      children: children,
    );
  }
}

class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double? childAspectRatio;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final EdgeInsets? padding;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.childAspectRatio,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.padding,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveUtils.getResponsiveGridColumns(context);
    final spacing = ResponsiveUtils.getResponsiveSpacing(context, 16);

    return GridView.count(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding ?? ResponsiveUtils.getListPadding(context),
      crossAxisCount: columns,
      childAspectRatio: childAspectRatio ?? 1.0,
      mainAxisSpacing: mainAxisSpacing ?? spacing,
      crossAxisSpacing: crossAxisSpacing ?? spacing,
      children: children,
    );
  }
}

class ResponsiveBottomSheet extends StatelessWidget {
  final Widget child;
  final bool isScrollControlled;
  final bool enableDrag;
  final bool showDragHandle;

  const ResponsiveBottomSheet({
    super.key,
    required this.child,
    this.isScrollControlled = true,
    this.enableDrag = true,
    this.showDragHandle = true,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool showDragHandle = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      backgroundColor: Colors.transparent,
      builder: (context) => ResponsiveBottomSheet(
        isScrollControlled: isScrollControlled,
        enableDrag: enableDrag,
        showDragHandle: showDragHandle,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = ResponsiveUtils.getSafeAreaHeight(context) * 0.9;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        maxWidth: ResponsiveUtils.getResponsiveDialogWidth(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 20),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle)
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          Flexible(child: child),
        ],
      ),
    );
  }
}
