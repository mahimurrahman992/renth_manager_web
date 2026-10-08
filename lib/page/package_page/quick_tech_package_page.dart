import 'package:renth_manager/consts/consts.dart';

import '../../model/package_model.dart';

class QuickTechPackagePage extends StatefulWidget {
  const QuickTechPackagePage({super.key});

  @override
  State<QuickTechPackagePage> createState() => _QuickTechPackagePageState();
}

class _QuickTechPackagePageState extends State<QuickTechPackagePage> {
  final PackageController packageController = Get.put(PackageController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((v) {
      packageController.getBuyPackageInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (width < 600) {
            return PackageMobileView(packageController: packageController);
          } else if (width < 1024) {
            return PackageTabletView(packageController: packageController);
          } else {
            return PackageDesktopView(packageController: packageController);
          }
        },
      ),
    );
  }
}

class PackageMobileView extends StatelessWidget {
  final PackageController packageController;

  const PackageMobileView({super.key, required this.packageController});

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
              child: Row(
                children: [
                  const PackageBackButton(light: true),
                  14.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Package Buy',
                          style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          'Supercharge your business 🔥',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: Colors.white70,
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
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await packageController.getBuyPackageInfo();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
                      child: PackageContent(
                        packageController: packageController,
                        columns: 1,
                      ),
                    ),
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

class PackageTabletView extends StatelessWidget {
  final PackageController packageController;

  const PackageTabletView({super.key, required this.packageController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const PackageTopBar(horizontalPadding: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 860),
                  child: Column(
                    children: [
                      const PackageHero(),
                      28.verticalSpace,
                      PackageContent(
                        packageController: packageController,
                        columns: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PackageDesktopView extends StatelessWidget {
  final PackageController packageController;

  const PackageDesktopView({super.key, required this.packageController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const PackageTopBar(horizontalPadding: 40),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 36.h),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      const PackageHero(),
                      40.verticalSpace,
                      PackageContent(
                        packageController: packageController,
                        columns: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PackageContent extends StatelessWidget {
  final PackageController packageController;
  final int columns;

  const PackageContent({
    super.key,
    required this.packageController,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<Packages> packageList =
          packageController.package.value.packages ?? [];

      if (packageController.isLoading.value && packageList.isEmpty) {
        return const PackageLoadingState();
      }

      if (packageList.isEmpty) {
        return const PackageEmptyState();
      }

      final String? purchasedId =
          packageController.package.value.packageOrder?.packageId;

      return LayoutBuilder(
        builder: (context, constraints) {
          const double gap = 20;
          final double cardWidth =
              (constraints.maxWidth - gap * (columns - 1)) / columns;

          return Wrap(
            alignment: WrapAlignment.center,
            spacing: gap,
            runSpacing: gap,
            children: List.generate(packageList.length, (index) {
              final item = packageList[index];

              return SizedBox(
                width: cardWidth,
                child: PackageCard(
                  item: item,
                  index: index,
                  isPopular: item.popular == '1',
                  isPurchased: purchasedId == item.id.toString(),
                  onSubscribe: () {
                    packageController.subscribeToPackage(id: item.id);
                  },
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: (index * 100).ms)
                    .slideY(begin: 0.08),
              );
            }),
          );
        },
      );
    });
  }
}

class PackageCard extends StatelessWidget {
  final Packages item;
  final int index;
  final bool isPopular;
  final bool isPurchased;
  final VoidCallback onSubscribe;

  const PackageCard({
    super.key,
    required this.item,
    required this.index,
    required this.isPopular,
    required this.isPurchased,
    required this.onSubscribe,
  });

  IconData _icon() {
    switch (index) {
      case 0:
        return Ionicons.rocket_outline;
      case 1:
        return Ionicons.flash_outline;
      default:
        return Ionicons.diamond_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPopular ? mainColor : const Color(0xFFE5E7EB),
          width: isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPopular
                ? mainColor.withValues(alpha: 0.18)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: isPopular ? 40 : 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'POPULAR',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPopular) 12.verticalSpace,
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(_icon(), color: Colors.black87, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name ?? 'Plan',
                            style: GoogleFonts.poppins(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF111827),
                            ),
                          ),
                          Text(
                            item.type ?? 'Standard Plan',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: 8,
                  children: [
                    Text(
                      '৳${item.price}',
                      style: GoogleFonts.poppins(
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '/ ${item.duration ?? '0'} day',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFE5E7EB), height: 1),
                const SizedBox(height: 20),
                PackageFeatureItem(
                  icon: Ionicons.checkmark_circle,
                  text: '${item.maximumPost} Post Listings',
                ),
                const SizedBox(height: 12),
                PackageFeatureItem(
                  icon: Ionicons.calendar_outline,
                  text: 'Validity: ${item.duration}',
                ),
                const SizedBox(height: 12),
                PackageFeatureItem(
                  icon: Ionicons.checkmark_circle,
                  text: item.shortDescription ?? 'Standard features included',
                ),
                const SizedBox(height: 28),
                PackageSubscribeButton(
                  isPurchased: isPurchased,
                  isPopular: isPopular,
                  onTap: onSubscribe,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PackageFeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const PackageFeatureItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: mainColor.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.black87, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.4,
                color: const Color(0xFF374151),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PackageSubscribeButton extends StatelessWidget {
  final bool isPurchased;
  final bool isPopular;
  final VoidCallback onTap;

  const PackageSubscribeButton({
    super.key,
    required this.isPurchased,
    required this.isPopular,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isPurchased) {
      return Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF16A34A).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF16A34A).withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF16A34A),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Current Active Plan',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF15803D),
              ),
            ),
          ],
        ),
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: isPopular ? mainColor : Colors.white,
        elevation: isPopular ? 4 : 0,
        shadowColor: mainColor.withValues(alpha: 0.4),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isPopular ? Colors.transparent : mainColor,
            width: 1.4,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Subscribe Now',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.black87,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PackageHero extends StatelessWidget {
  const PackageHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Supercharge Your Business 🔥',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        8.verticalSpace,
        Text(
          'Pick the plan that fits your property listings',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 15.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class PackageLoadingState extends StatelessWidget {
  const PackageLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: mainColor, strokeWidth: 3),
            const SizedBox(height: 20),
            Text(
              'Loading Plans...',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PackageEmptyState extends StatelessWidget {
  const PackageEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset('assets/icons/empty.json'),
            ),
            const SizedBox(height: 16),
            Text(
              'No Packages Available',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for exciting offers',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PackageTopBar extends StatelessWidget {
  final double horizontalPadding;

  const PackageTopBar({super.key, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          const PackageBackButton(light: false),
          16.horizontalSpace,
          Text(
            'Package Buy',
            style: GoogleFonts.poppins(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class PackageBackButton extends StatelessWidget {
  final bool light;

  const PackageBackButton({super.key, required this.light});

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
                : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: light ? Colors.white : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}