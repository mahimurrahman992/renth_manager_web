import 'package:renth_manager/consts/consts.dart';

class QuickTechRoomManagementScreen extends StatelessWidget {
  final bool showAppBar;
  QuickTechRoomManagementScreen({super.key, this.showAppBar = false});

  final dashboardController = locator.get<DashboardController>();
  final roomController = locator.get<QuickTechRoomController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _onRefresh() async {
    final rawPropertyId = GetStorage().read(StorageKeys.selectedPropertyId);
    final propertyId = int.tryParse(rawPropertyId?.toString() ?? '');
    await dashboardController.getManagerDashboard();

    if (propertyId != null) {
      await roomController.fetchRoomRecords(propertyId: propertyId);
    }
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Room Management',
                style: QuickTechAppTextStyle.headline4().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              12.verticalSpace,
              QuickTechRoomManagementTable(),
              16.verticalSpace,
              Text(
                'Inventory Quick Adjust',
                style: QuickTechAppTextStyle.headline4().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              12.verticalSpace,

              // Main Fetching Loading indicator block
              Obx(() {
                if (roomController.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final records =
                    roomController.roomList.value.propertyRoomRecords ?? [];

                if (records.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("No Room Records Registered"),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: records.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var data = records[index];
                    int recordId = data.id ?? 0;
                    int maxRooms = data.totalRoom ?? 100;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 14.h,
                          horizontal: 16.w,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                data.roomType?.name ?? "N/A",
                                style: QuickTechAppTextStyle.bodyText4()
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              'Available',
                              style: QuickTechAppTextStyle.bodyText4(),
                            ),
                            SizedBox(width: 16.w),

                            Obx(() {
                              int currentCount =
                                  roomController
                                      .localAvailableRooms[recordId] ??
                                  (data.availableRoom ?? 0);

                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Row(
                                  children: [
                                    // Minus Button
                                    InkWell(
                                      onTap:
                                          currentCount > 0
                                              ? () => roomController
                                                  .decrementLocalRoom(
                                                    recordId,
                                                    currentCount,
                                                  )
                                              : () {},
                                      child: Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          border: Border(
                                            right: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          size: 18.sp,
                                          color:
                                              currentCount > 0
                                                  ? Colors.black87
                                                  : Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                    // Value display text
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 8.h,
                                      ),
                                      child: Text(
                                        '$currentCount',
                                        style: QuickTechAppTextStyle.bodyText4()
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    // Plus Button
                                    InkWell(
                                      onTap:
                                          currentCount < maxRooms
                                              ? () => roomController
                                                  .incrementLocalRoom(
                                                    recordId,
                                                    currentCount,
                                                    maxRooms,
                                                  )
                                              : () {},
                                      child: Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          border: Border(
                                            left: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: 18.sp,
                                          color:
                                              currentCount < maxRooms
                                                  ? Colors.black87
                                                  : Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            SizedBox(width: 12.w),

                            Obx(() {
                              int currentCount =
                                  roomController
                                      .localAvailableRooms[recordId] ??
                                  (data.availableRoom ?? 0);

                              bool isThisItemUpdating =
                                  roomController.updatingRecordIds[recordId] ??
                                  false;

                              bool hasChanged = roomController
                                  .localAvailableRooms
                                  .containsKey(recordId);

                              return isThisItemUpdating
                                  ? const SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : ElevatedButton(
                                    onPressed:
                                        !hasChanged
                                            ? null
                                            : () {
                                              final rawPropertyId = GetStorage()
                                                  .read(
                                                    StorageKeys
                                                        .selectedPropertyId,
                                                  );
                                              final propertyId =
                                                  int.tryParse(
                                                    rawPropertyId?.toString() ??
                                                        '',
                                                  ) ??
                                                  0;
                                              roomController
                                                  .updateRoomInventory(
                                                    recordId,
                                                    currentCount,
                                                    propertyId,
                                                  );
                                            },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          hasChanged
                                              ? mainColor
                                              : Colors.grey.shade200,
                                      foregroundColor: Colors.black87,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14.w,
                                        vertical: 8.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Update',
                                      style: QuickTechAppTextStyle.bodyText4()
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
              40.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!showAppBar) {
      return _buildBody(context);
    }

    return Scaffold(
      drawer: const CustomDrawer(isPermanentSidebar: false),
      key: _scaffoldKey,
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
