import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:renth_manager/model/withdraw_req_model.dart';

import '../consts/consts.dart';

class WithdrawController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var withdrawReqModel = WithdrawReqModel(managerWallets: null).obs;
  var withdrawList = <Datum>[].obs;
  int currentPage = 1;
  bool hasMore = true;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreWithdraw();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadMoreWithdraw() async {
    if (!hasMore || isMoreLoading.value || isLoading.value) return;
    currentPage++;
    await getWithdraw(page: currentPage);
  }

  Future<void> getWithdraw({int page = 1}) async {
    if (page == 1) {
      isLoading.value = true;
      currentPage = 1;
      hasMore = true;
      withdrawList.clear();
    } else {
      isMoreLoading.value = true;
    }

    final url = Uri.parse("${Api.withdrawList}?page=$page");
    final token = box.read(StorageKeys.accessToken);

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        withdrawReqModel.value = WithdrawReqModel.fromJson(data);
        final managerWallets = withdrawReqModel.value.managerWallets;
        final newData = managerWallets?.data ?? [];

        withdrawList.addAll(newData);

        if (managerWallets != null) {
          final lastPage = managerWallets.lastPage ?? 1;
          final currPage = managerWallets.currentPage ?? 1;
          if (currPage >= lastPage || managerWallets.nextPageUrl == null) {
            hasMore = false;
          }
        } else {
          hasMore = false;
        }
      } else {
        showErrorToast("Failed to load withdrawal requests");
      }
    } catch (e) {
      showErrorToast("Error: $e");
      log("getWithdraw error: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> saveWithdrawRequest({
    required String bankName,
    required String accountHolderName,
    required String accountNumber,
    required String phoneNumber,
    required String branchOrRoutingNumber,
    required String paymentType,
    required String totalAmount,
  }) async {
    final token = box.read(StorageKeys.accessToken);
    final url = Uri.parse(Api.withdrawReq);

    final request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'bank_name': bankName,
      'account_holder_name': accountHolderName,
      'account_number': accountNumber,
      'phone_number': phoneNumber,
      'branch_or_routing_number': branchOrRoutingNumber,
      'payment_type': paymentType,
      'total_amount': totalAmount,
    });

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    try {
      isLoading.value = true;
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      isLoading.value = false;

      final data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        showSuccessToast(data['message'] ?? 'Withdrawal request submitted successfully!');
       await getWithdraw();
      } else {
        showErrorToast(data['message'] ?? 'Failed to submit withdrawal request');
      }
    } catch (e) {
      isLoading.value = false;
      showErrorToast("Error: $e");
      log("saveWithdrawRequest error: $e");
    }
  }
}
