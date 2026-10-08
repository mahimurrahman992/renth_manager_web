
import '../../../consts/consts.dart';

class QuickTechHomeDashboardOverview extends StatelessWidget {
  const QuickTechHomeDashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = locator.get<DashboardController>();

    return Obx(() {
      if (dashboardController.isLoading.value) {
        return _buildLoadingGrid(context);
      }

      final items = [
        _OverviewItemData(
          title: 'Total Revenue',
          value: '৳ ${dashboardController.dashboard.value.totalRevenue ?? '0'}',
          icon: Icons.account_balance_wallet_rounded,
          accentColor: const Color(0xFF10B981), // Emerald Green
          bgColor: const Color(0xFFECFDF5),
        ),
        _OverviewItemData(
          title: 'Total Booking/Flat',
          value: '${dashboardController.dashboard.value.totalBooking ?? 0}',
          icon: Icons.calendar_month_rounded,
          accentColor: const Color(0xFF3B82F6), // Blue
          bgColor: const Color(0xFFEFF6FF),
        ),
        _OverviewItemData(
          title: 'Total Room/Flat',
          value: dashboardController.dashboard.value.totalRoom ?? '0',
          icon: Icons.meeting_room_rounded,
          accentColor: const Color(0xFF8B5CF6), // Purple
          bgColor: const Color(0xFFF5F3FF),
          onTap: () {
            final rawId = GetStorage().read(StorageKeys.selectedPropertyId);
            final propertyId = int.tryParse(rawId?.toString() ?? '') ?? 0;
            if (propertyId <= 0) {
              Get.snackbar(
                "Error",
                "Please select a property first.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.redAccent.withValues(alpha:0.8),
                colorText: Colors.white,
              );
              return;
            }
            debugPrint('Navigating to Room Screen for propertyId: $propertyId');
            Get.toNamed(
              AppRoutes.roomScreen,
              arguments: propertyId,
            );
          },
        ),
        _OverviewItemData(
          title: 'Available Rooms/Flat',
          value: dashboardController.dashboard.value.availableRoom ?? '0',
          icon: Icons.door_front_door_rounded,
          accentColor: const Color(0xFFF59E0B), // Amber
          bgColor: const Color(0xFFFFFBEB),
        ),
        _OverviewItemData(
          title: 'Occupancy Rate',
          value: '${dashboardController.dashboard.value.occupancyRate ?? 0}%',
          icon: Icons.pie_chart_rounded,
          accentColor: const Color(0xFFEC4899), // Pink
          bgColor: const Color(0xFFFDF2F8),
        ),
      ];

      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1050) {
            return _DesktopOverviewWidget(items: items);
          } else if (constraints.maxWidth >= 550) {
            return _TabletOverviewWidget(items: items);
          } else {
            return _MobileOverviewWidget(items: items);
          }
        },
      );
    });
  }

  Widget _buildLoadingGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 1050
            ? 5
            : (constraints.maxWidth >= 720 ? 3 : 2);

        return GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: count == 5 ? 5 : (count == 3 ? 6 : 4),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            mainAxisExtent: 110,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor.withValues(alpha: 0.5)),
              ),
              padding: const EdgeInsets.all(16),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(width: 80, height: 12, color: Colors.white),
                    Container(width: 110, height: 18, color: Colors.white),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Screen Size Specific Widgets
// ---------------------------------------------------------------------------

/// Desktop Layout (5 items in a single row or balanced responsive grid)
class _DesktopOverviewWidget extends StatelessWidget {
  final List<_OverviewItemData> items;
  const _DesktopOverviewWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 125,
      ),
      itemBuilder: (context, index) {
        return _ModernStatCard(item: items[index], isCompact: false);
      },
    );
  }
}

/// Tablet Layout (3 columns on wide tablet, 2 columns on compact tablet)
class _TabletOverviewWidget extends StatelessWidget {
  final List<_OverviewItemData> items;
  const _TabletOverviewWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth >= 720 ? 3 : 2;

        return GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            mainAxisExtent: 120,
          ),
          itemBuilder: (context, index) {
            return _ModernStatCard(item: items[index], isCompact: cols == 2);
          },
        );
      },
    );
  }
}

/// Mobile Layout (2 columns)
class _MobileOverviewWidget extends StatelessWidget {
  final List<_OverviewItemData> items;
  const _MobileOverviewWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 115,
      ),
      itemBuilder: (context, index) {
        return _ModernStatCard(item: items[index], isCompact: true);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Modern Stat Card Component
// ---------------------------------------------------------------------------

class _ModernStatCard extends StatefulWidget {
  final _OverviewItemData item;
  final bool isCompact;

  const _ModernStatCard({required this.item, this.isCompact = false});

  @override
  State<_ModernStatCard> createState() => _ModernStatCardState();
}

class _ModernStatCardState extends State<_ModernStatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor:
          widget.item.onTap != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(0.0, _isHovered ? -3.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                _isHovered
                    ? widget.item.accentColor.withValues(alpha: 0.5)
                    : borderColor.withValues(alpha: 0.6),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  _isHovered
                      ? widget.item.accentColor.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.03),
              blurRadius: _isHovered ? 14 : 8,
              offset: Offset(0, _isHovered ? 6 : 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: widget.item.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isCompact ? 12 : 14,
                vertical: widget.isCompact ? 10 : 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.item.bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          widget.item.icon,
                          color: widget.item.accentColor,
                          size: widget.isCompact ? 18 : 20,
                        ),
                      ),
                      if (widget.item.onTap != null)
                        Icon(
                          Icons.arrow_outward_rounded,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: QuickTechAppTextStyle.subtitle().copyWith(
                      fontSize: widget.isCompact ? 11 : 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.item.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: QuickTechAppTextStyle.headline4().copyWith(
                      fontSize: widget.isCompact ? 16 : 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
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

class _OverviewItemData {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final Color bgColor;
  final VoidCallback? onTap;

  _OverviewItemData({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.bgColor,
    this.onTap,
  });
}
