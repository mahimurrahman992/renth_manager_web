import 'package:renth_manager/consts/consts.dart';
import 'package:renth_manager/controller/quick_tech_property_room_store_controller.dart';



import 'package:renth_manager/widgets/quick_tech_custom_dropdown.dart';
import 'package:renth_manager/widgets/quick_tech_web_safe_image.dart';

class QuickTechAddNewPropertyScreen extends StatefulWidget {
  const QuickTechAddNewPropertyScreen({super.key});

  @override
  State<QuickTechAddNewPropertyScreen> createState() =>
      _QuickTechAddNewPropertyScreenState();
}

class _QuickTechAddNewPropertyScreenState
    extends State<QuickTechAddNewPropertyScreen> {
  final commonController = locator.get<CommonController>();
  final authController = locator.get<AuthController>();
  final propertyRoomController = locator.get<QuickTechPropertyRoomController>();

  @override
  void initState() {
    super.initState();
    commonController.selectedCountry.value = null;
    commonController.selectedDistrict.value = null;
    authController.selectedCategory.value = null;
    propertyRoomController.clearPropertyForm();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      commonController.fetchPropertyCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        if (width < 768) {
          return AddPropertyMobileView(
            commonController: commonController,
            authController: authController,
            propertyRoomController: propertyRoomController,
          );
        } else if (width < 1100) {
          return AddPropertyTabletView(
            commonController: commonController,
            authController: authController,
            propertyRoomController: propertyRoomController,
          );
        } else {
          return AddPropertyDesktopView(
            commonController: commonController,
            authController: authController,
            propertyRoomController: propertyRoomController,
          );
        }
      },
    );
  }
}

class AddPropertyMobileView extends StatelessWidget {
  final CommonController commonController;
  final AuthController authController;
  final QuickTechPropertyRoomController propertyRoomController;

  const AddPropertyMobileView({
    super.key,
    required this.commonController,
    required this.authController,
    required this.propertyRoomController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                child: Row(
                  children: [
                    const AddPropertyBackButton(light: true),
                    14.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Property',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          ),
                          2.verticalSpace,
                          Text(
                            'Basic property information',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: textColor,
                            ),
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
                    color: const Color(0xFFF7F8FA),
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(32.r)),
                  ),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(32.r)),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
                      child: Column(
                        children: [
                          AddPropertyInfoColumn(
                            commonController: commonController,
                            authController: authController,
                            propertyRoomController: propertyRoomController,
                            wide: false,
                          ),
                          16.verticalSpace,
                          AddPropertyMediaColumn(
                            propertyRoomController: propertyRoomController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddPropertyTabletView extends StatelessWidget {
  final CommonController commonController;
  final AuthController authController;
  final QuickTechPropertyRoomController propertyRoomController;

  const AddPropertyTabletView({
    super.key,
    required this.commonController,
    required this.authController,
    required this.propertyRoomController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          const CustomDrawer(isPermanentSidebar: true),
          Expanded(
            child: Column(
              children: [
                customAppbar(context),
                Expanded(
                  child: Container(
                    color: const Color(0xFFF7F8FA),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AddPropertyHeading(),
                              24.verticalSpace,
                              AddPropertyInfoColumn(
                                commonController: commonController,
                                authController: authController,
                                propertyRoomController: propertyRoomController,
                                wide: true,
                              ),
                              16.verticalSpace,
                              AddPropertyMediaColumn(
                                propertyRoomController: propertyRoomController,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddPropertyDesktopView extends StatelessWidget {
  final CommonController commonController;
  final AuthController authController;
  final QuickTechPropertyRoomController propertyRoomController;

  const AddPropertyDesktopView({
    super.key,
    required this.commonController,
    required this.authController,
    required this.propertyRoomController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          const CustomDrawer(isPermanentSidebar: true),
          Expanded(
            child: Column(
              children: [
                customAppbar(context),
                Expanded(
                  child: Container(
                    color: const Color(0xFFF7F8FA),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 28.h,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AddPropertyHeading(),
                              28.verticalSpace,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: AddPropertyInfoColumn(
                                      commonController: commonController,
                                      authController: authController,
                                      propertyRoomController:
                                      propertyRoomController,
                                      wide: true,
                                    ),
                                  ),
                                  24.horizontalSpace,
                                  Expanded(
                                    flex: 4,
                                    child: AddPropertyMediaColumn(
                                      propertyRoomController:
                                      propertyRoomController,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddPropertyInfoColumn extends StatelessWidget {
  final CommonController commonController;
  final AuthController authController;
  final QuickTechPropertyRoomController propertyRoomController;
  final bool wide;

  const AddPropertyInfoColumn({
    super.key,
    required this.commonController,
    required this.authController,
    required this.propertyRoomController,
    required this.wide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddPropertySectionCard(
          title: 'Basic Information',
          icon: Icons.apartment_rounded,
          child: Column(
            children: [
              AddPropertyFieldGrid(
                wide: wide,
                children: [
                  customTextField(
                    hint: 'Property Name',
                    isSuffix: false,
                    isVisible: true,
                    controller: propertyRoomController.titleController,
                  ),
                  Obx(() {
                    final categories = commonController.propertyCategories;
                    if (categories.isEmpty) {
                      return SizedBox(
                        height: 52,
                        child: Center(
                          child: SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: mainColor,
                            ),
                          ),
                        ),
                      );
                    }

                    return customDropdownField<PropertyCategories>(
                      hint: 'Property Category',
                      items: categories.map((category) {
                        return DropdownMenuItem<PropertyCategories>(
                          value: category,
                          child: Text(category.name ?? 'Unknown'),
                        );
                      }).toList(),
                      value: categories.firstWhereOrNull(
                            (e) =>
                        e.id == authController.selectedCategory.value?.id,
                      ),
                      onChanged: (value) {
                        authController.selectedCategory.value = value;
                        propertyRoomController.setCategory(value?.id ?? 0);
                      },
                      prefixIcon:
                      const Icon(Icons.category, color: Colors.grey),
                    );
                  }),
                ],
              ),
              14.verticalSpace,
              customTextField(
                hint: 'Full Address',
                isSuffix: false,
                isVisible: true,
                controller: propertyRoomController.addressController,
              ),
              14.verticalSpace,
              customTextField(
                hint: 'Starting Price',
                isSuffix: true,
                isVisible: true,
                keyboard: TextInputType.number,
                controller: propertyRoomController.priceController,
                supColor: Colors.black,
              ),
            ],
          ),
        ),
        16.verticalSpace,
        AddPropertySectionCard(
          title: 'Location',
          icon: Icons.location_on_outlined,
          child: AddPropertyFieldGrid(
            wide: wide,
            children: [
              Obx(() {
                final countries = commonController.countries;
                return customDropdownField<Countries>(
                  hint: 'Country / Region',
                  items: countries.map((country) {
                    return DropdownMenuItem<Countries>(
                      value: country,
                      child: Text(country.name ?? 'Unknown'),
                    );
                  }).toList(),
                  value: countries.firstWhereOrNull(
                        (e) => e.id == commonController.selectedCountry.value?.id,
                  ),
                  onChanged: (value) {
                    commonController.selectedCountry.value = value;

                    if (value != null) {
                      commonController.selectedDistrict.value = null;
                      commonController.fetchDistrictsByCountry(value.id ?? 0);
                      propertyRoomController.setCountry(value.id ?? 0);
                    }
                  },
                  prefixIcon: const Icon(Icons.public, color: Colors.grey),
                );
              }),
              Obx(() {
                final districts = commonController.districtsOfCountry;
                return customDropdownField<District>(
                  hint: 'City / District',
                  items: districts.map((district) {
                    return DropdownMenuItem<District>(
                      value: district,
                      child: Text(district.name ?? 'Unknown'),
                    );
                  }).toList(),
                  value: districts.firstWhereOrNull(
                        (e) => e.id == commonController.selectedDistrict.value?.id,
                  ),
                  onChanged: (value) {
                    commonController.selectedDistrict.value = value;
                    propertyRoomController.setDistrict(value?.id ?? 0);
                  },
                  prefixIcon: const Icon(
                    Icons.location_city,
                    color: Colors.grey,
                  ),
                );
              }),
            ],
          ),
        ),
        16.verticalSpace,
        AddPropertySectionCard(
          title: 'Property Details',
          icon: Icons.notes_rounded,
          child: Column(
            children: [
              AddPropertyFieldGrid(
                wide: wide,
                children: [
                  customTextField(
                    hint: 'Overview',
                    isSuffix: false,
                    isVisible: true,
                    controller: propertyRoomController.overviewController,
                  ),
                  customTextField(
                    hint: 'Near By',
                    isSuffix: false,
                    isVisible: true,
                    controller: propertyRoomController.nearbyController,
                  ),
                ],
              ),
              14.verticalSpace,
              customTextField(
                hint: 'Additional Details',
                isSuffix: false,
                isVisible: true,
                maxline: 6,
                controller: propertyRoomController.additionalDetailsController,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddPropertyMediaColumn extends StatelessWidget {
  final QuickTechPropertyRoomController propertyRoomController;

  const AddPropertyMediaColumn({
    super.key,
    required this.propertyRoomController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddPropertySectionCard(
          title: 'Property Images',
          icon: Icons.photo_library_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddPropertyUploadButton(
                icon: Icons.cloud_upload_outlined,
                label: 'Choose Images',
                onTap: () => propertyRoomController.pickImages(),
              ),
              Obx(() {
                final images = propertyRoomController.images;
                if (images.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: images.map((path) {
                      return AddPropertyImageThumb(
                        path: path,
                        onRemove: () => propertyRoomController.images.remove(
                          path,
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
            ],
          ),
        ),
        24.verticalSpace,
        AddPropertySaveButton(propertyRoomController: propertyRoomController),
        30.verticalSpace,
      ],
    );
  }
}

class AddPropertySaveButton extends StatelessWidget {
  final QuickTechPropertyRoomController propertyRoomController;

  const AddPropertySaveButton({
    super.key,
    required this.propertyRoomController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return customButton2(
        title: 'Save & Continue',
        icon: Icons.save_rounded,iconColor: textColor,
        isLoading: propertyRoomController.isLoading.value,
        onTap: () async {
          if (propertyRoomController.isLoading.value) return;

          final success = await propertyRoomController.submitProperty();
          if (success && context.mounted) {
            Get.back();
          }
        },
      );
    });
  }
}

class AddPropertyHeading extends StatelessWidget {
  const AddPropertyHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AddPropertyBackButton(light: false),
        16.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Property',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
              2.verticalSpace,
              Text(
                'Fill in the basic information to list a new property',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddPropertyBackButton extends StatelessWidget {
  final bool light;

  const AddPropertyBackButton({super.key, required this.light});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: light
                ? Colors.white.withValues(alpha: 0.18)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: light ? null : Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: light ? textColor : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

class AddPropertySectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const AddPropertySectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: mainColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: mainColor, size: 20),
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          20.verticalSpace,
          child,
        ],
      ),
    );
  }
}

class AddPropertyFieldGrid extends StatelessWidget {
  final bool wide;
  final List<Widget> children;

  const AddPropertyFieldGrid({
    super.key,
    required this.wide,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (!wide) {
      return Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) 14.verticalSpace,
          ],
        ],
      );
    }

    final List<Widget> rows = [];
    for (int i = 0; i < children.length; i += 2) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: children[i]),
            16.horizontalSpace,
            Expanded(
              child: i + 1 < children.length
                  ? children[i + 1]
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      if (i + 2 < children.length) rows.add(14.verticalSpace);
    }

    return Column(children: rows);
  }
}

class AddPropertyUploadButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const AddPropertyUploadButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: mainColor.withValues(alpha: 0.06),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: mainColor.withValues(alpha: 0.6), width: 1.4),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 32, color: mainColor),
                  8.verticalSpace,
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    'Tap to browse',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF6B7280),
                    ),
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

class AddPropertyImageThumb extends StatelessWidget {
  final dynamic path;
  final VoidCallback onRemove;

  const AddPropertyImageThumb({
    super.key,
    required this.path,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        QuickTechWebSafeImage(
          fileOrPath: path,
          width: 88,
          height: 88,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(12),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}