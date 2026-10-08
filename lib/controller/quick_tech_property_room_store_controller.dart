import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:renth_manager/consts/consts.dart';
import 'package:renth_manager/model/request/quick_tech_create_room.dart';
import 'package:renth_manager/model/response/quickech_get_room_data.dart';

class QuickTechPropertyRoomController extends GetxController {
  var isLoading = false.obs;
  var submitSuccess = false.obs;
  final RxnString selectedStatus = RxnString();
  final RxnString startDate = RxnString();
  final RxnString endDate = RxnString();

  // --- Property Form Controllers & Observables ---
  final titleController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final overviewController = TextEditingController();
  final nearbyController = TextEditingController();
  final additionalDetailsController = TextEditingController();

  var title = ''.obs;
  var address = ''.obs;
  var price = ''.obs;
  var overview = ''.obs;
  var nearby = ''.obs;
  var additionalDetails = ''.obs;

  var selectedCountryId = 0.obs;
  var selectedDistrictId = 0.obs;
  var selectedCategoryId = 0.obs;
  var images = <String>[].obs;

  // --- Room Form Controllers & Observables ---
  final roomNameController = TextEditingController();
  final roomPriceController = TextEditingController();
  final roomDiscountPriceController = TextEditingController();
  final adultCapacityController = TextEditingController();
  final childCapacityController = TextEditingController();
  final roomSizeController = TextEditingController();
  final roomDescriptionController = TextEditingController();
  final numberOfRoomController = TextEditingController();
  final extraPriceAdultController = TextEditingController();
  final extraPriceMattressController = TextEditingController();
  final extraPriceChildController = TextEditingController();
  final vatPercentageController = TextEditingController();
  final serviceChargeController = TextEditingController();

  var selectedProperty = Rxn<Properties>();
  var selectedRoomType = Rxn<Type>();
  var selectedBedType = Rxn<Type>();
  var selectedImages = <String>[].obs;
  var selectedVideo = Rxn<String>();
  var selectedFacilities = <int>[].obs;

  final ImagePicker _picker = ImagePicker();

  // --- Helpers ---

  Map<String, String> _getHeaders() {
    final token = GetStorage().read(StorageKeys.accessToken);
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }

Future<Map<String, dynamic>?> _sendMultipartRequest({
  required String url,
  required Map<String, String> fields,
  Map<String, List<String>>? multiFiles,
  Map<String, String>? singleFiles,
}) async {
  try {
    debugPrint("➡️ REQUEST URL: $url");
    debugPrint("➡️ FIELDS: $fields");

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(_getHeaders());
    request.fields.addAll(fields);

    Future<void> addFile(String field, String path) async {
      if (kIsWeb) {
        // Web: path is a blob URL, so read bytes via XFile
        final xfile = XFile(path);
        final bytes = await xfile.readAsBytes();
        final name = xfile.name.isNotEmpty
            ? xfile.name
            : 'file_${DateTime.now().millisecondsSinceEpoch}.jpg';
        request.files.add(
          http.MultipartFile.fromBytes(field, bytes, filename: name),
        );
        debugPrint("📎 [web] $field -> $name (${bytes.length} bytes)");
      } else {
        if (await File(path).exists()) {
          request.files.add(await http.MultipartFile.fromPath(field, path));
          debugPrint("📎 [mobile] $field -> $path");
        } else {
          debugPrint("⚠️ File not found, skipped: $path");
        }
      }
    }

    if (multiFiles != null) {
      for (final entry in multiFiles.entries) {
        for (final path in entry.value) {
          await addFile(entry.key, path);
        }
      }
    }

    if (singleFiles != null) {
      for (final entry in singleFiles.entries) {
        if (entry.value.isNotEmpty) {
          await addFile(entry.key, entry.value);
        }
      }
    }

    final streamed = await request.send();
    final responseBody = await streamed.stream.bytesToString();

    debugPrint("⬅️ STATUS: ${streamed.statusCode}");
    debugPrint("⬅️ BODY: $responseBody");

    dynamic decoded;
    try {
      decoded = jsonDecode(responseBody);
    } catch (_) {
      debugPrint("❌ Response is not JSON (HTML error page?)");
      showErrorToast("Server error (${streamed.statusCode})");
      return null;
    }

    if (streamed.statusCode == 200 || streamed.statusCode == 201) {
      return decoded;
    }

    // Laravel validation errors: {"message": "...", "errors": {"field": ["msg"]}}
    String errorMsg = decoded['message']?.toString() ??
        decoded['error']?.toString() ??
        'Status Code: ${streamed.statusCode}';

    if (decoded['errors'] is Map) {
      final errors = decoded['errors'] as Map;
      final lines = <String>[];
      errors.forEach((key, value) {
        final msg = value is List ? value.join(', ') : value.toString();
        lines.add("$key: $msg");
        debugPrint("❌ VALIDATION [$key]: $msg");
      });
      if (lines.isNotEmpty) errorMsg = lines.join('\n');
    }

    debugPrint("❌ API ERROR (${streamed.statusCode}): $errorMsg");
    showErrorToast(errorMsg);
    return null;
  } catch (e, st) {
    debugPrint("❌ Request Exception: $e");
    debugPrint("❌ StackTrace: $st");
    showErrorToast("Connection error: $e");
    return null;
  }
}
  // --- Property Methods ---

  void setTitle(String v) => title.value = v;

  void setAddress(String v) => address.value = v;

  void setPrice(String v) => price.value = v;

  void setOverview(String v) => overview.value = v;

  void setNearBy(String v) => nearby.value = v;

  void setAdditionalDetails(String v) => additionalDetails.value = v;

  void setCountry(int id) => selectedCountryId.value = id;

  void setDistrict(int id) => selectedDistrictId.value = id;

  void setCategory(int id) => selectedCategoryId.value = id;

  Future<void> pickImages([ImageSource? source]) async {
    if (source == null) {
      showQuickTechImageSourcePicker(
        title: "Select Property Image Source",
        onSourceSelected: (selectedSource) => pickImages(selectedSource),
      );
      return;
    }

    try {
      if (source == ImageSource.camera) {
        final XFile? pickedFile = await _picker.pickImage(
          imageQuality: 50,
          source: ImageSource.camera,
        );
        if (pickedFile != null) {
          images.add(pickedFile.path);
        }
      } else {
        final List<XFile> pickedFiles = await _picker.pickMultiImage(
          imageQuality: 50,
        );
        if (pickedFiles.isNotEmpty) {
          images.addAll(pickedFiles.map((e) => e.path));
        }
      }
    } catch (e) {
      showErrorToast('Failed to pick images');
    }
  }
Future<bool> submitProperty() async {
  if (titleController.text.trim().isEmpty ||
      priceController.text.trim().isEmpty) {
    showErrorToast("Title and Price are required");
    return false;
  }
  if (selectedCategoryId.value == 0) {
    showErrorToast("Select property category");
    return false;
  }
  if (selectedCountryId.value == 0) {
    showErrorToast("Select country");
    return false;
  }
  if (selectedDistrictId.value == 0) {
    showErrorToast("Select city / district");
    return false;
  }
  if (addressController.text.trim().isEmpty) {
    showErrorToast("Address is required");
    return false;
  }
  if (images.isEmpty) {
    showErrorToast("Upload at least one image");
    return false;
  }

  isLoading.value = true;

  final fields = {
    'title': titleController.text.trim(),
    'starting_price_per_night': priceController.text.trim(),
    'country_id': selectedCountryId.value.toString(),
    'district_id': selectedDistrictId.value.toString(),
    'address': addressController.text.trim(),
    'property_category_id': selectedCategoryId.value.toString(),
    'overview': overviewController.text.trim(),
    'near_by': nearbyController.text.trim(),
    'additional_details': additionalDetailsController.text.trim(),
  };

  debugPrint("🏠 submitProperty fields: $fields");
  debugPrint("🏠 submitProperty images: ${images.length}");

  final result = await _sendMultipartRequest(
    url: Api.propertyCreate,
    fields: fields,
    multiFiles: {'multi_img[]': List<String>.from(images)},
  );

  isLoading.value = false;

  if (result != null) {
    showSuccessToast(result['message'] ?? "Property created successfully");
    debugPrint("✅ Property Created: $result");
    clearPropertyForm();
    return true;
  }
  return false;
}

  void clearPropertyForm() {
    titleController.clear();
    addressController.clear();
    priceController.clear();
    overviewController.clear();
    nearbyController.clear();
    additionalDetailsController.clear();
    selectedCountryId.value = 0;
    selectedDistrictId.value = 0;
    selectedCategoryId.value = 0;
    images.clear();
    title.value = '';
    address.value = '';
    price.value = '';
    overview.value = '';
    nearby.value = '';
    additionalDetails.value = '';
  }

  // --- Room Methods ---

  Future<void> pickRoomImages([ImageSource? source]) async {
    if (source == null) {
      showQuickTechImageSourcePicker(
        title: "Select Room Image Source",
        onSourceSelected: (selectedSource) => pickRoomImages(selectedSource),
      );
      return;
    }

    try {
      if (source == ImageSource.camera) {
        final XFile? pickedFile = await _picker.pickImage(
          imageQuality: 50,
          source: ImageSource.camera,
        );
        if (pickedFile != null) {
          selectedImages.add(pickedFile.path);
        }
      } else {
        final List<XFile> pickedFiles = await _picker.pickMultiImage(
          imageQuality: 50,
        );
        if (pickedFiles.isNotEmpty) {
          selectedImages.addAll(pickedFiles.map((e) => e.path));
        }
      }
    } catch (e) {
      showErrorToast('Failed to pick images');
    }
  }

  Future<void> pickRoomVideo([ImageSource? source]) async {
    if (source == null) {
      showQuickTechImageSourcePicker(
        title: "Select Room Video Source",
        onSourceSelected: (selectedSource) => pickRoomVideo(selectedSource),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: source,
      );
      if (pickedFile != null) {
        selectedVideo.value = pickedFile.path;
      }
    } catch (e) {
      showErrorToast('Failed to pick video');
    }
  }

  void toggleFacility(int facilityId) {
    if (selectedFacilities.contains(facilityId)) {
      selectedFacilities.remove(facilityId);
    } else {
      selectedFacilities.add(facilityId);
    }
  }

  bool _validateRoomForm() {
    final category = selectedProperty.value?.propertyCategory?.name ?? "Hotel";

    if (selectedProperty.value == null) return _err("Select property");

    if (roomNameController.text.isEmpty) {
      String hint = 'room name';
      if (category == 'Flat Sale/Buy') {
        hint = 'flat name';
      } else if (category == 'Family Home') {
        hint = 'home name';
      } else if (category == 'Rider') {
        hint = 'rider name';
      }
      return _err("Enter $hint");
    }

    if (selectedRoomType.value == null) {
      String hint = "room type";
      if (category == 'Flat Sale/Buy' || category == 'Family Home') {
        hint = "flat type";
      } else if (category == 'Rider') {
        hint = "rider type";
      }
      return _err("Select $hint");
    }

    // Bed type hidden for 'Flat Sale/Buy' and 'Rider'
    if (category != 'Flat Sale/Buy' && category != 'Rider') {
      if (selectedBedType.value == null) return _err("Select bed type");
    }

    if (roomPriceController.text.isEmpty) {
      String hint = 'room price';
      if (category == 'Flat Sale/Buy') {
        hint = 'sale price';
      } else if (category == 'Family Home' ||
          category == 'Bachelor' ||
          category == 'Hostel' ||
          category == 'Rider') {
        hint = 'monthly rent';
      }
      return _err("Enter $hint");
    }

    // Adult capacity hidden for 'Rider'
    if (category != 'Rider') {
      if (adultCapacityController.text.isEmpty) {
        return _err("Enter adult capacity");
      }
    }

    // Child capacity only for 'Hotel'
    if (category == 'Hotel') {
      if (childCapacityController.text.isEmpty) {
        return _err("Enter child capacity");
      }
    }

    if (roomSizeController.text.isEmpty) {
      String hint = 'room size';
      if (category == 'Flat Sale/Buy') {
        hint = 'flat size';
      } else if (category == 'Family Home') {
        hint = 'home size';
      }
      return _err("Enter $hint");
    }

    if (selectedImages.isEmpty) return _err("Upload at least one image");

    if (numberOfRoomController.text.isEmpty) {
      String hint = 'number of rooms';
      if (category == 'Flat Sale/Buy') {
        hint = 'number of flats';
      } else if (category == 'Family Home') {
        hint = 'number of homes';
      }
      return _err("Enter $hint");
    }

    final vat = double.tryParse(vatPercentageController.text) ?? 0;
    if (vat > 100) {
      return _err("VAT percentage cannot be greater than 100%");
    }

    return true;
  }

  bool _err(String msg) {
    showErrorToast(msg);
    return false;
  }

  Future<bool> submitRoom() async {
    if (!_validateRoomForm()) return false;

    isLoading.value = true;
    final request = _buildRoomRequest();

    // Prepare fields
    Map<String, String> fields = request.toFormFields();

    // Handle Indexed facilities for backend array format (Hotel only)
    final category = selectedProperty.value?.propertyCategory?.name ?? "Hotel";
    if (category == 'Hotel') {
      for (int i = 0; i < selectedFacilities.length; i++) {
        fields['facilityIds[$i]'] = selectedFacilities[i].toString();
      }
    }

    final result = await _sendMultipartRequest(
      url: Api.roomCreate,
      fields: fields,
      multiFiles: {'multi_img[]': selectedImages},
      singleFiles:
          selectedVideo.value != null ? {'video': selectedVideo.value!} : null,
    );

    isLoading.value = false;

    if (result != null) {
      submitSuccess.value = true;
      showSuccessToast(result['message'] ?? 'Room created successfully');
      clearRoomForm();
      return true;
    }
    return false;
  }

  int parsePrice(String value) {
    return int.tryParse(value.replaceAll(',', '').trim()) ?? 0;
  }

  QuickTechCreateRoomRequest _buildRoomRequest() {
    final category = selectedProperty.value?.propertyCategory?.name ?? "Hotel";

    return QuickTechCreateRoomRequest(
      propertyId: selectedProperty.value!.id!,
      roomTypeId: selectedRoomType.value!.id!,
      // Bed type ID is required but hidden for 'Flat Sale/Buy' and 'Rider'
      bedTypeId:
          (category == 'Flat Sale/Buy' || category == 'Rider')
              ? 0
              : selectedBedType.value?.id ?? 0,
      roomName: roomNameController.text,
      // Extra prices only relevant for Hotel
      extraMattressPricePerNight:
          category == 'Hotel'
              ? parsePrice(extraPriceMattressController.text).toString()
              : '0',
      discountPricePerNight:
          parsePrice(roomDiscountPriceController.text).toString(),
      roomPricePerNight: parsePrice(roomPriceController.text).toString(),
      // Capacity of Adults hidden for Rider
      capacityOfAdults:
          category == 'Rider' ? '0' : adultCapacityController.text,
      // Capacity of Children only for Hotel
      capacityOfChildren:
          category == 'Hotel' ? childCapacityController.text : '0',
      roomSize: roomSizeController.text,
      roomDescription: roomDescriptionController.text,
      numberOfRoom: numberOfRoomController.text,
      imagesPaths: List.from(selectedImages),
      videoPath: selectedVideo.value,
      facilityIds: (category == 'Hotel' && selectedFacilities.isNotEmpty)
          ? List.from(selectedFacilities)
          : null,
      // Extra prices only relevant for Hotel
      extraPricePerAdult:
          category == 'Hotel'
              ? parsePrice(extraPriceAdultController.text).toString()
              : '0',
      extraPricePerChild:
          category == 'Hotel'
              ? parsePrice(extraPriceChildController.text).toString()
              : '0',
      vatPercentage: vatPercentageController.text,
      serviceCharge: serviceChargeController.text,
    );
  }

  void clearRoomForm() {
    roomNameController.clear();
    roomPriceController.clear();
    roomDiscountPriceController.clear();
    adultCapacityController.clear();
    childCapacityController.clear();
    roomSizeController.clear();
    roomDescriptionController.clear();
    numberOfRoomController.clear();
    extraPriceAdultController.clear();
    extraPriceMattressController.clear();
    extraPriceChildController.clear();
    vatPercentageController.clear();
    serviceChargeController.clear();

    selectedProperty.value = null;
    selectedRoomType.value = null;
    selectedBedType.value = null;
    selectedImages.clear();
    selectedVideo.value = null;
    selectedFacilities.clear();
  }

  void removeImage(int index) => selectedImages.removeAt(index);

  void removeVideo() => selectedVideo.value = null;

  @override
  void onClose() {
    // Dispose all controllers
    final controllers = [
      titleController,
      addressController,
      priceController,
      overviewController,
      nearbyController,
      additionalDetailsController,
      roomNameController,
      roomPriceController,
      roomDiscountPriceController,
      adultCapacityController,
      childCapacityController,
      roomSizeController,
      roomDescriptionController,
      numberOfRoomController,
      extraPriceAdultController,
      extraPriceMattressController,
      extraPriceChildController,
      vatPercentageController,
      serviceChargeController,
    ];
    for (var c in controllers) {
      c.dispose();
    }
    super.onClose();
  }
}
