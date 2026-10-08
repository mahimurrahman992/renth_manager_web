import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:renth_manager/consts/consts.dart';
import 'package:renth_manager/model/booking_model.dart';

class BookingOrderController extends GetxController {
  var box = GetStorage();
  var bookingList = BookingListModel().obs;

  Future<void> fetchBookingOrders() async {
    final url = Uri.parse(Api.bookingList);

    final headers = {
      'Authorization': 'Bearer ${box.read(StorageKeys.accessToken)}',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        debugPrint('Response: ${response.body}');
        // Optionally parse JSON:
        final data = jsonDecode(response.body);
        bookingList.value = BookingListModel.fromJson(data);
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Reason: ${response.reasonPhrase}');
      }
      bookingList.refresh();
    } catch (e) {
      debugPrint('Error occurred: $e');
    }
  }

  Future<void> updateBookingStatus({
    required int bookingId,
    required String status,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Api.bookingStatusUpdate),
        headers: {
          'Authorization': 'Bearer ${box.read(StorageKeys.accessToken)}',
          'Accept': 'application/json',
        },
        body: {'booking_id': bookingId.toString(), 'status': status},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  Future<void> changeWithdrawStatus({id, status}) async {
    final url = Uri.parse(Api.bookingStatusChange);

    final headers = {
      'Authorization': 'Bearer ${box.read(StorageKeys.accessToken)}',
    };

    final body = {
      'booking_order_id': id.toString(),
      'withdraw_request_status': status.toString(),
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // debugPrint('Success: ${response.body}');
        Get.snackbar("success", "success fully Change request");
        fetchBookingOrders();
      } else {
        Get.snackbar("Error", "Something Went Wrong");
        log('Failed: ${response.statusCode}');
        log('Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }


}
