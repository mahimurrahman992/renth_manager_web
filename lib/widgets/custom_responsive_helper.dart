// ---------------------------------------------------------------------------
// Responsive helpers
// ---------------------------------------------------------------------------
import 'dart:ui';

import 'package:renth_manager/consts/consts.dart';

enum DeviceType { mobile, tablet, desktop }

class Responsive {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  static const Size mobileDesign = Size(393, 852);
  static const Size tabletDesign = Size(820, 1180);
  static const Size desktopDesign = Size(1440, 900);

  static DeviceType typeOf(double width) {
    if (width < mobileBreakpoint) return DeviceType.mobile;
    if (width < tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  static Size designSizeFor(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return mobileDesign;
      case DeviceType.tablet:
        return tabletDesign;
      case DeviceType.desktop:
        return desktopDesign;
    }
  }

  static bool isMobile(BuildContext context) =>
      typeOf(MediaQuery.of(context).size.width) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      typeOf(MediaQuery.of(context).size.width) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      typeOf(MediaQuery.of(context).size.width) == DeviceType.desktop;
}

// Allows mouse / trackpad drag scrolling on web & desktop
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}