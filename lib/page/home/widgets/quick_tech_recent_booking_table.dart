import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renth_manager/consts/color.dart';
import 'package:renth_manager/controller/quick_tech_booking_order_controller.dart';
import 'package:renth_manager/controller/quick_tech_dashboard_controller.dart';
import 'package:renth_manager/locator.dart';
import 'package:renth_manager/model/DashboardModel.dart';
import 'package:renth_manager/widgets/quick_tech_app_text_style.dart';

class QuickTechRecentBookingTable extends StatelessWidget {
  QuickTechRecentBookingTable({super.key});

  final dashboardController = locator.get<DashboardController>();
  final BookingOrderController bookingOrderController =
      locator.get<BookingOrderController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Card Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 650;

                final titleRow = Row(
                  mainAxisSize: isNarrow ? MainAxisSize.max : MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: mainColor.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Bookings',
                            style: QuickTechAppTextStyle.headline4().copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Transactions and guest booking records',
                            style: QuickTechAppTextStyle.caption().copyWith(
                              fontSize: 12,
                              color: textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                );

                final actions = Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Obx(() {
                      final count = dashboardController.allBookings.length;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$count Bookings',
                          style: QuickTechAppTextStyle.bodyBold3().copyWith(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      );
                    }),
                    // Export to CSV button
                    OutlinedButton.icon(
                      onPressed: () => dashboardController.exportBookingsToCsv(),
                      icon: const Icon(Icons.download_rounded, size: 14, color: Colors.black87),
                      label: const Text('Export CSV', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: const BorderSide(color: borderColor),
                      ),
                    ),
                    // View all shortcut
                    TextButton.icon(
                      onPressed: () => dashboardController.switchTab(3),
                      icon: const Icon(Icons.tune_rounded, size: 14, color: textColor),
                      label: const Text('Filter & Search', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                    ),
                  ],
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleRow,
                      const SizedBox(height: 12),
                      actions,
                    ],
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: titleRow),
                    const SizedBox(width: 16),
                    actions,
                  ],
                );
              },
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Table Content or Empty State
          Obx(() {
            final bookings = dashboardController.allBookings;

            if (bookings.isEmpty) {
              return _buildEmptyState();
            }

            return SizedBox(
              width: double.infinity,
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerTheme: DividerThemeData(
                    color: borderColor.withValues(alpha: 0.5),
                    thickness: 1,
                  ),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        const Color(0xFFF8FAFC),
                      ),
                      dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.hovered)) {
                            return const Color(0xFFF1F5F9);
                          }
                          return Colors.white;
                        },
                      ),
                      columnSpacing: 28,
                      horizontalMargin: 20,
                      headingTextStyle: QuickTechAppTextStyle.bodyBold3().copyWith(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      columns: const [
                        DataColumn(label: Text('Invoice / ID')),
                        DataColumn(label: Text('Guest Name')),
                        DataColumn(label: Text('Room Type')),
                        DataColumn(label: Text('Duration (In - Out)')),
                        DataColumn(label: Text('Total Amount')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: bookings.map((booking) {
                        return DataRow(
                          cells: [
                            // Invoice ID
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '#${booking.invoiceNo ?? 'N/A'}',
                                  style: QuickTechAppTextStyle.bodyBold3().copyWith(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),

                            // Guest Name
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: mainColorLight,
                                    child: Text(
                                      (booking.customer?.name?.isNotEmpty ?? false)
                                          ? booking.customer!.name![0].toUpperCase()
                                          : 'G',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    booking.customer?.name ?? 'Guest',
                                    style: QuickTechAppTextStyle.bodyBold3().copyWith(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Room Type
                            DataCell(
                              Text(
                                booking.roomType?.name ?? 'Standard',
                                style: QuickTechAppTextStyle.bodyText3().copyWith(
                                  fontSize: 13,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),

                            // Duration Dates
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 13,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${booking.checkInStart?.toString().split(' ').first ?? ''} → ${booking.checkOutEnd?.toString().split(' ').first ?? ''}',
                                    style: QuickTechAppTextStyle.bodyText4().copyWith(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Total Amount
                            DataCell(
                              Text(
                                '৳${booking.grandTotal ?? '0'}',
                                style: QuickTechAppTextStyle.price().copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            // Status Badge
                            DataCell(
                              _buildStatusBadge(booking.status ?? 'Pending'),
                            ),

                            // Actions Popup
                            DataCell(
                              _buildActionMenu(context, booking),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Empty State Widget
  // ---------------------------------------------------------------------------
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(color: borderColor.withValues(alpha: 0.6)),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 40,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'No Recent Bookings',
              style: QuickTechAppTextStyle.headline4().copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'New reservations and bookings will appear here.',
              style: QuickTechAppTextStyle.subtitle().copyWith(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Modern Status Pill Badge
  // ---------------------------------------------------------------------------
  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;
    Color dot;

    switch (status.toLowerCase()) {
      case 'confirmed':
        bg = badgeGreenBg;
        text = badgeGreenText;
        dot = successColor;
        break;
      case 'pending':
        bg = badgeOrangeBg;
        text = badgeOrangeText;
        dot = warningColor;
        break;
      case 'cancelled':
      case 'canceled':
        bg = badgeRedBg;
        text = badgeRedText;
        dot = errorColor;
        break;
      default:
        bg = badgeBlueBg;
        text = badgeBlueText;
        dot = infoColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: QuickTechAppTextStyle.bodyBold3().copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Modern Action Button with Popup Menu
  // ---------------------------------------------------------------------------
  Widget _buildActionMenu(BuildContext context, Datum booking) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'View') {
          _showBookingOverview(context, booking);
        } else if (value == 'Confirm' || value == 'Cancel') {
          final newStatus = value == 'Confirm' ? 'Confirmed' : 'Cancelled';
          try {
            await bookingOrderController.updateBookingStatus(
              bookingId: booking.id ?? 0,
              status: newStatus,
            );
            await dashboardController.getManagerDashboard();
            Get.snackbar(
              'Success',
              'Booking status updated to $newStatus',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.black87,
              colorText: Colors.white,
            );
          } catch (e) {
            Get.snackbar(
              'Error',
              'Failed to update status: $e',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade700,
              colorText: Colors.white,
            );
          }
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'View',
          child: Row(
            children: [
              const Icon(Icons.visibility_outlined, size: 18, color: Colors.black87),
              const SizedBox(width: 10),
              Text('View Details', style: QuickTechAppTextStyle.bodyBold3()),
            ],
          ),
        ),
        if (booking.status?.toLowerCase() == 'pending')
          PopupMenuItem(
            value: 'Confirm',
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF059669)),
                const SizedBox(width: 10),
                Text(
                  'Confirm Booking',
                  style: QuickTechAppTextStyle.bodyBold3().copyWith(
                    color: const Color(0xFF059669),
                  ),
                ),
              ],
            ),
          ),
        if (booking.status?.toLowerCase() == 'pending')
          PopupMenuItem(
            value: 'Cancel',
            child: Row(
              children: [
                const Icon(Icons.cancel_outlined, size: 18, color: Color(0xFFDC2626)),
                const SizedBox(width: 10),
                Text(
                  'Cancel Booking',
                  style: QuickTechAppTextStyle.bodyBold3().copyWith(
                    color: const Color(0xFFDC2626),
                  ),
                ),
              ],
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.more_vert_rounded, size: 18, color: Colors.black87),
      ),
    );
  }

  void _showBookingOverview(BuildContext context, Datum booking) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking #${booking.invoiceNo ?? 'N/A'}',
                      style: QuickTechAppTextStyle.headline3().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _detailRow('Guest Name', booking.customer?.name ?? 'N/A'),
                _detailRow('Room Type', booking.roomType?.name ?? 'Standard'),
                _detailRow('Check-in', booking.checkInStart?.toString().split(' ').first ?? 'N/A'),
                _detailRow('Check-out', booking.checkOutEnd?.toString().split(' ').first ?? 'N/A'),
                _detailRow('Grand Total', '৳${booking.grandTotal ?? '0'}'),
                _detailRow('Status', booking.status ?? 'Pending'),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: textMuted, fontSize: 13)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
