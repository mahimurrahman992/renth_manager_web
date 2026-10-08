import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/services.dart';

import 'package:renth_manager/widgets/custom_responsive_helper.dart';

import 'consts/consts.dart' hide DeviceType;

// Global key for ScaffoldMessenger
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void _hideBottomBar() {
  if (kIsWeb) return;
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );
}

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      setUp();

      // Show only the top status bar, hide the bottom nav bar (mobile only)
      _hideBottomBar();

      FlutterError.onError = (FlutterErrorDetails details) {
        log('Flutter Error: ${details.exception}');
        log('Stack Trace: ${details.stack}');
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        log('Platform Error: $error');
        log('Stack Trace: $stack');
        return true;
      };

      try {
        await Firebase.initializeApp();
        await NotificationService().initialize();
      } catch (e) {
        log('Firebase initialization failed: $e');
      }

      try {
        await GetStorage.init();
      } catch (e) {
        log('GetStorage initialization failed: $e');
      }

      try {
        Get.put(AppLifecycleManager());
      } catch (e) {
        log('AppLifecycleManager initialization failed: $e');
      }

      runApp(const MyApp());
    },
    (error, stack) {
      log('Uncaught Error: $error');
      log('Stack Trace: $stack');
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (!kIsWeb) {
      // Whenever the user swipes and reveals the bottom bar, hide it again.
      SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
        if (systemOverlaysAreVisible) {
          await Future.delayed(const Duration(milliseconds: 800));
          _hideBottomBar();
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Reapply after app resumes from background (Android resets bars).
    if (state == AppLifecycleState.resumed) {
      _hideBottomBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: Builder(
        builder: (context) {
          try {
            final ThemeController themeController = Get.put(ThemeController());

            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              scrollBehavior: AppScrollBehavior(),
              defaultTransition: Transition.fadeIn,
              transitionDuration: const Duration(milliseconds: 400),
              scaffoldMessengerKey: scaffoldMessengerKey,
              theme: themeController.currentTheme,
              initialRoute: AppPages.initial,
              getPages: AppPages.pages,
              builder: (context, widget) {
                ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                  return ErrorBoundaryWidget(
                    error: errorDetails.exception.toString(),
                  );
                };

                final mediaQuery = MediaQuery.of(context);

                // Pick design size by current screen width
                final DeviceType deviceType = Responsive.typeOf(
                  mediaQuery.size.width,
                );
                final Size designSize = Responsive.designSizeFor(deviceType);

                // Re-initialise ScreenUtil on every size change so
                // .w .h .sp .r always match the active breakpoint
                ScreenUtil.init(
                  context,
                  designSize: designSize,
                  minTextAdapt: true,
                  splitScreenMode: true,
                );

                return MediaQuery(
                  data: mediaQuery.copyWith(
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  child: GetBuilder<ThemeController>(
                    builder: (ctrl) {
                      return widget ?? const SizedBox.shrink();
                    },
                  ),
                );
              },
            );
          } catch (e) {
            log('Error building app: $e');

            return GetMaterialApp(
              scaffoldMessengerKey: scaffoldMessengerKey,
              builder: (context, widget) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: widget ?? const SizedBox.shrink(),
                );
              },
              home: ErrorBoundaryWidget(error: 'App initialization failed: $e'),
            );
          }
        },
      ),
    );
  }
}
