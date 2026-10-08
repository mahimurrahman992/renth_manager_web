// lib/controllers/notification_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../consts/consts.dart';

class NotificationController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  var notifications = <NotificationModel>[].obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  String? get authToken {
    return box.read(StorageKeys.accessToken); 
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      hasError(false);
      errorMessage('');

      final token = authToken;
      if (token == null || token.isEmpty) {
        hasError(true);
        errorMessage('Authentication required. Please login.');
        return;
      }

      final response = await http.get(
        Uri.parse(Api.notification),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      
      debugPrint("Fetch Notification:${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['notifications'] != null) {
          notifications.assignAll(
            (data['notifications'] as List).map((json) => NotificationModel.fromJson(json)).toList()
          );
        } else {
          notifications.clear();
        }
      } else if (response.statusCode == 401) {
        hasError(true);
        errorMessage('Session expired. Please login again.');
 
        box.remove('token');
        
      } else {
        hasError(true);
        errorMessage('Failed to load notifications: ${response.statusCode}');
        try {
          final errorData = json.decode(response.body);
          errorMessage(errorData['message'] ?? errorMessage.value);
        } catch (_) {}
            }
    } catch (e) {
      hasError(true);
      errorMessage('Connection error: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }



  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }
}

class NotificationModel {
  final String id;
  final String type;
  final String notifiableType;
  final String notifiableId;
  final Map<String, dynamic> data;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.notifiableType,
    required this.notifiableId,
    required this.data,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      notifiableType: json['notifiable_type'],
      notifiableId: json['notifiable_id'].toString(),
      data: json['data'] is Map ? json['data'] : {'message': json['data'].toString()},
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  NotificationModel copyWith({
    DateTime? readAt,
  }) {
    return NotificationModel(
      id: id,
      type: type,
      notifiableType: notifiableType,
      notifiableId: notifiableId,
      data: data,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  bool get isRead => readAt != null;

  String get message => data['message']?.toString() ?? 'New notification';
}