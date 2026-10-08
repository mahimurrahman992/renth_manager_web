import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:renth_manager/consts/consts.dart' hide PropertyRoom;
import 'package:renth_manager/model/response/quick_tech_room_details_response.dart'
    hide PropertyRoom;
import 'package:renth_manager/model/response/quick_tech_room_model.dart';

class QuickTechRoomController extends GetxController {
  var isLoading = false.obs;
  var isLoadingRoomsByType = <int, bool>{}.obs;
  var roomList = QuicktechRoomList().obs;
  var roomsByType = <int, List<PropertyRoom>>{}.obs;
  var errorMessage = ''.obs;
  var expandedRoomTypes = <int, bool>{}.obs;

  var localAvailableRooms = <int, int>{}.obs;
  var roomDetails = QuicktechRoomDetails().obs;
  Future<void> fetchRoomRecords({int? propertyId}) async {
    try {
      isLoading(true);
      errorMessage('');
      final url = Api.roomList('${propertyId ?? ''}');
      debugPrint(url);
      final dynamic token = GetStorage().read(StorageKeys.accessToken);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer $token",
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        roomList.value = QuicktechRoomList.fromJson(data);
        localAvailableRooms.clear();
        debugPrint("Fetched Room Records Successfully.");
      } else {
        errorMessage.value = "Error: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Exception: $e";
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchRoomsByType(int roomTypeId, int propertyId) async {
    try {
      isLoadingRoomsByType[roomTypeId] = true;
      final url = Api.roombyType(roomTypeId, propertyId);

      final dynamic token = GetStorage().read(StorageKeys.accessToken);
      debugPrint("Rooms by Type URL: $url");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer $token",
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final propertyRoomResponse = QuicktechRoomModel.fromJson(data);

        if (propertyRoomResponse.propertyRooms != null) {
          roomsByType[roomTypeId] = propertyRoomResponse.propertyRooms!;
        } else {
          roomsByType[roomTypeId] = [];
        }
        debugPrint("Fetched rooms for room type $roomTypeId successfully.");
      } else {
        errorMessage.value = "Error fetching rooms: ${response.statusCode}";
        roomsByType[roomTypeId] = [];
      }
    } catch (e) {
      debugPrint("Exception fetching rooms: $e");
      errorMessage.value = "Exception: $e";
      roomsByType[roomTypeId] = [];
    } finally {
      isLoadingRoomsByType[roomTypeId] = false;
    }
  }

  void toggleRoomTypeExpansion(int roomTypeId, int propertyId) {
    final isExpanded = expandedRoomTypes[roomTypeId] ?? false;

    if (!isExpanded) {
      if (!roomsByType.containsKey(roomTypeId)) {
        fetchRoomsByType(roomTypeId, propertyId);
      }
      expandedRoomTypes[roomTypeId] = true;
    } else {
      expandedRoomTypes[roomTypeId] = false;
    }
  }

  List<String> getUniqueRoomTypes() {
    final records = roomList.value.propertyRoomRecords ?? [];
    final roomTypes = <String>{};

    for (var record in records) {
      if (record.roomType?.name != null) {
        roomTypes.add(record.roomType!.name!);
      }
    }

    return roomTypes.toList();
  }

  int? getRoomTypeIdByName(String roomTypeName) {
    final records = roomList.value.propertyRoomRecords ?? [];
    for (var record in records) {
      if (record.roomType?.name == roomTypeName) {
        return record.roomType?.id;
      }
    }
    return null;
  }

  void incrementLocalRoom(int recordId, int currentCount, int maxLimit) {
    if (currentCount < maxLimit) {
      localAvailableRooms[recordId] = currentCount + 1;
    }
  }

  void decrementLocalRoom(int recordId, int currentCount) {
    if (currentCount > 0) {
      localAvailableRooms[recordId] = currentCount - 1;
    }
  }

  var updatingRecordIds = <int, bool>{}.obs;

  Future<void> updateRoomInventory(
    int recordId,
    int finalAvailableCount,
    int propertyId,
  ) async {
    try {
      updatingRecordIds[recordId] = true;
      errorMessage('');

      final dynamic token = GetStorage().read(StorageKeys.accessToken);

      var headers = {
        'Authorization': "Bearer $token",
        'Accept': 'application/json',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Api.updateRoomAvailability),
      );

      request.fields.addAll({
        'property_room_record_id': recordId.toString(),
        'available_room': finalAvailableCount.toString(),
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String resStr = await response.stream.bytesToString();
        final resJson = jsonDecode(resStr);
        debugPrint("Update Response: $resStr");
        showSuccessToast(
          "${resJson['message'] ?? 'Room inventory updated successfully'}",
        );

        await fetchRoomRecords(propertyId: propertyId);
      } else {
        String resStr = await response.stream.bytesToString();
        final resJson = jsonDecode(resStr);
        showErrorToast(
          "Failed to update database. Error: ${response.statusCode} ${response.reasonPhrase} ${resJson['message'] ?? ''}",
        );
      }
    } catch (e) {
      debugPrint("Update Exception: $e");
    } finally {
      updatingRecordIds[recordId] = false;
    }
  }

  Future<void> fetchRoomDetails(int roomId) async {
    try {
      isLoading(true);
      errorMessage('');
      final url = Api.roomDetails(roomId);
      debugPrint(url);
      final dynamic token = GetStorage().read(StorageKeys.accessToken);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer $token",
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        roomDetails.value = QuicktechRoomDetails.fromJson(data);
        debugPrint("Fetched Room Details Successfully.");
      } else {
        errorMessage.value = "Error: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Exception: $e";
    } finally {
      isLoading(false);
    }
  }

  // রুম ডিলিট করার মেথড
  Future<void> deleteRoom(int roomId, int roomTypeId, int propertyId) async {
    try {
      // আপনি চাইলে একটি আলাদা ডিলিট লোডিং স্টেট মেইনটেইন করতে পারেন
      isLoading(true);
      errorMessage('');

      final dynamic token = GetStorage().read(StorageKeys.accessToken);

      var headers = {
        'Authorization': "Bearer $token",
        'Accept': 'application/json',
      };

      var request = http.MultipartRequest('POST', Uri.parse(Api.roomDelete));

      request.fields.addAll({'property_room_id': roomId.toString()});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String resStr = await response.stream.bytesToString();
        final resJson = jsonDecode(resStr);
        debugPrint("Delete Response: $resStr");

        showSuccessToast(
          "${resJson['message'] ?? 'Room deleted successfully'}",
        );

        int effectivePropertyId = propertyId;
        if (effectivePropertyId <= 0) {
          final savedId = GetStorage().read(StorageKeys.selectedPropertyId);
          effectivePropertyId = int.tryParse(savedId?.toString() ?? '') ?? 0;
        }

        // ডাটাবেজ থেকে ডিলিট হওয়ার পর লোকাল স্টেট বা লিস্ট রিলোড করা
        if (roomTypeId > 0 && effectivePropertyId > 0) {
          await fetchRoomsByType(roomTypeId, effectivePropertyId);
        }

        if (effectivePropertyId > 0) {
          await fetchRoomRecords(propertyId: effectivePropertyId);
        }
      } else {
        String resStr = await response.stream.bytesToString();
        debugPrint("Delete Failed: $resStr");
        String errorMsg =
            "Failed to delete room. Error: ${response.statusCode}";
        try {
          final resJson = jsonDecode(resStr);
          errorMsg = resJson['message'] ?? resJson['error'] ?? errorMsg;
        } catch (_) {}
        showErrorToast(errorMsg);
      }
    } catch (e) {
      debugPrint("Delete Exception: $e");
      showErrorToast("Exception: $e");
    } finally {
      isLoading(false);
    }
  }
}
