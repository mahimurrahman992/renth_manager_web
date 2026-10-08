import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:renth_manager/model/property_list_model.dart';

import '../consts/consts.dart';

class EditPropertyController extends GetxController {
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
var selectedProperty = Rxn<Properties>();

static const String selectedPropertyId = "selected_property_id";
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
  var propertyDetails = PropertyDetailsModel().obs;
  var propertyList = PropertyListModel().obs;

  Future<void> getPropertyDelete({id}) async {
    var url = Uri.parse(Api.propertyDelete + id.toString());

    var headers = {'Authorization': 'Bearer ${box.read(StorageKeys.accessToken)}'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // debugPrint(response.body);
        Get.snackbar('Success', "Delete Success");
        fetchAllProperties();
      } else {
        Get.snackbar('Error', "Something Went Wrong");
        debugPrint('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
    }
  }

  Future<void> getPropertyDetails({id}) async {
    var url = Uri.parse('${Api.propertyDetails}$id');

    var headers = {'Authorization': 'Bearer ${box.read(StorageKeys.accessToken)}'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        debugPrint(response.body);
        final data = jsonDecode(response.body);
        propertyDetails.value = PropertyDetailsModel.fromJson(data);
      } else {
        debugPrint('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
      propertyDetails.refresh();
    } catch (e) {
      debugPrint('Exception occurred: $e');
    }
  }

  Future<void> fetchAllProperties() async {
    var headers = {'Authorization': 'Bearer ${box.read(StorageKeys.accessToken)}'};


    try {
      final response = await http.get(
        Uri.parse(Api.propertyList),
        headers: headers,
      );

      if (response.statusCode == 200) {
        log('fetch property');
        var data = jsonDecode(response.body);
        propertyList.value = PropertyListModel.fromJson(data);
        debugPrint("Fetch Property:${response.body}");
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
      propertyList.refresh();
    } catch (e) {
      debugPrint('Exception: $e');
    }
  }

  void setPropertyDataToFields() {
    final details =
        propertyDetails
            .value
            .property; // assuming the model is like: propertyDetails.value.property

    if (details == null) return; // safety check

    title.text = details.title ?? '';
    about.text =
        details.aboutProperty ??
        ''; // Adjusted to match your model property name
    address.text = details.address ?? '';
    totalPrice.text = details.totalPrice?.toString() ?? '';
    googleMap.text =
        details.mapEmbedCode ?? ''; // you had googleMap, model has mapEmbedCode
    ownerName.text = details.ownerName ?? '';
    ownerAbout.text = details.aboutOwner ?? ''; // adjusted field name

    // For 'common', 'room', 'service', 'rules' you need to check where these come from; placeholders for now:
    setGender("${details.gender}");
    setType("${details.residentType}");
    if (details.amenities != null) {
      // Create a list to hold all matching amenity names
      List<String> commonAmenities = [];
      List<String> roomAmenities = [];
      List<String> serviceAmenities = [];

      for (var item in details.amenities!) {
        if (item.amenityType == 'common' && item.amenityName != null) {
          isCommon.value = true;
          commonAmenities.add(item.amenityName!);
        }
      }
      for (var item in details.amenities!) {
        isRoom.value = true;
        if (item.amenityType == 'room' && item.amenityName != null) {
          roomAmenities.add(item.amenityName!);
        }
      }
      for (var item in details.amenities!) {
        if (item.amenityType == 'service' && item.amenityName != null) {
          isService.value = true;
          serviceAmenities.add(item.amenityName!);
        }
      }

      common.text = commonAmenities.join(', ');
      service.text = roomAmenities.join(', ');
      service.text = serviceAmenities.join(', ');
    }

    if (details.propertyRules != null) {
      List<String> ruless = [];
      for (var item in details.propertyRules!) {
        ruless.add(item.ruleName!);
      }
      rules.text = ruless.join(', ');
    }

    // Assuming these are related to rooms or packages, adapt based on your actual data:
    // If your model has rooms or rent packages list, you'll need to pick data accordingly.
    // Example placeholders:
    if (details.rooms != null) {
      for (var item in details.rooms!) {
        if (item.shareType == 'single') {
          isSingle.value = true;
          singleSharingPrice.text = "${item.price}";
          singleNumber.text = '${item.tenant}';
        }
        if (item.shareType == 'double') {
          isDouble.value = true;
          doubleSharingPrice.text = "${item.price}";
          doubleNumber.text = '${item.tenant}';
        }
        if (item.shareType == 'triple') {
          isTriple.value = true;
          tripleSharingPrice.text = "${item.price}";
          tripleNumber.text = '${item.tenant}';
        }
      }
    }

    if (details.division != null) {
      selectedDivision.value = details.division;
    }
    if (details.district != null) {
      selectedDistrict.value = details.district;
    }
    if (details.upazila != null) {
      selectedThana.value = details.upazila;
    }

    // Clear and populate packageList if you have rentPackages in model
    packageList.clear();
    if (details.rentPackages != null) {
      for (var package in details.rentPackages!) {
        packageList.add({
          "name": TextEditingController(text: package.name ?? ''),
          "price": TextEditingController(text: package.price?.toString() ?? ''),
        });
      }
    }

    // Clear and populate rulesList if you have propertyRules in model
    rulesList.clear();
    if (details.propertyRules != null) {
      for (var rule in details.rentTerms!) {
        rulesList.add({
          "name": TextEditingController(text: rule.name ?? ''),
          "desc": TextEditingController(text: rule.description ?? ''),
        });
      }
    }
  }

  void pickMultipleImages() async {
    final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 50);
    if (images != null) {
      selectedImages.addAll(images.map((xFile) => File(xFile.path)));
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
}
