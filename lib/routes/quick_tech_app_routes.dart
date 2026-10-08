import 'package:renth_manager/consts/consts.dart';
import 'package:renth_manager/page/booking_list_page/quick_tech_booking_list_page.dart';
import 'package:renth_manager/page/package_page/quick_tech_package_page.dart';
import 'package:renth_manager/page/property_post_page/quick_tech_property_post_page.dart';
import 'package:renth_manager/page/room_details/quick_tech_room_details.dart';
import 'package:renth_manager/page/room_list/quick_tech_room_screen.dart';
import 'package:renth_manager/page/withdraw_page/quick_tech_withdraw_page.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const chooseLoginType = '/choose-login-type';
  static const login = '/login';
  static const register = '/register';
  static const forgetPassword = '/forget-password';
  static const resetPassword = '/reset-password';
  static const dashboard = '/dashboard';
  static const home = '/home';
  static const profile = '/profile';
  static const notification = '/notification';
  static const propertyList = '/property-list';
  static const addNewProperty = '/add-new-property';
  static const postProperty = '/post-property';
  static const editProperty = '/edit-property';
  static const roomManagement = '/room-management';
  static const addRoom = '/add-room';
  static const roomScreen = '/room-screen';
  static const roomDetails = '/room-details';
  static const bookingList = '/booking-list';
  static const recentBooking = '/recent-booking';
  static const package = '/package';
  static const withdraw = '/withdraw';
  static const message = '/message';
  static const chatDetail = '/chat-detail';

  // Legacy alias support
  static const loginTypeScreen = '/logintypescreen';
}

abstract class AppPages {
  static const initial = AppRoutes.splash;

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const QuickTechSplashPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.chooseLoginType,
      page: () => const QuickTechChooseLoginTypeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.loginTypeScreen,
      page: () => const QuickTechChooseLoginTypeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () {
        final loginType = Get.arguments is LoginType
            ? Get.arguments as LoginType
            : LoginType.phone;
        return QuickTechLoginPage(loginType: loginType);
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () {
        final loginType = Get.arguments is LoginType
            ? Get.arguments as LoginType
            : LoginType.phone;
        return QuickTechRegisterPage(loginType: loginType);
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.forgetPassword,
      page: () => const QuickTechForgetPassword(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () {
        final mobile = (Get.arguments is String) ? Get.arguments as String : '';
        return QuickTechResetPassword(mobile: mobile);
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const QuickTechDashboard(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const QuickTechHomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const QuickTechProfilePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => NotificationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.propertyList,
      page: () => const QuickTechPropertyListPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.addNewProperty,
      page: () => const QuickTechAddNewPropertyScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.postProperty,
      page: () => const QuickTechPropertyPostPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.editProperty,
      page: () => const QuickTechEditPropertyPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.roomManagement,
      page: () => QuickTechRoomManagementScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.addRoom,
      page: () => const QuickTechAddRoomScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.roomScreen,
      page: () {
        int propertyId = 0;
        final args = Get.arguments;
        if (args is int) {
          propertyId = args;
        } else if (args is Map && args['propertyId'] != null) {
          propertyId = int.tryParse(args['propertyId'].toString()) ?? 0;
        }
        if (propertyId == 0) {
          final savedId = GetStorage().read(StorageKeys.selectedPropertyId);
          propertyId = int.tryParse(savedId?.toString() ?? '') ?? 0;
        }
        return QuickTechRoomScreen(propertyId: propertyId);
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.roomDetails,
      page: () {
        int roomId = 0;
        final args = Get.arguments;
        if (args is int) {
          roomId = args;
        } else if (args is Map && args['roomId'] != null) {
          roomId = int.tryParse(args['roomId'].toString()) ?? 0;
        }
        return RoomDetailsPage(roomId: roomId);
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.bookingList,
      page: () => const QuickTechBookingListPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.recentBooking,
      page: () => const QuickTechRecentBookingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.package,
      page: () => const QuickTechPackagePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.withdraw,
      page: () => const WalletWithdrawPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.message,
      page: () => QuickTechChatListPage(),
      
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.chatDetail,
      page: () {
        final args = Get.arguments is Map ? Get.arguments as Map : {};
        return QuickTechChatDetailPage(
          userName: args['userName']?.toString() ?? '',
          receiverId: args['receiverId'] is int ? args['receiverId'] as int : 0,
          profilePhoto: args['profilePhoto']?.toString() ?? '',
        );
      },
      transition: Transition.fadeIn,
    ),
  ];
}
