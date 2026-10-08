import 'dart:developer';

import 'package:renth_manager/consts/consts.dart';

import 'package:renth_manager/model/property_list_model.dart';


class QuickTechHomePage extends StatefulWidget {
  const QuickTechHomePage({super.key});

  @override
  State<QuickTechHomePage> createState() => _QuickTechHomePageState();
}

class _QuickTechHomePageState extends State<QuickTechHomePage> {
  final dashboardController = locator.get<DashboardController>();
  final editPropertyController = locator.get<EditPropertyController>();
  final roomController = locator.get<QuickTechRoomController>();
  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  Future<void> loadData() async {
    await dashboardController.getManagerDashboard();
    await dashboardController.getAllPages();

    // Fetch all properties and load selected property's room records
    await editPropertyController.fetchAllProperties().then((_) {
      final savedId = editPropertyController.box.read(
        EditPropertyController.selectedPropertyId,
      );

      final properties = editPropertyController.propertyList.value.properties ?? [];

      if (savedId != null && properties.isNotEmpty) {
        try {
          final selected = properties.firstWhere((e) => e.id == savedId);
          editPropertyController.selectedProperty.value = selected;
          roomController.fetchRoomRecords(propertyId: savedId);
        } catch (e) {
          log(e.toString());
        }
      } else if (properties.isNotEmpty) {
        editPropertyController.selectedProperty.value = properties.first;
        if (properties.first.id != null) {
          roomController.fetchRoomRecords(propertyId: properties.first.id!);
        }
      }
    });
  }

  Future<void> _onRefresh() async {
    final propertyId = GetStorage().read(StorageKeys.selectedPropertyId);
    await dashboardController.getManagerDashboard();

    if (propertyId != null) {
      await roomController.fetchRoomRecords(propertyId: propertyId);
    }
    await editPropertyController.fetchAllProperties();
  }

  @override
  void dispose() {
    dashboardController.shouldAnimate.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
        final horizontalPadding = isDesktop ? 24.0 : (isTablet ? 16.0 : 12.0);

        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: mainColorDark,
          child: SingleChildScrollView(
            controller: dashboardController.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP HERO GREETING & QUICK ACTION BAR
                customHeroBanner(isDesktop, isTablet),

                const SizedBox(height: 18),

                // 2. FINANCIAL & PROPERTY SWITCHER ROW
                customPropertyAndFinanceRow(isDesktop, isTablet),

                const SizedBox(height: 24),

                // 3. DASHBOARD METRICS / KPI GRID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: mainColorDark,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Performance Overview',
                          style: QuickTechAppTextStyle.headline3().copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, size: 20, color: textMuted),
                      tooltip: 'Refresh Metrics',
                      onPressed: _onRefresh,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                const QuickTechHomeDashboardOverview(),

                const SizedBox(height: 28),

                // 4. RECENT BOOKINGS SECTION & TABLE
                QuickTechRecentBookingTable(),

                const SizedBox(height: 16),

                // Pagination Loader
                Obx(() {
                  if (dashboardController.isMoreLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(color: mainColor),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget customHeroBanner(bool isDesktop, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 22 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            mainColor.withValues(alpha: 0.15),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: mainColor.withValues(alpha: 0.3)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isStacked = constraints.maxWidth < 800;

          final welcomeInfo = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final userName = profileController.profile.value.user?.name ?? 'Property Partner';
                return Text(
                  'Welcome back, $userName 👋',
                  style: QuickTechAppTextStyle.headline2().copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: isDesktop ? 22 : 18,
                    color: textColor,
                  ),
                );
              }),
              const SizedBox(height: 4),
              Text(
                'Monitor reservations, update room vacancies, and manage your property earnings.',
                style: QuickTechAppTextStyle.subtitle().copyWith(
                  fontSize: 13,
                  color: textMuted,
                ),
              ),
            ],
          );

          final quickActions = Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildActionButton(
                icon: Icons.add_home_work_rounded,
                label: 'Add Room',
                isPrimary: true,
                onTap: () {
                  final properties = editPropertyController.propertyList.value.properties ?? [];
                  if (properties.isNotEmpty) {
                    Get.toNamed(AppRoutes.addRoom);
                   // Get.to(() => const QuickTechAddRoomScreen());
                  } else {
                    Get.snackbar('Notice', 'Please add a property first before adding rooms');
                  }
                },
              ),
              _buildActionButton(
                icon: Icons.domain_add_rounded,
                label: 'New Property',
                isPrimary: false,
                onTap: () => Get.toNamed(AppRoutes.addNewProperty),
               // onTap: () => Get.to(() => const QuickTechAddNewPropertyScreen()),
              ),
              _buildActionButton(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Withdraw',
                isPrimary: false,
                accentColor: successColor,
                onTap: () => Get.toNamed(AppRoutes.withdraw),
                //onTap: () => Get.to(() => const WalletWithdrawPage()),
              ),
            ],
          );

          if (isStacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                welcomeInfo,
                const SizedBox(height: 14),
                quickActions,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: welcomeInfo),
              const SizedBox(width: 16),
              quickActions,
            ],
          );
        },
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
    Color? accentColor,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: isPrimary ? mainColor : Colors.white,
        borderRadius: BorderRadius.circular(10),
        elevation: isPrimary ? 2 : 0,
        shadowColor: mainColor.withValues(alpha: 0.3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isPrimary
                    ? mainColorDark.withValues(alpha: 0.4)
                    : (accentColor?.withValues(alpha: 0.4) ?? borderColor),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isPrimary ? Colors.black87 : (accentColor ?? textColor),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: QuickTechAppTextStyle.button().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isPrimary ? Colors.black87 : (accentColor ?? textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget customPropertyAndFinanceRow(bool isDesktop, bool isTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isRow = constraints.maxWidth >= 880;

        final propertySelectorCard = _buildActivePropertyCard();
        final balanceQuickCard = _buildWalletQuickCard();

        if (isRow) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: propertySelectorCard),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: balanceQuickCard),
            ],
          );
        }

        return Column(
          children: [
            propertySelectorCard,
            const SizedBox(height: 12),
            balanceQuickCard,
          ],
        );
      },
    );
  }

  Widget _buildActivePropertyCard() {
    return Obx(() {
      final properties = editPropertyController.propertyList.value.properties ?? [];
      final selected = editPropertyController.selectedProperty.value;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: mainColor.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.business_rounded, color: Colors.black87, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active Property',
                              style: QuickTechAppTextStyle.caption().copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: textMuted,
                              ),
                            ),
                            Text(
                              selected?.title ?? 'No Property Selected',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: QuickTechAppTextStyle.headline4().copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected?.district?.name != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: Text(
                      selected!.district!.name!,
                      style: QuickTechAppTextStyle.caption().copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Properties>(
                  isExpanded: true,
                  value: properties.any((e) => e.id == selected?.id) ? selected : null,
                  hint: Text(
                    'Switch Selected Property',
                    style: QuickTechAppTextStyle.bodyText3().copyWith(color: textMuted),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black87),
                  items: properties.map((prop) {
                    return DropdownMenuItem<Properties>(
                      value: prop,
                      child: Text(
                        prop.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    );
                  }).toList(),
                  onChanged: (Properties? prop) async {
                    if (prop == null) return;
                    editPropertyController.selectedProperty.value = prop;
                    GetStorage().write(StorageKeys.selectedPropertyId, prop.id);
                    if (prop.id != null) {
                      await roomController.fetchRoomRecords(propertyId: prop.id!);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildWalletQuickCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            const Color(0xFFFFFBEB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: mainColor.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: successColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.account_balance_wallet_rounded, color: successColor, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Available Balance',
                    style: QuickTechAppTextStyle.caption().copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => dashboardController.isBalanceVisible.value = !dashboardController.isBalanceVisible.value,
                  child: Obx(
                    () => Icon(
                      dashboardController.isBalanceVisible.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 18,
                      color: textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Obx(() {
                  final isVisible = dashboardController.isBalanceVisible.value;
                  final revenue = dashboardController.dashboard.value.totalRevenue ?? '0';

                  return Text(
                    isVisible ? '৳ $revenue' : '৳ ••••••',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: QuickTechAppTextStyle.headline1().copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: textColor,
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.withdraw),
                  //onPressed: () => Get.to(() => const WalletWithdrawPage()),
                  icon: const Icon(Icons.arrow_outward_rounded, size: 14),
                  label: const Text('Withdraw', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
