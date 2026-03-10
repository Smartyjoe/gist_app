import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  // Screen dimensions
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  
  // Device type checks
  bool get isSmallMobile => width < 375;
  bool get isMobile => width < 768;
  bool get isTablet => width >= 768 && width < 1024;
  bool get isDesktop => width >= 1024;

  // Responsive values based on screen width
  double get horizontalPadding {
    if (isSmallMobile) return 12.0;
    if (isMobile) return 16.0;
    if (isTablet) return 24.0;
    return 32.0;
  }

  double get verticalPadding {
    if (isSmallMobile) return 12.0;
    if (isMobile) return 16.0;
    if (isTablet) return 20.0;
    return 24.0;
  }

  // Responsive text sizes
  double get titleSize {
    if (isSmallMobile) return 18.0;
    if (isMobile) return 20.0;
    if (isTablet) return 24.0;
    return 28.0;
  }

  double get bodySize {
    if (isSmallMobile) return 14.0;
    if (isMobile) return 16.0;
    if (isTablet) return 18.0;
    return 20.0;
  }

  double get captionSize {
    if (isSmallMobile) return 11.0;
    if (isMobile) return 12.0;
    if (isTablet) return 14.0;
    return 16.0;
  }

  // Responsive spacing with clamping to prevent overflow
  double sp(double size) {
    double scaledSize;
    if (isSmallMobile) {
      scaledSize = size * 0.85;
    } else if (isMobile) {
      scaledSize = size;
    } else if (isTablet) {
      scaledSize = size * 1.1;
    } else {
      scaledSize = size * 1.2;
    }
    // Clamp to prevent extreme sizes
    return scaledSize.clamp(size * 0.7, size * 1.5);
  }

  // Responsive width percentage
  double wp(double percentage) => width * (percentage / 100);

  // Responsive height percentage
  double hp(double percentage) => height * (percentage / 100);

  // Safe area insets
  EdgeInsets get safeAreaInsets => MediaQuery.of(context).padding;
  
  // Bottom navigation bar height
  double get bottomNavHeight => 60.0 + safeAreaInsets.bottom;

  // App bar height
  double get appBarHeight => kToolbarHeight + safeAreaInsets.top;
  
  // Text scale factor with overflow prevention
  double get textScaleFactor {
    final mediaQuery = MediaQuery.of(context);
    // Clamp text scale factor to prevent overflow
    return mediaQuery.textScaleFactor.clamp(0.8, 1.3);
  }
  
  // Responsive spacing helper with overflow prevention
  double spacing(double baseSize) {
    if (isSmallMobile) return baseSize * 0.8;
    if (isMobile) return baseSize;
    if (isTablet) return baseSize * 1.2;
    return baseSize * 1.4;
  }
  
  // Get responsive font size with constraints
  double fontSize(double baseSize) {
    return sp(baseSize).clamp(10.0, 30.0);
  }
}

// Extension for easy access
extension ResponsiveExtension on BuildContext {
  Responsive get responsive => Responsive(this);
}

// Responsive builder widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Responsive responsive) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, Responsive(context));
  }
}

// Responsive value selector
T responsiveValue<T>({
  required BuildContext context,
  required T mobile,
  T? tablet,
  T? desktop,
}) {
  final responsive = Responsive(context);
  if (responsive.isDesktop && desktop != null) return desktop;
  if (responsive.isTablet && tablet != null) return tablet;
  return mobile;
}
