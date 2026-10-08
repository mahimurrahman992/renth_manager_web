
import 'package:renth_manager/consts/consts.dart';

import 'package:renth_manager/model/property_list_model.dart';

import 'package:renth_manager/widgets/custom_responsive_helper.dart';

import 'package:renth_manager/widgets/web_image.dart';

Widget customAppbar(BuildContext context) {
  final isMobile = Responsive.isMobile(context);

  if (isMobile) {
    return const _MobileAppbar();
  } else {
    return const _WebDesktopAppbar();
  }
}

// =============================================================================
// MOBILE APPBAR
// =============================================================================
class _MobileAppbar extends StatelessWidget {
  const _MobileAppbar();

  @override
  Widget build(BuildContext context) {
    final dashboardController = locator.get<DashboardController>();

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: borderColor.withValues(alpha: 0.7),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Drawer Hamburger Button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                dashboardController.scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: mainColor,
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.menu_rounded,
                  color: Colors.black,
                  size: 22,
                ),
              ),
            ),
          ),

          // Brand Logo Center
          Image.asset(
            'assets/images/Renth-3.png',
            height: 36,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/images/logo.png',
              height: 32,
              errorBuilder: (_, __, ___) => Text(
                'Renth',
                style: QuickTechAppTextStyle.headline3().copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),

          // Notification and Chat Actions
          Row(
            children: [
              _buildIconActionButton(
                icon: Icons.notifications_none_rounded,
                badge: true,
                onTap: () => Get.toNamed(AppRoutes.notification),
                //onTap: () => Get.to(() => NotificationScreen()),
              ),
              const SizedBox(width: 8),
              _buildIconActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                badge: false,
                onTap: () => Get.toNamed(AppRoutes.message),
                //onTap: () => Get.to(() => QuickTechChatListPage()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconActionButton({
    required IconData icon,
    required bool badge,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
                border: Border.all(color: borderColor),
              ),
              child: Icon(icon, size: 20, color: textColor),
            ),
            if (badge)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// TABLET & DESKTOP WEB TOPBAR WITH TEXTBUTTONS NAVIGATION
// =============================================================================
class _WebDesktopAppbar extends StatelessWidget {
  const _WebDesktopAppbar();

  @override
  Widget build(BuildContext context) {
    final dashboardController = locator.get<DashboardController>();
    final editPropertyController = locator.get<EditPropertyController>();
    final roomController = locator.get<QuickTechRoomController>();
    final profileController = Get.find<ProfileController>();

    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: borderColor.withValues(alpha: 0.8),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showCenterNav = constraints.maxWidth >= 1050;
          final showPropertySwitcher = constraints.maxWidth >= 850;
          final showWalletBadge = constraints.maxWidth >= 720;
          final showNameInProfile = constraints.maxWidth >= 580;

          return Row(
            children: [
              // Left: Current Page Title / Breadcrumb
              Obx(() {
                final title = dashboardController.currentTabTitle;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: QuickTechAppTextStyle.headline3().copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: borderColor),
                      ),
                      child: Text(
                        'Online',
                        style: QuickTechAppTextStyle.caption().copyWith(
                          color: successColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }),

              if (showCenterNav) ...[
                const SizedBox(width: 24),
                // CENTER: Professional Top Navigation TextButtons (Website Style)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Obx(() {
                      final currentIndex = dashboardController.currentIndex.value;

                      return Row(
                        children: [
                          _NavTextButton(
                            icon: Icons.dashboard_outlined,
                            activeIcon: Icons.dashboard_rounded,
                            label: 'Dashboard',
                            isSelected: currentIndex == 0,
                            onTap: () => dashboardController.switchTab(0),
                          ),
                          const SizedBox(width: 6),
                          _NavTextButton(
                            icon: Icons.meeting_room_outlined,
                            activeIcon: Icons.meeting_room_rounded,
                            label: 'Room Management',
                            isSelected: currentIndex == 1,
                            onTap: () => dashboardController.switchTab(1),
                          ),
                          const SizedBox(width: 6),
                          _NavTextButton(
                            icon: Icons.domain_outlined,
                            activeIcon: Icons.domain_rounded,
                            label: 'Property List',
                            isSelected: currentIndex == 2,
                            onTap: () => dashboardController.switchTab(2),
                          ),
                          const SizedBox(width: 6),
                          _NavTextButton(
                            icon: Icons.receipt_long_outlined,
                            activeIcon: Icons.receipt_long_rounded,
                            label: 'Recent Bookings',
                            isSelected: currentIndex == 3,
                            onTap: () => dashboardController.switchTab(3),
                          ),
                          const SizedBox(width: 6),
                          _NavTextButton(
                            icon: Icons.person_outline_rounded,
                            activeIcon: Icons.person_rounded,
                            label: 'Profile',
                            isSelected: currentIndex == 4,
                            onTap: () => dashboardController.switchTab(4),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ] else
                const Spacer(),

              const SizedBox(width: 10),

              // RIGHT SIDE CONTROLS
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showPropertySwitcher) ...[
                    _buildPropertySwitcher(editPropertyController, roomController),
                    const SizedBox(width: 10),
                  ],

                  if (showWalletBadge) ...[
                    _buildWalletBalanceBadge(dashboardController),
                    const SizedBox(width: 10),
                  ],

                  // Notifications Action Button
                  _buildCircleButton(
                    icon: Icons.notifications_none_rounded,
                    badge: true,
                    tooltip: 'Notifications',
                    onTap: () => Get.toNamed(AppRoutes.notification),
                  ),

                  const SizedBox(width: 8),

                  // Messages Action Button
                  _buildCircleButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    badge: false,
                    tooltip: 'Messages',
                    onTap: () => Get.toNamed(AppRoutes.message),
                  ),

                  const SizedBox(width: 10),

                  // Profile Avatar Pill
                  _buildProfileChip(profileController, dashboardController, showName: showNameInProfile),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPropertySwitcher(
    EditPropertyController editPropertyController,
    QuickTechRoomController roomController,
  ) {
    return Obx(() {
      final properties = editPropertyController.propertyList.value.properties ?? [];
      final selected = editPropertyController.selectedProperty.value;

      if (properties.isEmpty) return const SizedBox.shrink();

      return Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Properties>(
            value: properties.any((e) => e.id == selected?.id) ? selected : null,
            hint: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.hotel_rounded, size: 16, color: mainColorDark),
                const SizedBox(width: 6),
                Text(
                  'Select Property',
                  style: QuickTechAppTextStyle.caption().copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black87, size: 20),
            items: properties.map((prop) {
              return DropdownMenuItem<Properties>(
                value: prop,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.business_rounded, size: 14, color: mainColorDark),
                    const SizedBox(width: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 140),
                      child: Text(
                        prop.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ),
                  ],
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
      );
    });
  }

  Widget _buildWalletBalanceBadge(DashboardController controller) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.withdraw),
        //onTap: () => Get.to(() => const WalletWithdrawPage()),
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: mainColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: mainColorDark.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_balance_wallet_rounded, size: 16, color: Colors.black),
              const SizedBox(width: 6),
              Obx(() {
                final revenue = controller.dashboard.value.totalRevenue ?? '0';
                return Text(
                  '৳ $revenue',
                  style: QuickTechAppTextStyle.bodyBold3().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required bool badge,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: Icon(icon, size: 18, color: textColor),
              ),
              if (badge)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileChip(
    ProfileController profileController,
    DashboardController dashboardController, {
    bool showName = true,
  }) {
    return Obx(() {
      final user = profileController.profile.value.user;

      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => dashboardController.switchTab(4),
          child: Container(
            height: 38,
            padding: EdgeInsets.only(left: 4, right: showName ? 10 : 4),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                WebSafeNetworkImage(
                  imageUrl: user?.profilePhoto,
                  width: 28,
                  height: 28,
                  isCircle: true,
                  errorWidget: CircleAvatar(
                    radius: 14,
                    backgroundColor: mainColorLight,
                    child: Text(
                      (user?.name?.isNotEmpty ?? false) ? user!.name![0].toUpperCase() : 'M',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
                if (showName) ...[
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 90),
                    child: Text(
                      user?.name ?? 'Manager',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: QuickTechAppTextStyle.bodyBold3().copyWith(
                        fontSize: 12,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}

// =============================================================================
// MODERN NAV TEXTBUTTON COMPONENT (TOP BAR TABS)
// =============================================================================
class _NavTextButton extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTextButton({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavTextButton> createState() => _NavTextButtonState();
}

class _NavTextButtonState extends State<_NavTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? mainColor.withValues(alpha: 0.22)
                : (_isHovered ? backgroundColor : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.isSelected
                  ? mainColorDark.withValues(alpha: 0.6)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isSelected ? widget.activeIcon : widget.icon,
                size: 17,
                color: widget.isSelected
                    ? Colors.black
                    : (_isHovered ? textColor : textMuted),
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: QuickTechAppTextStyle.bodyBold3().copyWith(
                  fontSize: 13,
                  fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isSelected
                      ? textColor
                      : (_isHovered ? textColor : textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

AppBar customAppbarCommon(
  BuildContext context,
  String title, {
  bool centerTitle = false,
}) {
  return AppBar(
    title: Text(
      title,
      style: QuickTechAppTextStyle.headline3().copyWith(
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    ),
    centerTitle: centerTitle,
    backgroundColor: Colors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
    iconTheme: const IconThemeData(color: Colors.black),
    shape: const Border(
      bottom: BorderSide(color: borderColor, width: 1),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: IconButton(
          icon: const Icon(Icons.notifications_none_rounded, size: 24, color: Colors.black),
          onPressed: () => Get.toNamed(AppRoutes.notification),
          //onPressed: () => Get.to(() => NotificationScreen()),
        ),
      ),
    ],
  );
}
