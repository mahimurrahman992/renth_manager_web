import 'package:flutter/foundation.dart' show kIsWeb;
import '../../consts/consts.dart';
import '../../widgets/google_sign_in_button/google_web_button.dart';


class QuickTechChooseLoginTypeScreen extends StatelessWidget {
  const QuickTechChooseLoginTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (width < 600) {
            return LoginMobileView(authController: authController);
          } else if (width < 1024) {
            return LoginTabletView(authController: authController);
          } else {
            return LoginDesktopView(authController: authController);
          }
        },
      ),
    );
  }
}

// ======================= MOBILE =======================
class LoginMobileView extends StatelessWidget {
  final AuthController authController;

  const LoginMobileView({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [mainColor, mainColor.withValues(alpha: 0.75)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoginLogoBadge(),
                    24.verticalSpace,
                    Text(
                      'Welcome to Renth',
                      style: QuickTechAppTextStyle.displaySmall(),
                    ),
                    Text(
                      'Partner Mobile App',
                      style: QuickTechAppTextStyle.headline3(),
                    ),
                    12.verticalSpace,
                    Text(
                      "Join Bangladesh's largest network of Smart Properties",
                      style: QuickTechAppTextStyle.bodyText3(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 16.h),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32.r)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Sign in to continue',
                        style: QuickTechAppTextStyle.headline2(),
                      ),
                      6.verticalSpace,
                      Text(
                        'Save Time. Work less. Earn more.',
                        style: QuickTechAppTextStyle.subtitle(),
                      ),
                      28.verticalSpace,
                      LoginAuthButton(
                        icon: Icons.email_outlined,
                        title: 'Continue with Email',
                        filled: true,
                        onTap: () => Get.toNamed(AppRoutes.login,
                            arguments: LoginType.email),
                      ),
                      14.verticalSpace,
                      LoginAuthButton(
                        icon: Icons.phone_android_outlined,
                        title: 'Continue with Phone',
                        filled: false,
                        onTap: () => Get.toNamed(AppRoutes.login,
                            arguments: LoginType.phone),
                      ),
                      20.verticalSpace,
                      LoginGoogleButton(authController: authController),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================= TABLET =======================
class LoginTabletView extends StatelessWidget {
  final AuthController authController;

  const LoginTabletView({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [mainColor, mainColor.withValues(alpha: 0.7)],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32.w),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 44.h),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: [
                  BoxShadow(
                    color: black.withValues(alpha: 0.15),
                    blurRadius: 50,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: buildLogo()),
                  28.verticalSpace,
                  Text(
                    'Welcome to Renth',
                    textAlign: TextAlign.center,
                    style: QuickTechAppTextStyle.displaySmall(),
                  ),
                  4.verticalSpace,
                  Text(
                    'Partner App',
                    textAlign: TextAlign.center,
                    style: QuickTechAppTextStyle.headline4(),
                  ),
                  14.verticalSpace,
                  Text(
                    "Join Bangladesh's largest network of Smart Properties.\nSave Time. Work less. Earn more.",
                    textAlign: TextAlign.center,
                    style: QuickTechAppTextStyle.bodyText3(),
                  ),
                  36.verticalSpace,
                  LoginAuthButton(
                    icon: Icons.email_outlined,
                    title: 'Continue with Email',
                    filled: true,
                    onTap: () => Get.toNamed(AppRoutes.login,
                        arguments: LoginType.email),
                  ),
                  14.verticalSpace,
                  LoginAuthButton(
                    icon: Icons.phone_android_outlined,
                    title: 'Continue with Phone',
                    filled: false,
                    onTap: () => Get.toNamed(AppRoutes.login,
                        arguments: LoginType.phone),
                  ),
                  20.verticalSpace,
                  LoginGoogleButton(authController: authController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ======================= DESKTOP =======================
class LoginDesktopView extends StatelessWidget {
  final AuthController authController;

  const LoginDesktopView({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // LEFT: brand panel
        Expanded(
          flex: 6,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [mainColor, mainColor.withValues(alpha: 0.7)],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LoginLogoBadge(),
                      40.verticalSpace,
                      Text(
                        'Welcome to Renth\nPartner App',
                        style: QuickTechAppTextStyle.displayLarge(),
                      ),
                      20.verticalSpace,
                      Text(
                        "Join Bangladesh's largest network of Smart Properties.",
                        style: QuickTechAppTextStyle.bodyText1(),
                      ),
                      48.verticalSpace,
                      const LoginFeatureRow(
                        icon: Icons.schedule_rounded,
                        title: 'Save Time',
                        subtitle: 'Manage everything in one place.',
                      ),
                      20.verticalSpace,
                      const LoginFeatureRow(
                        icon: Icons.work_outline_rounded,
                        title: 'Work Less',
                        subtitle: 'Smart tools handle the routine tasks.',
                      ),
                      20.verticalSpace,
                      const LoginFeatureRow(
                        icon: Icons.trending_up_rounded,
                        title: 'Earn More',
                        subtitle: 'Grow your income with a trusted network.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // RIGHT: login form
        Expanded(
          flex: 5,
          child: Container(
            color: cardColor,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Get started',
                        style: QuickTechAppTextStyle.displayMedium(),
                      ),
                      8.verticalSpace,
                      Text(
                        'Choose how you want to continue',
                        style: QuickTechAppTextStyle.subtitleLarge(),
                      ),
                      36.verticalSpace,
                      LoginAuthButton(
                        icon: Icons.email_outlined,
                        title: 'Continue with Email',
                        filled: true,
                        onTap: () => Get.toNamed(AppRoutes.login,
                            arguments: LoginType.email),
                      ),
                      14.verticalSpace,
                      LoginAuthButton(
                        icon: Icons.phone_android_outlined,
                        title: 'Continue with Phone',
                        filled: false,
                        onTap: () => Get.toNamed(AppRoutes.login,
                            arguments: LoginType.phone),
                      ),
                      20.verticalSpace,
                      LoginGoogleButton(authController: authController),
                      32.verticalSpace,
                      Text(
                        'By continuing, you agree to our Terms of Service and Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: QuickTechAppTextStyle.caption(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ======================= COMMON WIDGETS =======================
class LoginLogoBadge extends StatelessWidget {
  const LoginLogoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: buildLogo(),
    );
  }
}

class LoginFeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const LoginFeatureRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: textColor.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: textColor, size: 22.sp),
        ),
        16.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: QuickTechAppTextStyle.bodyBold1()),
              Text(subtitle, style: QuickTechAppTextStyle.bodyText3()),
            ],
          ),
        ),
      ],
    );
  }
}

class LoginAuthButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool filled;
  final VoidCallback onTap;
  final Color? iconColor;

  const LoginAuthButton({
    super.key,
    required this.icon,
    required this.title,
    required this.filled,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: filled ? mainColor : cardColor,
        borderRadius: BorderRadius.circular(14.r),
        elevation: filled ? 4 : 0,
        shadowColor: mainColor.withValues(alpha: 0.4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: filled
                  ? null
                  : Border.all(color: borderColor, width: 1.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: iconColor ?? (filled ? textColor : mainColor),
                ),
                12.horizontalSpace,
                Text(title, style: QuickTechAppTextStyle.button()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginGoogleButton extends StatelessWidget {
  final AuthController authController;

  const LoginGoogleButton({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.isLoading.value) {
        return const Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        );
      }
      if (kIsWeb) {
        return Center(
          child: buildGoogleWebSignInButton(),
        );
      }
      return LoginAuthButton(
        icon: Ionicons.logo_google,
        title: 'Sign in with Google',
        filled: false,
        iconColor: Colors.red,
        onTap: () => authController.googleLogin(),
      );
    });
  }
}