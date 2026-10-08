import 'package:renth_manager/consts/consts.dart';


class QuickTechRegisterPage extends StatefulWidget {
  final LoginType loginType;
  const QuickTechRegisterPage({super.key, required this.loginType});

  @override
  State<QuickTechRegisterPage> createState() => _QuickTechRegisterPageState();
}

class _QuickTechRegisterPageState extends State<QuickTechRegisterPage> {
  final controller = locator.get<AuthController>();
  final commonController = locator.get<CommonController>();

  @override
  void initState() {
    super.initState();
    commonController.fetchPropertyCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (width < 600) {
            return RegisterMobileView(
              loginType: widget.loginType,
              controller: controller,
              commonController: commonController,
            );
          } else if (width < 1024) {
            return RegisterTabletView(
              loginType: widget.loginType,
              controller: controller,
              commonController: commonController,
            );
          } else {
            return RegisterDesktopView(
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
class RegisterMobileView extends StatelessWidget {
  final LoginType loginType;
  final AuthController controller;
  final CommonController commonController;

  const RegisterMobileView({
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
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 24.w, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SignInBackButton(light: true),
                  16.verticalSpace,
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Text(
                      'Create Your Account 🚀',
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
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign Up',
                        style: QuickTechAppTextStyle.headline2(),
                      ),
                      6.verticalSpace,
                      Text(
                        'Fill the form below to create your account',
                        style: QuickTechAppTextStyle.subtitle(),
                      ),
                      24.verticalSpace,
                      RegisterForm(
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
class RegisterTabletView extends StatelessWidget {
  final LoginType loginType;
  final AuthController controller;
  final CommonController commonController;

  const RegisterTabletView({
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
            constraints: const BoxConstraints(maxWidth: 560),
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
                  20.verticalSpace,
                  Text(
                    'Create Your Account 🚀',
                    textAlign: TextAlign.center,
                    style: QuickTechAppTextStyle.displaySmall(),
                  ),
                  8.verticalSpace,
                  Text(
                    'Fill the form below to create your account',
                    textAlign: TextAlign.center,
                    style: QuickTechAppTextStyle.subtitle(),
                  ),
                  28.verticalSpace,
                  RegisterForm(
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
class RegisterDesktopView extends StatelessWidget {
  final LoginType loginType;
  final AuthController controller;
  final CommonController commonController;

  const RegisterDesktopView({
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
          flex: 5,
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
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SignInLogoBadge(),
                      40.verticalSpace,
                      Text(
                        'Join Renth\nPartner App',
                        style: QuickTechAppTextStyle.displayLarge(),
                      ),
                      20.verticalSpace,
                      Text(
                        "Join Bangladesh's largest network of Smart Properties.",
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

        // RIGHT: register form
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
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign Up',
                            style: QuickTechAppTextStyle.displayMedium(),
                          ),
                          8.verticalSpace,
                          Text(
                            'Fill the form below to create your account',
                            style: QuickTechAppTextStyle.subtitleLarge(),
                          ),
                          32.verticalSpace,
                          RegisterForm(
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
class RegisterForm extends StatelessWidget {
  final LoginType loginType;
  final AuthController controller;
  final CommonController commonController;

  const RegisterForm({
    super.key,
    required this.loginType,
    required this.controller,
    required this.commonController,
  });

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: textColor),
              title: Text('Gallery', style: QuickTechAppTextStyle.bodyText2()),
              onTap: () {
                controller.pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: textColor),
              title: Text('Camera', style: QuickTechAppTextStyle.bodyText2()),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- Profile image ----------
        Center(
          child: Obx(() {
            final image = controller.imageFile.value;
            return GestureDetector(
              onTap: () => _showImagePicker(context),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: dividerColor,
                      backgroundImage: image != null ? FileImage(image) : null,
                      child: image == null
                          ? const Icon(Icons.person, size: 40, color: hintColor)
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: mainColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: cardColor, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16.sp,
                          color: textOnMain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        24.verticalSpace,

        // ---------- Name ----------
        customTextField(
          controller: controller.name,
          hint: "👤 Full Name",
          isSuffix: true,
          suIcon: Icons.person,
          suppixtap: () {},
          isVisible: true,
        ),
        20.verticalSpace,

        // ---------- Phone / Email ----------
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
            hint: "📧 Email Address",
            isSuffix: true,
            suIcon: Icons.email,
            suffixTap: () {},
          ),
        20.verticalSpace,

        // ---------- Category ----------
        RegisterCategoryDropdown(
          controller: controller,
          commonController: commonController,
        ),
        20.verticalSpace,

        // ---------- Password ----------
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
        20.verticalSpace,
        Obx(
          () => customTextField(
            hint: "🔒 Confirm Password",
            isSuffix: true,
            isVisible: controller.isShowConfirmPassword.value,
            controller: controller.confirmPassword,
            suIcon: controller.isShowConfirmPassword.value
                ? Icons.visibility_off
                : Icons.visibility,
            suppixtap: () {
              controller.isShowConfirmPassword.value =
                  !controller.isShowConfirmPassword.value;
            },
          ),
        ),
        12.verticalSpace,

        // ---------- Terms ----------
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: 'By creating an account you agree to our ',
                  style: QuickTechAppTextStyle.bodyText3(),
                  children: [
                    TextSpan(
                      text: 'terms of service and privacy policy',
                      style: QuickTechAppTextStyle.linkSmall(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        24.verticalSpace,

        // ---------- Button ----------
        customButton2(
          title: 'Sign Up',
          onTap: () {
            controller.registerManager(loginType);
          },
        ),
        24.verticalSpace,

        // ---------- Sign in link ----------
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: QuickTechAppTextStyle.bodyText2(),
            ),
            5.horizontalSpace,
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.chooseLoginType);
                 // Get.to(() => QuickTechChooseLoginTypeScreen());
                },
                child: Text(
                  "Sign In",
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

// ======================= CATEGORY DROPDOWN =======================
class RegisterCategoryDropdown extends StatelessWidget {
  final AuthController controller;
  final CommonController commonController;

  const RegisterCategoryDropdown({
    super.key,
    required this.controller,
    required this.commonController,
  });

  Widget _categoryRow(PropertyCategories category) {
    return Row(
      children: [
        const Icon(Icons.apartment, color: warningColor, size: 20),
        8.horizontalSpace,
        Expanded(
          child: Text(
            category.name ?? 'Unnamed',
            overflow: TextOverflow.ellipsis,
            style: QuickTechAppTextStyle.bodyText2(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = commonController.propertyCategories;

      // Keep one item per category id to avoid duplicate values.
      final Map<int?, PropertyCategories> uniqueCategoryMap = {};
      for (final category in categories) {
        if (!uniqueCategoryMap.containsKey(category.id)) {
          uniqueCategoryMap[category.id] = category;
        }
      }
      final uniqueCategories = uniqueCategoryMap.values.toList();

      final selectedId = controller.selectedCategory.value?.id;
      PropertyCategories? selectedValue;
      if (selectedId != null) {
        for (final category in uniqueCategories) {
          if (category.id == selectedId) {
            selectedValue = category;
            break;
          }
        }
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: mainColor),
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: DropdownButton<PropertyCategories>(
          hint: Row(
            children: [
              const Icon(Icons.category, color: hintColor, size: 20),
              8.horizontalSpace,
              Text(
                "Select Property Category",
                style: QuickTechAppTextStyle.hintText(),
              ),
            ],
          ),
          isExpanded: true,
          value: selectedValue,
          onChanged: (v) {
            controller.selectCategory(v);
          },
          underline: const SizedBox.shrink(),
          icon: const Icon(Icons.keyboard_arrow_down, color: textColor),
          items: uniqueCategories.map((PropertyCategories category) {
            return DropdownMenuItem<PropertyCategories>(
              value: category,
              child: _categoryRow(category),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return uniqueCategories
                .map((PropertyCategories category) => _categoryRow(category))
                .toList();
          },
        ),
      );
    });
  }
}