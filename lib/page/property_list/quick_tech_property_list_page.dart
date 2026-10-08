import 'package:flutter/cupertino.dart';
import 'package:renth_manager/consts/consts.dart';

class QuickTechPropertyListPage extends StatefulWidget {
  final bool showAppBar;
  const QuickTechPropertyListPage({super.key, this.showAppBar = false});

  @override
  State<QuickTechPropertyListPage> createState() =>
      _QuickTechPropertyListPageState();
}

class _QuickTechPropertyListPageState extends State<QuickTechPropertyListPage> {
  final dashboardController = locator.get<DashboardController>();
  final commonController = locator.get<CommonController>();
  final editPropertyController = locator.get<EditPropertyController>();

  Widget _buildBody(BuildContext context) {
    final properties =
        editPropertyController.propertyList.value.properties ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'List & Manage Your Assets',
                style: QuickTechAppTextStyle.headline3().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
              4.verticalSpace,
              Text(
                'Expand your portfolio by registering new properties, rooms, or vehicles.',
                style: QuickTechAppTextStyle.subtitle().copyWith(
                  color: textMuted,
                  fontSize: 13,
                ),
              ),
              28.verticalSpace,

              // Action Cards Grid
              _buildFeatureCard(
                title: 'Add New Property',
                description:
                    'Register an entire hotel, apartment building, family home, or guest house.',
                icon: Icons.add_business_rounded,
                accentColor: mainColor,
                onTap: () async {
                  await commonController.fetchPropertyCategories();
                  Get.toNamed(AppRoutes.addNewProperty);
                  //Get.to(() => const QuickTechAddNewPropertyScreen());
                },
              ),

              16.verticalSpace,

              _buildFeatureCard(
                title: 'Add New Room / Flat',
                description:
                    'Add individual rentable rooms, suites, or flats to your registered properties.',
                icon: Icons.meeting_room_rounded,
                accentColor: const Color(0xFF3B82F6),
                onTap: () {
                  if (properties.isNotEmpty) {
                    Get.toNamed(AppRoutes.addRoom);
                    // Get.to(() => const QuickTechAddRoomScreen());
                  } else {
                    Get.snackbar(
                      'Action Required',
                      'Please register a property first before adding individual rooms.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
                    );
                  }
                },
              ),

              16.verticalSpace,

              _buildFeatureCard(
                title: 'Add New Vehicle (Upcoming)',
                description:
                    'Car, bike, and microbus rental service integration coming soon to Renth Partner.',
                icon: CupertinoIcons.car_detailed,
                accentColor: const Color(0xFF8B5CF6),
                isComingSoon: false,
                onTap: () {
                  Get.snackbar(
                    'Upcoming Feature',
                    'Vehicle rental management will be released in an upcoming update.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                  );
                },
              ),

              40.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
    bool isComingSoon = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color:
                        accentColor == mainColor ? Colors.black87 : accentColor,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: QuickTechAppTextStyle.headline4().copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          if (isComingSoon) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'SOON',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: QuickTechAppTextStyle.subtitle().copyWith(
                          fontSize: 12,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showAppBar) {
      return _buildBody(context);
    }

    return Scaffold(
      drawer: const CustomDrawer(isPermanentSidebar: false),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            customAppbar(context),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }
}
