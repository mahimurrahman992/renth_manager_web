import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renth_manager/consts/color.dart';
import 'package:renth_manager/controller/quick_tech_auth_controller.dart';
import 'package:renth_manager/controller/quick_tech_dashboard_controller.dart';
import 'package:renth_manager/controller/quick_tech_profile_controller.dart';
import 'package:renth_manager/locator.dart';
import 'package:renth_manager/page/booking_list_page/quick_tech_booking_list_page.dart';
import 'package:renth_manager/page/package_page/quick_tech_package_page.dart';
import 'package:renth_manager/page/withdraw_page/quick_tech_withdraw_page.dart';
import 'package:renth_manager/widgets/drawer/quick_tech_custom_html_text_view.dart';
import 'package:renth_manager/widgets/quick_tech_app_text_style.dart';
import 'package:renth_manager/widgets/web_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  final bool isPermanentSidebar;

  const CustomDrawer({super.key, this.isPermanentSidebar = false});

  @override
  Widget build(BuildContext context) {
    final dashboardController = locator.get<DashboardController>();
    final authController = Get.put(locator.get<AuthController>());
    final ProfileController profileController = Get.find<ProfileController>();

    final content = _SidebarContent(
      isPermanent: isPermanentSidebar,
      dashboardController: dashboardController,
      authController: authController,
      profileController: profileController,
    );

    if (isPermanentSidebar) {
      final screenWidth = MediaQuery.of(context).size.width;
      final sidebarWidth = screenWidth < 1100 ? 230.0 : 260.0;

      return Container(
        width: sidebarWidth,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            right: BorderSide(
              color: borderColor.withValues(alpha: 0.8),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(2, 0),
            ),
          ],
        ),
        child: content,
      );
    }

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: SafeArea(child: content),
    );
  }
}

class _SidebarContent extends StatelessWidget {
  final bool isPermanent;
  final DashboardController dashboardController;
  final AuthController authController;
  final ProfileController profileController;

  const _SidebarContent({
    required this.isPermanent,
    required this.dashboardController,
    required this.authController,
    required this.profileController,
  });

  void _onNavigationTap(BuildContext context, int tabIndex) {
    if (!isPermanent && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    dashboardController.switchTab(tabIndex);
  }

  void _onRouteTap(BuildContext context, Widget targetPage) {
    if (!isPermanent && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Get.to(() => targetPage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Brand Header & Logo
        _buildBrandHeader(),

        // User Profile Summary Card
        _buildProfileCard(),

        const Divider(height: 1, color: borderColor),

        // Scrollable Menu Items
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('MAIN MENU'),
                const SizedBox(height: 6),
                Obx(
                  () => _buildMenuItem(
                    context: context,
                    index: 0,
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    isSelected: dashboardController.currentIndex.value == 0,
                    onTap: () => _onNavigationTap(context, 0),
                  ),
                ),
                Obx(
                  () => _buildMenuItem(
                    context: context,
                    index: 1,
                    icon: Icons.meeting_room_rounded,
                    title: 'Room Management',
                    isSelected: dashboardController.currentIndex.value == 1,
                    onTap: () => _onNavigationTap(context, 1),
                  ),
                ),
                Obx(
                  () => _buildMenuItem(
                    context: context,
                    index: 2,
                    icon: Icons.domain_add_rounded,
                    title: 'Property Listing',
                    isSelected: dashboardController.currentIndex.value == 2,
                    onTap: () => _onNavigationTap(context, 2),
                  ),
                ),
                Obx(
                  () => _buildMenuItem(
                    context: context,
                    index: 3,
                    icon: Icons.receipt_long_rounded,
                    title: 'Recent Bookings',
                    isSelected: dashboardController.currentIndex.value == 3,
                    onTap: () => _onNavigationTap(context, 3),
                  ),
                ),
                Obx(
                  () => _buildMenuItem(
                    context: context,
                    index: 4,
                    icon: Icons.person_outline_rounded,
                    title: 'Profile Settings',
                    isSelected: dashboardController.currentIndex.value == 4,
                    onTap: () => _onNavigationTap(context, 4),
                  ),
                ),

                const SizedBox(height: 16),
                _buildSectionHeader('FINANCE & TOOLS'),
                const SizedBox(height: 6),
                _buildMenuItem(
                  context: context,
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'Withdraw Money',
                  accentColor: const Color(0xFF10B981),
                  onTap: () => _onRouteTap(context, const WalletWithdrawPage()),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.card_membership_rounded,
                  title: 'Subscriptions',
                  accentColor: const Color(0xFF3B82F6),
                  onTap:
                      () => _onRouteTap(context, const QuickTechPackagePage()),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.history_edu_rounded,
                  title: 'Booking Orders',
                  accentColor: const Color(0xFF8B5CF6),
                  onTap:
                      () => _onRouteTap(
                        context,
                        const QuickTechBookingListPage(),
                      ),
                ),

                const SizedBox(height: 16),
                _buildSectionHeader('SUPPORT & LEGAL'),
                const SizedBox(height: 6),
                _buildMenuItem(
                  context: context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {
                    final data = dashboardController.getPageByName(
                      'Privacy and Policy',
                    );
                    if (data != null) {
                      _onRouteTap(
                        context,
                        QuickTechCustomHtmlTextView(
                          title: data.pageName ?? 'Privacy Policy',
                          desc: data.description ?? '',
                        ),
                      );
                    }
                  },
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.support_agent_rounded,
                  title: 'Help & Support',
                  onTap: () {
                    final data = dashboardController.getPageByName('Help');
                    if (data != null) {
                      _onRouteTap(
                        context,
                        QuickTechCustomHtmlTextView(
                          title: data.pageName ?? 'Help & Support',
                          desc: data.description ?? '',
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 20),
                // Social Platform Icons
                _buildSocialSection(),
              ],
            ),
          ),
        ),

        const Divider(height: 1, color: borderColor),

        // Logout Action Button
        _buildLogoutButton(context),
      ],
    );
  }

  Widget _buildBrandHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: mainColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/logo.png',
              width: 26,
              height: 26,
              errorBuilder:
                  (_, __, ___) => const Icon(
                    Icons.home_work_rounded,
                    color: Colors.black,
                    size: 24,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Renth',
                    style: QuickTechAppTextStyle.headline3().copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: mainColorLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'PARTNER',
                      style: QuickTechAppTextStyle.caption().copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Property & Rental Portal',
                style: QuickTechAppTextStyle.caption().copyWith(
                  fontSize: 11,
                  color: textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Obx(() {
      final user = profileController.profile.value.user;
      final isLoading = profileController.isLoading.value;

      if (isLoading) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade50,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                WebSafeNetworkImage(
                  imageUrl: user?.profilePhoto,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  isCircle: true,
                  errorWidget: CircleAvatar(
                    radius: 20,
                    backgroundColor: mainColorLight,
                    child: Text(
                      (user?.name?.isNotEmpty ?? false)
                          ? user!.name![0].toUpperCase()
                          : 'O',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: successColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Property Owner',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: QuickTechAppTextStyle.bodyBold3().copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user?.phone ?? user?.email ?? 'Verified Manager',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: QuickTechAppTextStyle.caption().copyWith(
                      fontSize: 11,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Text(
        label,
        style: QuickTechAppTextStyle.caption().copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
          color: textMuted,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    int? index,
    bool isSelected = false,
    Color? accentColor,
  }) {
    return _HoverableMenuItem(
      icon: icon,
      title: title,
      isSelected: isSelected,
      accentColor: accentColor,
      onTap: onTap,
    );
  }

  Widget _buildSocialSection() {
    return Obx(() {
      final socialMedia =
          dashboardController.pageDetails.value.socialMedia ?? [];
      if (socialMedia.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('CONNECT WITH US'),
          const SizedBox(height: 8),
          Row(
            children:
                socialMedia.map((social) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          if (social.link != null && social.link!.isNotEmpty) {
                            final Uri url = Uri.parse(social.link!);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          }
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: WebSafeNetworkImage(
                            imageUrl: social.iconImage,
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            errorWidget: const Icon(Icons.public, size: 16),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      );
    });
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              Get.defaultDialog(
                title: 'Sign Out',
                titleStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                middleText:
                    'Are you sure you want to log out from Renth Manager?',
                middleTextStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                ),
                radius: 14,
                barrierDismissible: false,
                confirm: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    debugPrint('Gandu');
                    Get.back();
                    await authController.googleLogout();
                  },
                  child: const Text('Yes, Sign Out'),
                ),
                cancel: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade100),
                color: Colors.red.shade50.withValues(alpha: 0.5),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: Colors.red.shade600,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Log Out',
                    style: QuickTechAppTextStyle.bodyBold3().copyWith(
                      color: Colors.red.shade700,
                      fontSize: 13,
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

class _HoverableMenuItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final Color? accentColor;
  final VoidCallback onTap;

  const _HoverableMenuItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    this.accentColor,
    required this.onTap,
  });

  @override
  State<_HoverableMenuItem> createState() => _HoverableMenuItemState();
}

class _HoverableMenuItemState extends State<_HoverableMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeBg = navItemActiveBg;
    final hoverBg = navItemHoverColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color:
                widget.isSelected
                    ? activeBg
                    : (_isHovered ? hoverBg : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  widget.isSelected
                      ? navItemActiveBorder.withValues(alpha: 0.4)
                      : Colors.transparent,
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color:
                            widget.isSelected
                                ? mainColor
                                : (widget.accentColor?.withValues(
                                      alpha: 0.12,
                                    ) ??
                                    (_isHovered
                                        ? Colors.grey.shade200
                                        : Colors.grey.shade100)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 16,
                        color:
                            widget.isSelected
                                ? Colors.black
                                : (widget.accentColor ??
                                    (_isHovered ? textColor : textMuted)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: QuickTechAppTextStyle.bodyBold3().copyWith(
                          fontSize: 13,
                          fontWeight:
                              widget.isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                          color:
                              widget.isSelected
                                  ? textColor
                                  : (_isHovered
                                      ? textColor
                                      : const Color(0xFF334155)),
                        ),
                      ),
                    ),
                    if (widget.isSelected)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: mainColorDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
