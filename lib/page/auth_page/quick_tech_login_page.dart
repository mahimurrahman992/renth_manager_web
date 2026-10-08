import 'package:renth_manager/consts/consts.dart';


class QuickTechLoginPage extends StatefulWidget {
  final LoginType loginType;
  const QuickTechLoginPage({super.key, required this.loginType});

  @override
  State<QuickTechLoginPage> createState() => _QuickTechLoginPageState();
}

class _QuickTechLoginPageState extends State<QuickTechLoginPage> {
  final AuthController controller = locator.get<AuthController>();
  final commonController = locator.get<CommonController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (width < 600) {
            return SignInMobileView(
              loginType: widget.loginType,
              controller: controller,
              commonController: commonController,
            );
          } else if (width < 1024) {
            return SignInTabletView(
              loginType: widget.loginType,
              controller: controller,
              commonController: commonController,
            );
          } else {
            return SignInDesktopView(
              loginType: widget.loginType,
              controller: controller,
              commonController: commonController,
            );
          }
        },
      ),
    );
  }
}

// ======================= MOBILE =======================
class SignInMobileView extends StatelessWidget {
  final LoginType loginType;
  final AuthController controller;
  final CommonController commonController;

  const SignInMobileView({
    super.key,
    required this.loginType,
    required this.controller,
    required this.commonController,
  });

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
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 24.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  16.verticalSpace,
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SignInLogoBadge(),
                        20.verticalSpace,
                        Text(
                          'Welcome Back! 👋',
                          style: QuickTechAppTextStyle.displaySmall(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32.r)),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign In to Your Account',
                        style: QuickTechAppTextStyle.headline2(),
                      ),
                      6.verticalSpace,
                      Text(
                        'Login to your account using your credentials',
                        style: QuickTechAppTextStyle.subtitle(),
                      ),
                      28.verticalSpace,
                      SignInForm(
                        loginType: loginType,
                        controller: controller,
                        commonController: commonController,
                      ),
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
class SignInTabletView extends StatelessWidget {
  final LoginType loginType;
  final AuthController controller;
  final CommonController commonController;

  const SignInTabletView({
    super.key,
    required this.loginType,
    required this.controller,
    required this.commonController,
  });

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
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: SignInBackButton(light: false),
                  ),
                  8.verticalSpace,
                  Center(child: buildLogo()),
                  24.verticalSpace,
                  Text(
                    'Welcome Back! 👋',
                    textAlign: TextAlign.center,
                    style: QuickTechAppTextStyle.displaySmall(),
                  ),
                  8.verticalSpace,
                  Text(
                    'Login to your account using your credentials',
                    textAlign: TextAlign.center,
                    style: QuickTechAppTextStyle.subtitle(),
                  ),
                  32.verticalSpace,
                  SignInForm(
                    loginType: loginType,
                    controller: controller,
                    commonController: commonController,
                  ),
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
class SignInDesktopView extends StatelessWidget {
  final LoginType loginType;
  final AuthController controller;
  final CommonController commonController;

  const SignInDesktopView({
    super.key,
    required this.loginType,
    required this.controller,
    required this.commonController,
  });

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
                      const SignInLogoBadge(),
                      40.verticalSpace,
                      Text(
                        'Welcome Back!\nGlad to see you again.',
                        style: QuickTechAppTextStyle.displayLarge(),
                      ),
                      20.verticalSpace,
                      Text(
                        "Sign in to manage your properties on Bangladesh's largest Smart Property network.",
                        style: QuickTechAppTextStyle.bodyText1(),
                      ),
                      48.verticalSpace,
                      const SignInFeatureRow(
                        icon: Icons.schedule_rounded,
                        title: 'Save Time',
                        subtitle: 'Manage everything in one place.',
                      ),
                      20.verticalSpace,
                      const SignInFeatureRow(
                        icon: Icons.work_outline_rounded,
                        title: 'Work Less',
                        subtitle: 'Smart tools handle the routine tasks.',
                      ),
                      20.verticalSpace,
                      const SignInFeatureRow(
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

        // RIGHT: sign in form
        Expanded(
          flex: 5,
          child: Container(
            color: cardColor,
            child: Stack(
              children: [
                const Positioned(
                  top: 24,
                  left: 24,
                  child: SignInBackButton(light: false),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign In',
                            style: QuickTechAppTextStyle.displayMedium(),
                          ),
                          8.verticalSpace,
                          Text(
                            'Login to your account using your credentials',
                            style: QuickTechAppTextStyle.subtitleLarge(),
                          ),
                          36.verticalSpace,
                          SignInForm(
                            loginType: loginType,
                            controller: controller,
                            commonController: commonController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ======================= FORM =======================
class SignInForm extends StatelessWidget {
  final LoginType loginType;
  final AuthController controller;
  final CommonController commonController;

  const SignInForm({
    super.key,
    required this.loginType,
    required this.controller,
    required this.commonController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (loginType == LoginType.phone)
          phoneTextField(
            controller: controller.phone,
            hint: "📱 Phone Number",
            countryCode: '+88',
            isSuffix: true,
            suIcon: Icons.call,
            suppixtap: () {},
          )
        else
          emailTextField(
            controller: controller.email,
            hint: "Email Address",
            isSuffix: true,
            suIcon: Icons.email,
            suffixTap: () {},
          ),
        20.verticalSpace,
        Obx(
          () => customTextField(
            hint: "🔒 Password",
            isSuffix: true,
            isVisible: controller.isShowPassword.value,
            controller: controller.password,
            suIcon: controller.isShowPassword.value
                ? Icons.visibility_off
                : Icons.visibility,
            suppixtap: () {
              controller.isShowPassword.value =
                  !controller.isShowPassword.value;
            },
          ),
        ),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    value: controller.isRememberMe.value,
                    onChanged: (v) {
                      controller.isRememberMe.value = v!;
                    },
                    side: const BorderSide(color: black),
                  ),
                ),
                Text('Remember me', style: QuickTechAppTextStyle.bodyText2()),
              ],
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(AppRoutes.forgetPassword);
              },
              child: Text(
                'Forgot Password?',
                style: QuickTechAppTextStyle.bodyUnderline(),
              ),
            ),
          ],
        ),
        20.verticalSpace,
        Obx(
          () => customButton2(
            title: 'Sign In',
            onTap: () {
              if (controller.isLoading.value) return;
              controller.login(loginType);
            },
            isLoading: controller.isLoading.value,
          ),
        ),
        24.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: QuickTechAppTextStyle.bodyText2(),
            ),
            5.horizontalSpace,
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  await commonController.fetchPropertyCategories();
                  Get.toNamed(AppRoutes.register,
                      arguments: {'loginType': loginType});
                },
                child: Text(
                  "Sign up",
                  style: QuickTechAppTextStyle.bodyLink(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ======================= COMMON WIDGETS =======================
class SignInBackButton extends StatelessWidget {
  final bool light;

  const SignInBackButton({super.key, required this.light});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: light ? white.withValues(alpha: 0.25) : backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.sp,
            color:  textColor,
          ),
        ),
      ),
    );
  }
}

class SignInLogoBadge extends StatelessWidget {
  const SignInLogoBadge({super.key});

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

class SignInFeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SignInFeatureRow({
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
            color: white.withValues(alpha: 0.18),
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