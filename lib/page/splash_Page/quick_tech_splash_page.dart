import 'dart:async';
import 'dart:developer';

import '../../consts/consts.dart';

class QuickTechSplashPage extends StatefulWidget {
  const QuickTechSplashPage({super.key});

  @override
  State<QuickTechSplashPage> createState() => _QuickTechSplashPageState();
}

class _QuickTechSplashPageState extends State<QuickTechSplashPage> {
  CommonController? commonController;
  final box = GetStorage();

  String errorMessage = '';
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize controllers and storage safely
      commonController = Get.put(CommonController());

      // Wait until initial data fetching is completed
      await _fetchInitialData();

      // Navigate immediately after fetching is complete
      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      log('Splash initialization error: $e');

      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = 'Failed to initialize app: $e';
        });
      }
    }
  }

  Future<void> _fetchInitialData() async {
    try {
      if (commonController == null) return;

      await Future.wait([
        commonController!.fetchPropertyCategories(),
        commonController!.fetchDivisions(),
      ]);
    } catch (e) {
      log('Error fetching initial data: $e');
    }
  }

  void _navigateToNextScreen() {
    try {
      final token = box.read(StorageKeys.accessToken);
      debugPrint('Token: ${token.toString()}');

      if (token != null && token.toString() != "null") {
        Get.offAllNamed(AppRoutes.dashboard);
        debugPrint(
          "Selected Property ID: ${box.read(StorageKeys.selectedPropertyId)}",
        );
      } else {
        Get.offAllNamed(AppRoutes.chooseLoginType);
      }
    } catch (e) {
      log('Navigation error: $e');

      Get.offAllNamed(AppRoutes.chooseLoginType);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return ErrorBoundaryWidget(error: errorMessage);
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              300.verticalSpace,
              buildLogo(),
              130.heightBox,
              CircularProgressIndicator(color: mainColor),
              Spacer(),
              Text(
                'The Easiest Way to Rent Your Hotel | Home',
                style: QuickTechAppTextStyle.bodyText2().copyWith(
                  color: Colors.black.withValues(alpha: 0.6),
                ),
              ),

              50.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

/*import 'dart:async';
import 'dart:developer';

import 'package:renth_manager/controller/quick_tech_common_controller.dart';
import 'package:renth_manager/page/auth_page/quick_tech_login_page.dart';

import '../../consts/consts.dart';
import '../home/quick_tech_dashboard.dart';

class QuickTechSplashPage extends StatefulWidget {
  const QuickTechSplashPage({super.key});

  @override
  State<QuickTechSplashPage> createState() => _QuickTechSplashPageState();
}

class _QuickTechSplashPageState extends State<QuickTechSplashPage> {
  final CommonController commonController = Get.put(CommonController());
  var box = GetStorage();

  @override
  void initState() {
    super.initState();
    commonController.fetchPropertyCategories();
    commonController.fetchDivisions();
    log(box.read(token).toString());
    Timer(Duration(seconds: 3), () {
      box.read(token).toString() != "null"
          ? Get.offAll(() => QuickTechDashboard())
          : Get.offAll(() => QuickTechLoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png", scale: 5),
            20.heightBox,
            Text(
              "Welcome to Renth",
              style: GoogleFonts.yesteryear(
                fontSize: 30,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            20.heightBox,
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black38),
            ),
          ],
        ),
      ),
    );
  }
}
 */
