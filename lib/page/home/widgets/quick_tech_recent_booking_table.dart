import 'package:renth_manager/model/DashboardModel.dart';

import '../../../consts/consts.dart';

class QuickTechRecentBookingTable extends StatelessWidget {
  QuickTechRecentBookingTable({super.key});

  final dashboardController = locator.get<DashboardController>();
  final BookingOrderController bookingOrderController =
      locator.get<BookingOrderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: DividerThemeData(color: mainColor, thickness: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  mainColor,
                ),
                border: TableBorder(
                  verticalInside: BorderSide(color: mainColor),
                ),

                dividerThickness: 1,
                dataRowColor: WidgetStateProperty.all(Colors.white),
                columnSpacing: 20.w,
                horizontalMargin: 15.w,
                columns: [
                  DataColumn(
                    label: Text(
                      'Booking ID', textAlign: TextAlign.center,
                      style: QuickTechAppTextStyle.bodyText4().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Guest Name', textAlign: TextAlign.center,
                      style: QuickTechAppTextStyle.bodyText4().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Room Type', textAlign: TextAlign.center,
                      style: QuickTechAppTextStyle.bodyText4().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Dates', textAlign: TextAlign.center,
                      style: QuickTechAppTextStyle.bodyText4().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Amount',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status', textAlign: TextAlign.center,
                      style: QuickTechAppTextStyle.bodyText4().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Action', textAlign: TextAlign.center,
                      style: QuickTechAppTextStyle.bodyText4().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows:
                    dashboardController.allBookings.map((
                      booking,
                    ) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              booking.invoiceNo.toString(),
                              style: QuickTechAppTextStyle.bodyText4(),
                            ),
                          ),
                          DataCell(
                            Text(
                              booking.customer?.name ?? '',
                              style: QuickTechAppTextStyle.bodyText4(),
                            ),
                          ),
                          DataCell(
                            Text(
                              booking.roomType?.name ?? '',
                              style: QuickTechAppTextStyle.bodyText4(),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${booking.checkInStart?.toString().split(' ').first ?? ''} - ${booking.checkOutEnd?.toString().split(' ').first ?? ''}',
                              style: QuickTechAppTextStyle.bodyText4(),
                            ),
                          ),
                          DataCell(
                            Text(
                              booking.grandTotal ?? '',
                              style: QuickTechAppTextStyle.bodyText4(),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12.w,
                              ),
                              decoration: BoxDecoration(
                                color: dashboardController.getStatusBgColor(
                                  booking.status ?? '',
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                booking.status ?? '',
                                style: QuickTechAppTextStyle.bodyText4(),
                              ),
                            ),
                          ),
                          DataCell(
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'View') {
                                  _showBookingOverview(context, booking);
                                } else if (value == 'Confirm' ||
                                    value == 'Cancel') {
                                  String newStatus =
                                      value == 'Confirm'
                                          ? 'Confirmed'
                                          : 'Cancelled';
                                  try {
                                    await bookingOrderController
                                        .updateBookingStatus(
                                          bookingId: booking.id ?? 0,
                                          status: newStatus,
                                        );
                                    await dashboardController
                                        .getManagerDashboard();
                                    Get.snackbar(
                                      'Success',
                                      'Booking status updated to $newStatus',
                                    );
                                  } catch (e) {
                                    print(e);
                                    Get.snackbar(
                                      'Error',
                                      'Failed to update status: $e',
                                    );
                                  }
                                }
                              },
                              itemBuilder:
                                  (context) => [
                                    const PopupMenuItem(
                                      value: 'View',
                                      child: Text('View'),
                                    ),
                                    if (booking.status?.toLowerCase() ==
                                        'pending')
                                      const PopupMenuItem(
                                        value: 'Confirm',
                                        child: Text('Confirm Booking'),
                                      ),
                                    if (booking.status?.toLowerCase() ==
                                        'pending')
                                      const PopupMenuItem(
                                        value: 'Cancel',
                                        child: Text('Cancel Booking'),
                                      ),
                                  ],
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12.w,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Action',
                                  style: QuickTechAppTextStyle.bodyText4()
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBookingOverview(BuildContext context,Datum booking) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
  children: [
    Expanded(
      child: Text(
        'Booking Overview',
        overflow: TextOverflow.ellipsis,
        style: QuickTechAppTextStyle.headline4(),
      ),
    ),
    IconButton(
      onPressed: () => Get.back(),
      icon: const Icon(Icons.close),
    ),
  ],
),
            const Divider(),
            10.verticalSpace,
            _buildInfoRow('Invoice No:', booking.invoiceNo ?? 'N/A',null),
            _buildInfoRow('Guest Name:', booking.customer?.name ?? 'N/A',null),
            _buildInfoRow('Room Type:', booking.roomType?.name ?? 'N/A',null),
            _buildInfoRow(
              'Check In:',
              booking.checkInStart.toString(),null
            ),
            _buildInfoRow(
              'Check Out:',
              booking.checkOutEnd.toString(),null
            ),
            _buildInfoRow('Total Amount:', '৳${booking.grandTotal ?? '0'}',null),
            _buildInfoRow('Status:', booking.status ?? 'N/A',dashboardController.getStatusColor(booking.status??'')),
            20.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: mainColor,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onPressed: () => Get.back(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

Widget _buildInfoRow(String label, String value, Color? color) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 120.w),
          child: Text(
            label,
            style: QuickTechAppTextStyle.bodyText4()
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            softWrap: true,
            style: QuickTechAppTextStyle.bodyText4().copyWith(color: color),
          ),
        ),
      ],
    ),
  );
}
}
