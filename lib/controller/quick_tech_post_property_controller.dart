import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../consts/consts.dart';


class PostPropertyController extends GetxController {
  var box = GetStorage();
  var title = TextEditingController();
  var about = TextEditingController();
  var address = TextEditingController();
  var totalPrice = TextEditingController();
  var googleMap = TextEditingController();
  var ownerName = TextEditingController();
  var ownerAbout = TextEditingController();
  var common = TextEditingController();
  var room = TextEditingController();
  var service = TextEditingController();
  var rules = TextEditingController();

  ///
  var singleSharingPrice = TextEditingController();
  var singleNumber = TextEditingController();

  ///  ///
  var doubleSharingPrice = TextEditingController();
  var doubleNumber = TextEditingController();

  ///  ///
  var tripleSharingPrice = TextEditingController();
  var tripleNumber = TextEditingController();

  ///
  var isSingle = false.obs;
  var isDouble = false.obs;
  var isTriple = false.obs;
  var isCommon = false.obs;
  var isRoom = false.obs;
  var isService = false.obs;
  List<Map<String, String>> collectedData = [];
  final ImagePicker _picker = ImagePicker();
  final RxList<File> selectedImages = <File>[].obs;
  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> type = ['Working professional', 'Students', 'Family'];
  var selectedDivision = Rxn<Divisions>();
  var selectedDistrict = Rxn<Districts>();
  var selectedThana = Rxn<Upazilas>();
  var selectedGender = ''.obs;
  var selectedType = ''.obs;
  var packageList = <Map<String, TextEditingController>>[].obs;
  var rulesList = <Map<String, TextEditingController>>[].obs;

  void pickMultipleImages([ImageSource? source]) async {
    if (source == null) {
      showQuickTechImageSourcePicker(
        title: "Select Property Images Source",
        onSourceSelected: (selectedSource) => pickMultipleImages(selectedSource),
      );
      return;
    }

    try {
      if (source == ImageSource.camera) {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
        );
        if (image != null) {
          selectedImages.add(File(image.path));
        }
      } else {
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: 50,
        );
        if (images.isNotEmpty) {
          selectedImages.addAll(images.map((img) => File(img.path)).toList());
        }
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  void setSelectedDivision(Divisions division) {
    selectedDivision.value = division;
  }

  void setSelectedThanan(Upazilas thana) {
    selectedThana.value = thana;
  }

  void setSelectedDistrict(Districts district) {
    selectedDistrict.value = district;
  }

  void setGender(String value) {
    selectedGender.value = value;
  }

  void setType(String value) {
    selectedType.value = value;
  }

  void addPackageItem() {
    packageList.add({
      "name": TextEditingController(),
      "price": TextEditingController(),
    });
  }

  void addRulesItem() {
    rulesList.add({
      "name": TextEditingController(),
      "desc": TextEditingController(),
    });
  }

  Future<void> uploadProperty() async {
    if (title.text.isEmpty) {
      Get.snackbar("Validation Error", "Title is required");
      return;
    }
    if (about.text.isEmpty) {
      Get.snackbar("Validation Error", "About property is required");
      return;
    }
    if (totalPrice.text.isEmpty || double.tryParse(totalPrice.text) == null) {
      Get.snackbar(
        "Validation Error",
        "Total price is required and must be a valid number",
      );
      return;
    }
    if (selectedDivision.value?.id == null ||
        selectedDistrict.value?.id == null ||
        selectedThana.value?.id == null) {
      Get.snackbar(
        "Validation Error",
        "Please select division, district and upazila",
      );
      return;
    }
    if (selectedImages.isEmpty) {
      Get.snackbar("Validation Error", "Please select at least one image");
      return;
    }
    if (selectedGender.value == '' || selectedType.value == '') {
      Get.snackbar(
        "Validation Error",
        "Gender and Resident type must be selected",
      );
      return;
    }

    for (var item in packageList) {
      if (item['name']?.text.isEmpty ?? true) {
        Get.snackbar("Validation Error", "Each package must have a name");
        return;
      }
      if (item['price']?.text.isEmpty ?? true) {
        Get.snackbar("Validation Error", "Each package must have a price");
        return;
      }
      if (double.tryParse(item['price']!.text) == null) {
        Get.snackbar(
          "Validation Error",
          "Package price must be a valid number",
        );
        return;
      }
    }

    for (var item in rulesList) {
      if (item['desc']?.text.isEmpty ?? true) {
        Get.snackbar("Validation Error", "Each rule must have a description");
        return;
      }
    }

    if (isSingle.value) {
      if (singleSharingPrice.text.isEmpty || singleNumber.text.isEmpty) {
        Get.snackbar(
          "Validation Error",
          "Single sharing requires price and tenant count",
        );
        return;
      }
    }
    if (isDouble.value) {
      if (doubleSharingPrice.text.isEmpty || doubleNumber.text.isEmpty) {
        Get.snackbar(
          "Validation Error",
          "Double sharing requires price and tenant count",
        );
        return;
      }
    }
    if (isTriple.value) {
      if (tripleSharingPrice.text.isEmpty || tripleNumber.text.isEmpty) {
        Get.snackbar(
          "Validation Error",
          "Triple sharing requires price and tenant count",
        );
        return;
      }
    }

    if (ownerName.text.isEmpty || ownerAbout.text.isEmpty) {
      Get.snackbar("Validation Error", "Owner name and about must be filled");
      return;
    }

    // Step 2: Prepare and send the request (unchanged)
    var url = Uri.parse(Api.postProperty);
    var headers = {'Authorization': 'Bearer ${box.read(StorageKeys.accessToken)}'};

    List<String> amenitiesList =
        common.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    List<String> amenitiesRoomList =
        room.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    List<String> amenitiesServiceList =
        room.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    List<String> rulesLists =
        rules.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
    var packageName =
        packageList.map((item) => item['name']?.text ?? '').toList();
    var packagePrices =
        packageList.map((item) => item['price']?.text ?? '').toList();
    var rulesName = rulesList.map((item) => item['name']?.text ?? '').toList();
    var rulesPrices =
        rulesList.map((item) => item['desc']?.text ?? '').toList();

    var request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'title': title.text,
      'about_property': about.text,
      'single': isSingle.value ? "single" : '',
      'single_price': singleSharingPrice.text,
      'single_tenant': singleNumber.text,
      'double': isDouble.value ? "double" : '',
      'double_price': doubleSharingPrice.text,
      'double_tenant': doubleNumber.text,
      'triple': isTriple.value ? 'triple' : '',
      'triple_price': tripleSharingPrice.text,
      'triple_tenant': tripleNumber.text,
      'common_check': isCommon.value ? 'common' : '',
      'commons[]': jsonEncode(amenitiesList),
      'room_check': isRoom.value ? 'room' : '',
      'rooms[]': jsonEncode(amenitiesRoomList),
      'service_check': isService.value ? 'service' : '',
      'services[]': jsonEncode(amenitiesServiceList),
      'package_names[]': jsonEncode(packageName),
      'package_prices[]': jsonEncode(packagePrices),
      'term_names[]': jsonEncode(rulesName),
      'term_descriptions[]': jsonEncode(rulesPrices),
      'rules[]': jsonEncode(rulesLists),
      'total_price': totalPrice.text,
      'division_id': "${selectedDivision.value?.id}",
      'district_id': "${selectedDistrict.value?.id}",
      'upazilla_id': "${selectedThana.value?.id}",
      'gender': selectedGender.value,
      'resident_type': selectedType.value,
      'address': address.text,
      'map_embed_code': googleMap.text,
      'owner_name': ownerName.text,
      'about_owner': ownerAbout.text,
    });

    if (selectedImages.isNotEmpty) {
      for (int i = 0; i < selectedImages.length; i++) {
        var imageFile = selectedImages[i];
        var byteData = await imageFile.readAsBytes();
        var multipartFile = http.MultipartFile.fromBytes(
          'multi_img[]',
          byteData,
          filename: 'multiple$i.jpg',
        );
        request.files.add(multipartFile);
      }
    }

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        clearFields();
        String responseBody = await response.stream.bytesToString();
        debugPrint("Success: $responseBody");
        Get.snackbar("Success", "Property uploaded successfully");
        showPropertyPostedDialog(Get.context!);
        // Get.to(() => QuickTechPropertyListPage());
      } else {
        // Read the response stream exactly once
        String errorResponse = await response.stream.bytesToString();
        debugPrint("Failed with status ${response.statusCode}: $errorResponse");

        String displayMessage = "Upload failed"; // Default fallback message

        try {
          // Decode the JSON response to extract the specific message
          var decodedError = jsonDecode(errorResponse);
          if (decodedError['message'] != null) {
            displayMessage = decodedError['message'];
          }
        } catch (e) {
          debugPrint("Error parsing JSON response: $e");
        }

        // Show the extracted message in the snackbar
        Get.snackbar("Error", displayMessage);
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      Get.snackbar("Error", "An unexpected error occurred");
    }
  }

  void clearFields() {
    // Clear text controllers
    title.clear();
    about.clear();
    singleSharingPrice.clear();
    singleNumber.clear();
    doubleSharingPrice.clear();
    doubleNumber.clear();
    tripleSharingPrice.clear();
    tripleNumber.clear();
    totalPrice.clear();
    address.clear();
    googleMap.clear();
    ownerName.clear();
    ownerAbout.clear();
    common.clear();
    room.clear();
    rules.clear();

    // Reset reactive values
    isSingle.value = false;
    isDouble.value = false;
    isTriple.value = false;
    isCommon.value = false;
    isRoom.value = false;
    isService.value = false;

    selectedDivision.value = null;
    selectedDistrict.value = null;
    selectedThana.value = null;
    selectedGender.value = '';
    selectedType.value = '';

    // Clear dynamic lists
    selectedImages.clear();
    packageList.clear();
    rulesList.clear();
  }

  void disposeControllers() {
    for (var item in packageList) {
      item["name"]?.dispose();
      item["price"]?.dispose();
    }
    for (var item in rulesList) {
      item["name"]?.dispose();
      item["desc"]?.dispose();
    }
  }

  @override
  void onClose() {
    disposeControllers();
    super.onClose();
  }
     void showPropertyPostedDialog(BuildContext context) {
          showDialog(
            context: context,
            barrierDismissible: false, // User must tap a button
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                backgroundColor: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 60,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Property Posted!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Your property has been successfully posted.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () {
                          Get.offAllNamed(AppRoutes.dashboard);
                          //Get.offAll(() => QuickTechDashboard());
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor:  mainColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "OK",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

}
