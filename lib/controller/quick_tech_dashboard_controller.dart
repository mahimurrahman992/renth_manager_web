import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../consts/consts.dart';
import '../model/DashboardModel.dart';
import '../model/drawer_page_model.dart';

class DashboardController extends GetxController {
  final RxBool isBalanceVisible = true.obs;
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var isSwitchOn = false.obs;
  var dashboard = DashboardModel().obs;
  var allBookings = <Datum>[].obs;
  var isMoreLoading = false.obs;
  int currentPage = 1;
  bool hasMore = true;
  var box = GetStorage();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  var shouldAnimate = false.obs;
  String? lastStartDate;
  String? lastEndDate;
  String? lastStatus;
  int? lastTypeId;

  // Web / Responsive state
  var isSidebarCollapsed = false.obs;

  void toggleSidebar() {
    isSidebarCollapsed.value = !isSidebarCollapsed.value;
  }

  String get currentTabTitle {
    switch (currentIndex.value) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Room Management';
      case 2:
        return 'Property Listing';
      case 3:
        return 'Recent Bookings';
      case 4:
        return 'Profile';
      default:
        return 'Dashboard';
    }
  }

  void switchTab(int index) {
    currentIndex.value = index;
    if (Get.currentRoute != AppRoutes.dashboard) {
      Get.offAllNamed(AppRoutes.dashboard);
      currentIndex.value = index;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (Get.context != null) {
        checkVisibility(Get.context!);
      }
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreBookings();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  GlobalKey imageKey = GlobalKey();

  void checkVisibility(BuildContext context) {
    if (shouldAnimate.value) return;

    final renderObject = imageKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      final isVisible = position.dy > 0 && position.dy < screenHeight - 100;

      if (isVisible) {
        shouldAnimate.value = true;
      }
    }
  }

  Future<bool> onWillPop(context) async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you really want to exit?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        )) ??
        false;
  }

  void onItemTapped(int index) {
    currentIndex.value = index;
    update();
  }

  var item = [
    const BottomNavigationBarItem(
      icon: Icon(Ionicons.home_outline),
      label: 'Home',
      backgroundColor: mainColor,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.add_home_work_outlined),
      label: 'Post Property',
      backgroundColor: mainColor,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Ionicons.newspaper_outline),
      label: 'Property List',
      backgroundColor: mainColor,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Ionicons.person_outline),
      label: 'Profile',
      backgroundColor: mainColor,
    ),
  ];

  Future<void> getManagerDashboard({
    int page = 1,
    String? startDate,
    String? endDate,
    String? status,
    int? typeId,
  }) async {
    if (page == 1) {
      isLoading.value = true;
      currentPage = 1;
      hasMore = true;
      lastStartDate = startDate;
      lastEndDate = endDate;
      lastStatus = status;
      lastTypeId = typeId;
    } else {
      isMoreLoading.value = true;
      startDate = lastStartDate;
      endDate = lastEndDate;
      status = lastStatus;
      typeId = lastTypeId;
    }

    final url = Uri.parse(
      "${Api.dashboard}?check_in_start=${startDate ?? ""}&check_out_end=${endDate ?? ""}&status=${status ?? ""}&room_type_id=${typeId ?? ""}&page=$page",
    );
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${box.read(StorageKeys.accessToken)}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var newDashboard = DashboardModel.fromJson(data);

        if (page == 1) {
          dashboard.value = newDashboard;
          allBookings.assignAll(newDashboard.bookings?.data ?? []);
        } else {
          allBookings.addAll(newDashboard.bookings?.data ?? []);
        }

        if ((newDashboard.bookings?.data.isEmpty ?? true) ||
            newDashboard.bookings?.nextPageUrl == null) {
          hasMore = false;
        }
      } else {
        log('Failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
      dashboard.refresh();
      allBookings.refresh();
    }
  }

  var pageDetails = DrawerPageModel().obs;

  Pages? getPageByName(String pageName) {
    try {
      return pageDetails.value.pages?.firstWhere(
        (page) =>
            (page.pageName ?? '')
                .trim()
                .toLowerCase()
                .contains(pageName.trim().toLowerCase()),
      );
    } catch (e) {
      log(pageName.trim());
      log("notMatch");
      return null;
    }
  }

  Future<void> getAllPages() async {
    try {
      final uri = Uri.parse(Api.drawerPage);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        pageDetails.value = DrawerPageModel.fromJson(data);
      } else {
        throw Exception('Failed to load pages: ${response.statusCode}');
      }
      pageDetails.refresh();
    } catch (e) {
      throw Exception('Error fetching pages: $e');
    }
  }

  Future<void> loadMoreBookings() async {
    if (!isLoading.value && !isMoreLoading.value && hasMore) {
      currentPage++;
      await getManagerDashboard(page: currentPage);
    }
  }

  Future<void> exportBookingsToCsv() async {
    if (allBookings.isEmpty) {
      Get.snackbar(
        'No Data',
        'There is no data to export',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    List<String> headers = [
      'Invoice No',
      'Customer',
      'Room Type',
      'Check In',
      'Check Out',
      'Total',
      'Status'
    ];

    List<List<dynamic>> rows = allBookings.map((booking) {
      return [
        booking.invoiceNo ?? '',
        booking.customer?.name ?? '',
        booking.roomType?.name ?? '',
        booking.checkInStart?.toString().split(' ').first ?? '',
        booking.checkOutEnd?.toString().split(' ').first ?? '',
        '${booking.grandTotal ?? ''} TK',
        booking.status ?? '',
      ];
    }).toList();

    await generateAndShareCsv(
      fileName: 'recent_bookings_${DateTime.now().millisecondsSinceEpoch}',
      headers: headers,
      rows: rows,
    );
  }

  Future<void> generateAndShareCsv({
    required String fileName,
    required List<String> headers,
    required List<List<dynamic>> rows,
  }) async {
    List<List<dynamic>> csvData = [headers, ...rows];

    String csv = const ListToCsvConverter().convert(csvData);

    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/$fileName.csv";
    final file = File(path);

    await file.writeAsString(csv);

    await Share.shareXFiles([XFile(path)], text: 'Exporting $fileName CSV');
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return successColor;
      case 'pending':
        return warningColor;
      case 'cancelled':
        return errorColor;
      default:
        return infoColor;
    }
  }

  Color getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return badgeGreenBg;
      case 'pending':
        return badgeOrangeBg;
      case 'cancelled':
        return badgeRedBg;
      default:
        return badgeBlueBg;
    }
  }
}
