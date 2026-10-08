import 'package:get/get.dart';

class PropertyDetailsController extends GetxController{
  var selectedIndex = 0.obs;
  var selectedAvailableIndex = 0.obs;
  var selectedAvailableIndexName = 'Single Sharing'.obs;
  final RxBool isVerified = RxBool(false);
  final RxBool isChecked = RxBool(false);
}