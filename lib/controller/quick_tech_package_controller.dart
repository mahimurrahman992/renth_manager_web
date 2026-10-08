import 'dart:convert';
import 'dart:developer';

import 'package:renth_manager/consts/consts.dart';
import 'package:http/http.dart' as http;
import 'package:renth_manager/model/package_model.dart';

import '../widgets/custom_inapp_web_view.dart';

class PackageController extends GetxController {
  var box = GetStorage();
  var isLoading = false.obs;
  var package = PackageModel().obs;

  Future<void> getBuyPackageInfo() async {
    final url = Uri.parse(Api.getPackage);

    final headers = {
      'Authorization': 'Bearer ${box.read(StorageKeys.accessToken)}',
    };

    try {
      final response = await http.get(url, headers: headers);
      debugPrint('debugPrint: ${response.statusCode}');
      debugPrint('debugPrint: ${response.body}');
      debugPrint('debugPrint: ${response.reasonPhrase}');
      if (response.statusCode == 200) {
        debugPrint('Response: ${response.body}');
        // You can parse JSON here:
        final data = jsonDecode(response.body);
        package.value = PackageModel.fromJson(data);
      } else {
        debugPrint('Failed: ${response.statusCode}');
        debugPrint('Reason: ${response.reasonPhrase}');
      }
      package.refresh();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> subscribeToPackage({id}) async {
    final url = Uri.parse(Api.buyPackage);

    final headers = {
      'Authorization': 'Bearer ${box.read(StorageKeys.accessToken)}',
    };

    final body = {'package_id': id.toString()};
    debugPrint("Subscribe Body: $body");

    try {
      isLoading.value = true;
      final response = await http.post(url, headers: headers, body: body);
      isLoading.value = false;
      var data = jsonDecode(response.body);
      debugPrint('debugPrint: ${response.statusCode}');
      debugPrint('debugPrint: ${response.body}');
      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');

        final data = jsonDecode(response.body);
        if (data['paymentUrl'] != null) {
          Get.to(
            () =>
                DynamicWebViewScreen(initialUrl: data['paymentUrl'].toString()),
          );
        }
        showSuccessToast("Package Buy Success");
        getBuyPackageInfo();
      } else {
        showErrorToast("Something Went Wrong\n${data['message']}");

        log('Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
