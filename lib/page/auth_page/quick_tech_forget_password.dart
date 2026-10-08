import 'package:renth_manager/consts/consts.dart';

class QuickTechForgetPassword extends StatefulWidget {
  const QuickTechForgetPassword({super.key});

  @override
  State<QuickTechForgetPassword> createState() =>
      _QuickTechForgetPasswordState();
}

class _QuickTechForgetPasswordState extends State<QuickTechForgetPassword> {
  final AuthController controller = Get.find();
  final TextEditingController mobileController = TextEditingController();

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (width < 600) {
            return ForgetPasswordMobileView(
              controller: controller,
              mobileController: mobileController,
            );
          } else if (width < 1024) {
            return ForgetPasswordTabletView(
              controller: controller,
              mobileController: mobileController,
            );
          } else {
            return ForgetPasswordDesktopView(
              controller: controller,
              mobileController: mobileController,
            );
          }
        },
      ),
    );
  }
}

// ======================= MOBILE =======================
class ForgetPasswordMobileView extends StatelessWidget {
  final AuthController controller;
  final TextEditingController mobileController;

  const ForgetPasswordMobileView({
    super.key,
    required this.controller,
    required this.mobileController,
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
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 24.w, 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SignInBackButton(light: true),
                  16.verticalSpace,
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SignInLogoBadge(),
                        20.verticalSpace,
                        Text(
                          'Forgot Password? 🔑',
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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32.r),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reset Password',
                        style: QuickTechAppTextStyle.headline2(),
                      ),
                      6.verticalSpace,
                      Text(
                        'Enter your mobile number to receive a reset code.',
                        style: QuickTechAppTextStyle.subtitle(),
                      ),
                      28.verticalSpace,
                      ForgetPasswordForm(
                        controller: controller,
                        mobileController: mobileController,
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
class ForgetPasswordTabletView extends StatelessWidget {
  final AuthController controller;
  final TextEditingController mobileController;

  const ForgetPasswordTabletView({
    super.key,
    required this.controller,
    required this.mobileController,
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
                    'Forgot Password? 🔑',
                    textAlign: TextAlign.center,
                    style: QuickTechAppTextStyle.displaySmall(),
                  ),
                  8.verticalSpace,
                  Text(
                    'Enter your mobile number to receive a reset code.',
                    textAlign: TextAlign.center,
                    style: QuickTechAppTextStyle.subtitle(),
                  ),
                  32.verticalSpace,
                  ForgetPasswordForm(
                    controller: controller,
                    mobileController: mobileController,
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
class ForgetPasswordDesktopView extends StatelessWidget {
  final AuthController controller;
  final TextEditingController mobileController;

  const ForgetPasswordDesktopView({
    super.key,
    required this.controller,
    required this.mobileController,
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
                        'Forgot your\npassword?',
                        style: QuickTechAppTextStyle.displayLarge(),
                      ),
                      20.verticalSpace,
                      Text(
                        "No worries. We'll help you get back into your account in a few quick steps.",
                        style: QuickTechAppTextStyle.bodyText1(),
                      ),
                      48.verticalSpace,
                      const SignInFeatureRow(
                        icon: Icons.phone_android_rounded,
                        title: 'Enter your number',
                        subtitle:
                            'Use the mobile number linked to your account.',
                      ),
                      20.verticalSpace,
                      const SignInFeatureRow(
                        icon: Icons.sms_outlined,
                        title: 'Get a reset code',
                        subtitle: 'We will send a code to your phone.',
                      ),
                      20.verticalSpace,
                      const SignInFeatureRow(
                        icon: Icons.lock_reset_rounded,
                        title: 'Set a new password',
                        subtitle: 'Choose a strong password to stay secure.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // RIGHT: form
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 32.h,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reset Password',
                            style: QuickTechAppTextStyle.displayMedium(),
                          ),
                          8.verticalSpace,
                          Text(
                            'Enter your mobile number to receive a reset code.',
                            style: QuickTechAppTextStyle.subtitleLarge(),
                          ),
                          36.verticalSpace,
                          ForgetPasswordForm(
                            controller: controller,
                            mobileController: mobileController,
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
class ForgetPasswordForm extends StatelessWidget {
  final AuthController controller;
  final TextEditingController mobileController;

  const ForgetPasswordForm({
    super.key,
    required this.controller,
    required this.mobileController,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        phoneTextField(controller: mobileController, hint: "📱 Mobile Number"),
        14.verticalSpace,

        // Info note
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: infoColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: infoColor, size: 18.sp),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  'A reset code will be sent to this number.',
                  style: QuickTechAppTextStyle.caption(),
                ),
              ),
            ],
          ),
        ),
        28.verticalSpace,

        Obx(
          () => customButton2(
            title: "Send Code",
            isLoading: controller.isLoading.value,
            onTap: () async {
              final mobile = mobileController.text.trim();

              if (mobile.isEmpty) {
                showErrorToast("Please enter your mobile number");
                return;
              }

              await controller.forgotPassword(mobile);

              if (!controller.isLoading.value) {
                Get.toNamed(AppRoutes.resetPassword, arguments: {'mobile': mobile});
          
              
              }
            },
          ),
        ),
        24.verticalSpace,

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Remember your password?",
              style: QuickTechAppTextStyle.bodyText2(),
            ),
            5.horizontalSpace,
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Text("Sign In", style: QuickTechAppTextStyle.bodyLink()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
