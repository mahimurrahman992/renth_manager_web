import '../../consts/consts.dart';
import '../../controller/quick_tech_property_room_store_controller.dart';
import '../../model/response/quickech_get_room_data.dart';


class QuickTechRecentBookingScreen extends StatefulWidget {
  final bool showAppBar;
  const QuickTechRecentBookingScreen({super.key, this.showAppBar = false});

  @override
  State<QuickTechRecentBookingScreen> createState() => _QuickTechRecentBookingScreenState();
}

class _QuickTechRecentBookingScreenState extends State<QuickTechRecentBookingScreen> {
  final dashboardController = locator.get<DashboardController>();
  final commonController = locator.get<CommonController>();
  final roomController = locator.get<QuickTechPropertyRoomController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      roomController.selectedRoomType.value = null;
      roomController.selectedStatus.value = null;
      dashboardController.getManagerDashboard();
    });
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      controller: dashboardController.scrollController,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Management & Filters',
              style: QuickTechAppTextStyle.headline4().copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            8.verticalSpace,
            // Main Filter Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and clear button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.filter_alt_outlined,
                            size: 22.h,
                            color: Colors.black87,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Filters',
                            style: QuickTechAppTextStyle.headline1().copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          roomController.selectedRoomType.value = null;
                          roomController.selectedStatus.value = null;
                          roomController.startDate.value = null;
                          roomController.endDate.value = null;
                          dashboardController.getManagerDashboard();
                        },
                        icon: Icon(Icons.clear_all, size: 18.h, color: Colors.grey[600]),
                        label: Text(
                          'Clear All',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Date Range Row (Start Date & End Date)
                  Row(
                    children: [
                      // Start Date Field
                      Expanded(
                        child: Obx(() {
                          return _buildDateField(
                            label: 'Start Date',
                            hint: roomController.startDate.value ?? 'Select date',
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                roomController.startDate.value =
                                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                              }
                            },
                          );
                        }),
                      ),

                      SizedBox(width: 12.w),

                      // End Date Field
                      Expanded(
                        child: Obx(() {
                          return _buildDateField(
                            label: 'End Date',
                            hint: roomController.endDate.value ?? 'Select date',
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                roomController.endDate.value =
                                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                              }
                            },
                          );
                        }),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Room Type and Status Row
                  Row(
                    children: [
                      // Room Type Dropdown
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Room Type',
                          hint: 'Select Room Type',
                          child: Obx(() {
                            return DropdownButton<Type>(
                              isExpanded: true,
                              underline: SizedBox(),
                              hint: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Text(
                                  "Select Room Type",
                                  style: QuickTechAppTextStyle.bodyText4().copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                              items: commonController.roomTypes.map((item) {
                                return DropdownMenuItem<Type>(
                                  value: item,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Text(
                                      item.name ?? "",
                                      style: QuickTechAppTextStyle.bodyText4(),
                                    ),
                                  ),
                                );
                              }).toList(),
                              value: roomController.selectedRoomType.value,
                              onChanged: (value) {
                                roomController.selectedRoomType.value = value;
                              },
                            ).h(45);
                          }),
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // Status Dropdown
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Status',
                          hint: 'Select Status',
                          child: Obx(() {
                            return DropdownButton<String>(
                              isExpanded: true,
                              underline: SizedBox(),
                              hint: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Text(
                                  "Select Status",
                                  style: QuickTechAppTextStyle.bodyText4().copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                              items: [
                                DropdownMenuItem<String>(
                                  value: "Confirmed",
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Text("Confirmed"),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "Cancel",
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Text("Cancel"),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "Pending",
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Text("Pending"),
                                  ),
                                ),
                              ],
                              value: roomController.selectedStatus.value,
                              onChanged: (value) {
                                roomController.selectedStatus.value = value;
                              },
                            ).h(45);
                          }),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Action Buttons Row - Full width at bottom
                  Row(
                    children: [
                      // Filter Button - Primary Action
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            dashboardController.getManagerDashboard(
                              startDate: roomController.startDate.value,
                              endDate: roomController.endDate.value,
                              status: roomController.selectedStatus.value,
                              typeId: roomController.selectedRoomType.value?.id,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                              vertical: 14.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.filter_list, size: 20.h, color: Colors.black),
                              SizedBox(width: 8.w),
                              Text(
                                'Apply Filters',
                                style: QuickTechAppTextStyle.bodyText4().copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // Export Button - Secondary Action
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            dashboardController.exportBookingsToCsv();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            padding: EdgeInsets.symmetric(
                              vertical: 14.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.download_outlined, size: 20.h),
                              SizedBox(width: 8.w),
                              Text(
                                'Export',
                                style: QuickTechAppTextStyle.bodyText4().copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Optional: Show active filters count/chips
                  SizedBox(height: 12.h),
                  _buildActiveFiltersChips(),
                ],
              ),
            ),

            20.verticalSpace,
            Obx(() => dashboardController.isLoading.value 
              ? const Center(child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: mainColor),
                ))
              : QuickTechRecentBookingTable()),
            Obx(() => dashboardController.isMoreLoading.value
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                )
              : const SizedBox.shrink()),
            40.verticalSpace,
          ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customAppbar(context),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFiltersChips() {
    return Obx(() {
      List<String> activeFilters = [];

      if (roomController.selectedRoomType.value != null) {
        activeFilters.add(roomController.selectedRoomType.value?.name ?? '');
      }
      if (roomController.selectedStatus.value != null) {
        activeFilters.add(roomController.selectedStatus.value ?? '');
      }
      if (roomController.startDate.value != null) {
        activeFilters.add("From: ${roomController.startDate.value}");
      }
      if (roomController.endDate.value != null) {
        activeFilters.add("To: ${roomController.endDate.value}");
      }

      if (activeFilters.isEmpty) {
        return const SizedBox.shrink();
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(
              'Active filters: ',
              style: QuickTechAppTextStyle.bodyText4().copyWith(
                color: Colors.grey[600],
                fontSize: 12.sp,
              ),
            ),
            ...activeFilters.map((filter) {
              return Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  filter,
                  style: QuickTechAppTextStyle.bodyText4().copyWith(
                    fontSize: 12.sp,
                    color: Colors.black87,
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildDateField({
    required String label,
    required String hint,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: QuickTechAppTextStyle.bodyText4().copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.grey[50],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hint,
                  style: QuickTechAppTextStyle.bodyText4().copyWith(
                    color: Colors.grey[600],
                    fontSize: 13.sp,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 18.h,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: QuickTechAppTextStyle.bodyText4().copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.grey[50],
          ),
          child: child,
        ),
      ],
    );
  }
}
