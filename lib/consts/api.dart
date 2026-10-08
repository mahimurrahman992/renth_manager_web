

class Api {
  static String baseUrl = 'https://renth.app';
  static String imageUrl = 'https://renth.app/';
  static String register = '$baseUrl/api/manager/register';
  static String phoneLogin = '$baseUrl/api/manager/login';
  static String forgotPassword = '$baseUrl/api/forget/password';
  static String resetPassword = '$baseUrl/api/reset/password';
  static String emailLogin = '$baseUrl/api/manager/email-login';
  static String category = '$baseUrl/api/property/categories/all';
  static String bookingStatusUpdate = '$baseUrl/api/booking-status/update';
  static String dashboard = '$baseUrl/api/manager/dashboard';
  static String withdrawList = '$baseUrl/api/manager/withdraw-request/all?page=';
  static String withdrawReq = '$baseUrl/api/manager/withdraw-request/save';
  static String getProfile = '$baseUrl/api/manager/profile';
  static String profileUpdate = '$baseUrl/api/manager/profile/update';
  static String division = '$baseUrl/api/divisions/all';
  static String postProperty = '$baseUrl/api/manager/property/store';
  static String district = '$baseUrl/api/districts/of/division/';
  static String thana = '$baseUrl/api/upazilas/of/district/';
  static String propertyList = '$baseUrl/api/manager/property/all';
  static String propertyDetails = '$baseUrl/api/property/details/';
  static String properyupdate = '$baseUrl/api/property/update';
  static String propertyDelete = '$baseUrl/api/property/delete/';
  static String bookingList = '$baseUrl/api/manager/booking-order/all';
  static String bookingStatusChange =
      '$baseUrl/api/manager/withdraw-status/change';
  static String getPackage = '$baseUrl/api/manager/buy/package';
  static String buyPackage = '$baseUrl/api/manager/subscribe';
  static String googleLogin = '$baseUrl/api/manager/google-login';
  static String notification = '$baseUrl/api/manager/notifications';
  static String getCountryCategories = '$baseUrl/api/manager/property/create';
  static String drawerPage = "$baseUrl/api/all/pages";
  static String getdistrictsbyCountry(int id) =>
      '$baseUrl/api/districts/of/country/$id';
  static String propertyCreate = '$baseUrl/api/manager/property/store';
  static String getRoomData = '$baseUrl/api/manager/room/create';
  static String roomCreate = '$baseUrl/api/manager/room/store';
  static String roomList(String id) => '$baseUrl/api/property-room-records/of/property/$id';
  static String updateRoomAvailability = '$baseUrl/api/property-room-record/update';
  static String roomDetails(int id) => '$baseUrl/api/room/details/$id';
  static String roomUpdate = '$baseUrl/api/room/update';
  static String roomDelete = '$baseUrl/api/room/delete';
  static String sendMessage = "$baseUrl/api/send-message";
  static String chatList = "$baseUrl/api/user-all";
  static String messageList = "$baseUrl/api/user-message/";
  static String roombyType(int roomTypeId, int propertyId) =>
      '$baseUrl/api/rooms/of/room-type/$roomTypeId/property/$propertyId';

}
