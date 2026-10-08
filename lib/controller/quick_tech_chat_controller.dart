import 'dart:convert';
import 'package:http/http.dart' as http;
import '../consts/consts.dart';
import '../model/chat_list_model.dart';
import '../model/message_list_model.dart';

class ChatController extends GetxController {
  var box = GetStorage();
  var chatList = <Users>[].obs;
  var messages = <Messages>[].obs;
  var isLoading = false.obs;
  var isMessageLoading = false.obs;



  Future<void> fetchChatList() async {
    try {
      isLoading.value = true;
      final token = box.read(StorageKeys.accessToken);

      final response = await http.get(
        Uri.parse(Api.chatList),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var chatListModel = ChatListModel.fromJson(data);
        if (chatListModel.users.isNotEmpty) {
          chatList.value = chatListModel.users.sublist(1);
        } else {
          chatList.value = [];
        }
      } else {
        debugPrint("Failed to load chat list: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching chat list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMessageList(int receiverId) async {
    try {
      isMessageLoading.value = true;
      final token = box.read(StorageKeys.accessToken);

      final response = await http.get(
        Uri.parse("${Api.messageList}$receiverId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var messageListModel = MessageListModel.fromJson(data);
        messages.value = messageListModel.messages;
      } else {
        debugPrint("Failed to load message list: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching message list: $e");
    } finally {
      isMessageLoading.value = false;
    }
  }

  Future<void> sendMessage(String msg, int receiverId) async {
    try {
      final token = box.read(StorageKeys.accessToken);

      final response = await http.post(
        Uri.parse(Api.sendMessage),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'msg': msg,
          'receiver_id': receiverId.toString(),
        },
      );

      if (response.statusCode == 200) {
        // Refresh message list after sending
        fetchMessageList(receiverId);
      } else {
        debugPrint("Failed to send message: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }
}
