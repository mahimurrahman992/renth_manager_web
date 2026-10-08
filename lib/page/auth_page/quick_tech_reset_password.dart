import 'package:renth_manager/consts/consts.dart';


class QuickTechResetPassword extends StatefulWidget {
  final String mobile;

  const QuickTechResetPassword({super.key, required this.mobile});

  @override
  State<QuickTechResetPassword> createState() => _QuickTechResetPasswordState();
}

class _QuickTechResetPasswordState extends State<QuickTechResetPassword> {
  final AuthController authcontroller = locator.get<AuthController>();

  final tokenController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isShowPassword = false.obs;
  final RxBool isShowConfirmPassword = false.obs;

  @override
  void dispose() {
    tokenController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Form ekbar banano hoy, tinta layout e same form use hoy
    final form = ResetPasswordForm(
      mobile: widget.mobile,
      authcontroller: authcontroller,
      tokenController: tokenController,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
      isShowPassword: isShowPassword,
      isShowConfirmPassword: isShowConfirmPassword,
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (width < 600) {
            return ResetPasswordMobileView(mobile: widget.mobile, form: form);
          } else if (width < 1024) {
            return ResetPasswordTabletView(mobile: widget.mobile, form: form);
          } else {
            return ResetPasswordDesktopView(mobile: widget.mobile, form: form);
          }
        },
      ),
    );
  }
}

// ======================= MOBILE =======================
class ResetPasswordMobileView extends StatelessWidget {
  final String mobile;
  final Widget form;

  const ResetPasswordMobileView({
    super.key,
    required this.mobile,
    required this.form,
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
              padding: EdgeInsets.fromLTRB(0.w, 12.h, 24.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SignInBackButton(light: true),
                  16.verticalSpace,
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Text(
                      'Reset Password 🔐',
                      style: QuickTechAppTextStyle.displaySmall(),
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
                  padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set New Password',
                        style: QuickTechAppTextStyle.headline2(),
                      ),
                      6.verticalSpace,
                      Text(
                        'Enter the code sent to $mobile and choose a new password.',
                        style: QuickTechAppTextStyle.subtitle(),
                      ),
                      28.verticalSpace,
                      form,
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
class ResetPasswordTabletView extends StatelessWidget {
  final String mobile;
  final Widget form;

  const ResetPasswordTabletView({
    super.key,
    required this.mobile,
    required this.form,
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
                    'Reset Password 🔐',
                    textAlign: TextAlign.center,
                    style: QuickTechAppTextStyle.displaySmall(),
                  ),
                  8.verticalSpace,
                  Text(
                    'Enter the code sent to $mobile and choose a new password.',
                    textAlign: TextAlign.center,
                    style: QuickTechAppTextStyle.subtitle(),
                  ),
                  32.verticalSpace,
                  form,
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
class ResetPasswordDesktopView extends StatelessWidget {
  final String mobile;
  final Widget form;

  const ResetPasswordDesktopView({
    super.key,
    required this.mobile,
    required this.form,
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
                        'Create a new\npassword',
                        style: QuickTechAppTextStyle.displayLarge(),
                      ),
                      20.verticalSpace,
                      Text(
                        "You're almost there. Just two quick steps to secure your account again.",
                        style: QuickTechAppTextStyle.bodyText1(),
                      ),
                      48.verticalSpace,
                      const SignInFeatureRow(
                        icon: Icons.sms_outlined,
                        title: 'Enter the code',
                        subtitle: 'Use the reset code we sent to your phone.',
                      ),
                      20.verticalSpace,
                      const SignInFeatureRow(
                        icon: Icons.lock_outline_rounded,
                        title: 'Choose a password',
                        subtitle: 'Pick something strong and unique.',
                      ),
                      20.verticalSpace,
                      const SignInFeatureRow(
                        icon: Icons.check_circle_outline_rounded,
                        title: "You're all set",
                        subtitle: 'Sign in with your new password.',
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 56.h),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Set New Password',
                            style: QuickTechAppTextStyle.displayMedium(),
                          ),
                          8.verticalSpace,
                          Text(
                            'Enter the code sent to $mobile and choose a new password.',
                            style: QuickTechAppTextStyle.subtitleLarge(),
                          ),
                          36.verticalSpace,
                          form,
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
class ResetPasswordForm extends StatelessWidget {
  final String mobile;
  final AuthController authcontroller;
  final TextEditingController tokenController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final RxBool isShowPassword;
  final RxBool isShowConfirmPassword;

  const ResetPasswordForm({
    super.key,
    required this.mobile,
    required this.authcontroller,
    required this.tokenController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isShowPassword,
    required this.isShowConfirmPassword,
  });

  Future<void> _resetPassword() async {
    final token = tokenController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (token.isEmpty) {
      showErrorToast("Please enter the reset code");
      return;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      showErrorToast("Please enter both password fields");
      return;
    }

    if (password != confirmPassword) {
      showErrorToast("Password and Confirm Password do not match");
      return;
    }

    await authcontroller.resetPassword(
      phone: mobile,
      token: token,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTextField(
          controller: tokenController,
          hint: "🔑 Reset Code",
          isVisible: true,
          isSuffix: false,
        ),
        20.verticalSpace,

        Obx(
          () => customTextField(
            controller: passwordController,
            hint: "🔒 New Password",
            isVisible: isShowPassword.value,
            isSuffix: true,
            suIcon:
                isShowPassword.value ? Icons.visibility_off : Icons.visibility,
            suppixtap: () {
              isShowPassword.value = !isShowPassword.value;
            },
          ),
        ),
        20.verticalSpace,

        Obx(
          () => customTextField(
            controller: confirmPasswordController,
            hint: "🔒 Confirm Password",
            isVisible: isShowConfirmPassword.value,
            isSuffix: true,
            suIcon: isShowConfirmPassword.value
                ? Icons.visibility_off
                : Icons.visibility,
            suppixtap: () {
              isShowConfirmPassword.value = !isShowConfirmPassword.value;
            },
          ),
        ),
        14.verticalSpace,

        // Tip note
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
                  'Tip: use a mix of letters, numbers and symbols for a strong password.',
                  style: QuickTechAppTextStyle.caption(),
                ),
              ),
            ],
          ),
        ),
        28.verticalSpace,

        Obx(
          () => customButton2(
            title: "Reset Password",
            isLoading: authcontroller.isLoading.value,
            onTap: () {
              if (authcontroller.isLoading.value) return;
              _resetPassword();
            },
          ),
        ),
        24.verticalSpace,

        // Resend code
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive the code?",
              style: QuickTechAppTextStyle.bodyText2(),
            ),
            5.horizontalSpace,
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (authcontroller.isLoading.value) return;
                  authcontroller.forgotPassword(mobile);
                },
                child: Text(
                  "Resend",
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