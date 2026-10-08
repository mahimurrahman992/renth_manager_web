import 'package:renth_manager/consts/consts.dart';

class QuickTechBookingListPage extends StatefulWidget {
  const QuickTechBookingListPage({super.key});

  @override
  State<QuickTechBookingListPage> createState() =>
      _QuickTechBookingListPageState();
}

class _QuickTechBookingListPageState extends State<QuickTechBookingListPage> {
  final BookingOrderController bookingOrderController =
      locator.get<BookingOrderController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bookingOrderController.fetchBookingOrders();
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
            return BookingMobileView(controller: bookingOrderController);
          } else if (width < 1024) {
            return BookingTabletView(controller: bookingOrderController);
          } else {
            return BookingDesktopView(controller: bookingOrderController);
          }
        },
      ),
    );
  }
}

class BookingMobileView extends StatelessWidget {
  final BookingOrderController controller;

  const BookingMobileView({super.key, required this.controller});

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
                  const BookingBackButton(light: true),
                  14.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Orders',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          'Track fees and withdraw requests',
                          style: TextStyle(
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
                      await controller.fetchBookingOrders();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
                      child: BookingListContent(
                        controller: controller,
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

class BookingTabletView extends StatelessWidget {
  final BookingOrderController controller;

  const BookingTabletView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const BookingTopBar(horizontalPadding: 24),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchBookingOrders();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 860),
                    child: BookingListContent(
                      controller: controller,
                      columns: 2,
                    ),
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

class BookingDesktopView extends StatelessWidget {
  final BookingOrderController controller;

  const BookingDesktopView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const BookingTopBar(horizontalPadding: 40),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchBookingOrders();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 28.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: BookingListContent(
                      controller: controller,
                      columns: 3,
                    ),
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

class BookingListContent extends StatelessWidget {
  final BookingOrderController controller;
  final int columns;

  const BookingListContent({
    super.key,
    required this.controller,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final orders = controller.bookingList.value.bookingOrders ?? [];

      if (orders.isEmpty) {
        return const BookingEmptyState();
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          const double gap = 16;
          final double cardWidth =
              (constraints.maxWidth - gap * (columns - 1)) / columns;

          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: List.generate(orders.length, (index) {
              final item = orders[index];

              return SizedBox(
                width: cardWidth,
                child: BookingCard(
                  item: item,
                  onTap: () => showBookingActions(context, controller, item),
                ).animate().fadeIn(
                  duration: 300.ms,
                  delay: (index * 60).ms,
                ),
              );
            }),
          );
        },
      );
    });
  }
}

class BookingCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onTap;

  const BookingCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool paymentPending = item.managerPaymentStatus == '0';
    final bool requestSent = item.withdrawRequestStatus != '0';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: mainColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Ionicons.business_outline,
                        color: mainColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.property?.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Ionicons.person_circle_outline,
                      size: 20,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.customer?.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: BookingFeeBox(
                        label: 'Partner Fee',
                        value: '${item.managerFee} Tk',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BookingFeeBox(
                        label: 'Platform Fee',
                        value: '${item.adminFee} Tk',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    BookingStatusChip(
                      label: paymentPending ? 'Payment Pending' : 'Payment Approved',
                      color: paymentPending ? Colors.red : Colors.green,
                    ),
                    BookingStatusChip(
                      label: requestSent
                          ? 'Withdraw Requested'
                          : 'No Withdraw Request',
                      color: requestSent ? Colors.blue : Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Manage withdraw',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF6B7280),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookingFeeBox extends StatelessWidget {
  final String label;
  final String value;

  const BookingFeeBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingStatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const BookingStatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class BookingEmptyState extends StatelessWidget {
  const BookingEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 220,
              height: 220,
              child: Lottie.asset('assets/icons/empty.json'),
            ),
            const SizedBox(height: 12),
            Text(
              'No booking orders yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showBookingActions(
  BuildContext context,
  BookingOrderController controller,
  dynamic item,
) {
  final content = BookingActionsContent(controller: controller, item: item);
  final bool isMobile = MediaQuery.of(context).size.width < 600;

  if (isMobile) {
    Get.bottomSheet(
      SafeArea(child: content),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
    return;
  }

  Get.dialog(
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: content,
      ),
    ),
  );
}

class BookingActionsContent extends StatelessWidget {
  final BookingOrderController controller;
  final dynamic item;

  const BookingActionsContent({
    super.key,
    required this.controller,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Withdraw Options',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.property?.title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          customButton(
            title: 'Request For Withdraw',
            onPressed: () {
              controller.changeWithdrawStatus(id: item.id, status: 1);
              Get.back();
            },
            color: secondColor,
            txtColor: white,
          ),
          const SizedBox(height: 14),
          customButton(
            title: 'Cancel Request',
            onPressed: () {
              controller.changeWithdrawStatus(id: item.id, status: 0);
              Get.back();
            },
            color: secondColor,
            txtColor: white,
          ),
        ],
      ),
    );
  }
}

class BookingTopBar extends StatelessWidget {
  final double horizontalPadding;

  const BookingTopBar({super.key, required this.horizontalPadding});

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
          const BookingBackButton(light: false),
          16.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking Orders',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
              2.verticalSpace,
              Text(
                'Track fees and withdraw requests',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookingBackButton extends StatelessWidget {
  final bool light;

  const BookingBackButton({super.key, required this.light});

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