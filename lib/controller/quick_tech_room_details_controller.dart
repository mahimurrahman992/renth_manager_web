import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:renth_manager/consts/consts.dart';
import 'package:renth_manager/model/response/quick_tech_room_details_response.dart' hide PropertyRoom;
import 'package:renth_manager/model/response/quickech_get_room_data.dart';

class RoomDetailsController extends GetxController {
var isLoading = false.obs;
  var roomDetails = QuicktechRoomDetails().obs;
  var errorMessage = ''.obs;

  // Dropdown data
  var properties = <Properties>[].obs;
  var roomTypes = <Type>[].obs;
  var bedTypes = <Type>[].obs;
  var facilities = <Faciliti>[].obs;

  // Selected values
  var selectedProperty = Rxn<Properties>();
  var selectedRoomType = Rxn<Type>();
  var selectedBedType = Rxn<Type>();
  var selectedFacilityIds = <int>[].obs;

  // Editable fields
  var roomNameController = TextEditingController();
  var roomPriceController = TextEditingController();
  var capacityAdultsController = TextEditingController();
  var capacityChildrenController = TextEditingController();
  var roomSizeController = TextEditingController();
  var roomDescriptionController = TextEditingController();
  var numberOfRoomController = TextEditingController();
  var extraPriceAdultController = TextEditingController();
  var extraPriceChildController = TextEditingController();
  var discountPriceController = TextEditingController();
  var extraMattressPriceController = TextEditingController();
  var vatPercentageController = TextEditingController();
  var serviceChargeController = TextEditingController();

  // Media Reactive Variables
  var selectedVideo = Rxn<File>();
  var selectedImages = <File>[].obs;

  final ImagePicker _picker = ImagePicker();
  final CommonController commonController = locator.get<CommonController>();

  @override
  void onInit() {
    super.onInit();
    _loadCreateData();
  }

  Future<void> _loadCreateData() async {
    try {
      await commonController.fetchRoomCreateData();
      properties.value = commonController.properties;
      roomTypes.value = commonController.roomTypes;
      bedTypes.value = commonController.bedTypes;
      facilities.value = commonController.facilities;
    } catch (e) {
      debugPrint("Error loading create data: $e");
    }
  }

// --- MEDIA PICKING METHODS WITH SOURCE ---
  
  // ইমেজ পিক করার মেথড
  Future<void> pickImages(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        // ক্যামেরা দিয়ে একবারে একটি ছবিই তোলা যায়
        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          selectedImages.add(File(image.path)); // এক্সিস্টিং লিস্টে যোগ হবে
        }
      } else {
        // গ্যালারি থেকে একসাথে একাধিক ছবি সিলেক্ট করা যাবে
        final List<XFile> images = await _picker.pickMultiImage();
        if (images.isNotEmpty) {
          // আগের ছবিগুলো রেখে নতুনগুলো যোগ করতে চাইলে .addAll ব্যবহার করতে পারেন
          selectedImages.addAll(images.map((img) => File(img.path)).toList());
        }
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  // ভিডিও পিক করার মেথড
  Future<void> pickVideo(ImageSource source) async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5), // অপশনাল: ম্যাক্সিমাম ডিউরেশন সেট করতে পারেন
      );
      if (video != null) {
        selectedVideo.value = File(video.path);
      }
    } catch (e) {
      debugPrint("Error picking video: $e");
    }
  }

  int parsePrice(String value) {
    return int.tryParse(value.replaceAll(',', '').trim()) ?? 0;
  }
  // --- API UPDATE METHOD ---
  Future<void> updateRoomDetails(int roomId) async {
    final category = selectedProperty.value?.propertyCategory?.name ?? "Hotel";

    // Validation
    if (selectedProperty.value == null) {
      showErrorToast("Please select Property");
      return;
    }

    if (roomNameController.text.trim().isEmpty) {
      String hint = 'room name';
      if (category == 'Flat Sale/Buy') {
        hint = 'flat name';
      } else if (category == 'Family Home') {
        hint = 'home name';
      }
      else if (category == 'Rider') {
        hint = 'rider name';
      }
      showErrorToast("Enter $hint");
      return;
    }

    if (selectedRoomType.value == null) {
      String hint = "room type";
      if (category == 'Flat Sale/Buy' || category == 'Family Home') {
        hint = "flat type";
      } else if (category == 'Rider') {
        hint = "rider type";
      }
      showErrorToast("Select $hint");
      return;
    }

    if (category != 'Flat Sale/Buy' && category != 'Rider' && selectedBedType.value == null) {
      showErrorToast("Select bed type");
      return;
    }

    if (roomPriceController.text.trim().isEmpty) {
      String hint = 'room price';
      if (category == 'Flat Sale/Buy') {
        hint = 'sale price';
      } else if (category == 'Family Home' || category == 'Bachelor' || category == 'Hostel' || category == 'Rider') {
        hint = 'monthly rent';
      }
      showErrorToast("Enter $hint");
      return;
    }

    if (category != 'Rider' && capacityAdultsController.text.trim().isEmpty) {
      showErrorToast("Enter adult capacity");
      return;
    }

    if (category == 'Hotel' && capacityChildrenController.text.trim().isEmpty) {
      showErrorToast("Enter child capacity");
      return;
    }

    if (roomSizeController.text.trim().isEmpty) {
      String hint = 'room size';
      if (category == 'Flat Sale/Buy') {
        hint = 'flat size';
      } else if (category == 'Family Home') {
        hint = 'home size';
      }
      showErrorToast("Enter $hint");
      return;
    }

    final vat = double.tryParse(vatPercentageController.text.trim()) ?? 0;
    if (vat > 100) {
      showErrorToast("VAT percentage cannot be greater than 100%");
      return;
    }

    if (numberOfRoomController.text.trim().isEmpty) {
      String hint = 'number of rooms';
      if (category == 'Flat Sale/Buy') {
        hint = 'number of flats';
      } else if (category == 'Family Home') {
        hint = 'number of homes';
      }
      showErrorToast("Enter $hint");
      return;
    }

    try {
      isLoading(true);

      var url = Uri.parse(Api.roomUpdate);
      var token = GetStorage().read(StorageKeys.accessToken);

      var request = http.MultipartRequest('POST', url);

      // Headers
      request.headers.addAll({
        'Authorization': "Bearer $token",
        'Accept': 'application/json',
      });

      // Fields Data
      request.fields.addAll({
        'property_room_id': roomId.toString(),
        'property_id': selectedProperty.value!.id.toString(),
        'room_type_id': selectedRoomType.value!.id.toString(),
        'bed_type_id': (category == 'Flat Sale/Buy' || category == 'Rider') ? '0' : selectedBedType.value?.id.toString() ?? '0',
        'room_name': roomNameController.text.trim(),
        'room_price_per_night': parsePrice(roomPriceController.text.trim()).toString(),
        'capacity_of_adults': category == 'Rider' ? '0' : capacityAdultsController.text.trim(),
        'capacity_of_children': category == 'Hotel' ? capacityChildrenController.text.trim() : '0',
        'room_size': roomSizeController.text.trim(),
        'room_description': roomDescriptionController.text.trim(),
        'number_of_room': numberOfRoomController.text.trim(),
        'extra_price_per_adult': category == 'Hotel' ? parsePrice(extraPriceAdultController.text.trim()).toString() : '0',
        'extra_price_per_child_bed': category == 'Hotel' ? parsePrice(extraPriceChildController.text.trim()).toString() : '0',
        'discount_price_per_night': parsePrice(discountPriceController.text.trim()).toString(),
        'extra_mattress_price_per_night': category == 'Hotel' ? parsePrice(extraMattressPriceController.text.trim()).toString() : '0',
        'vat_percentage': vatPercentageController.text.trim(),
        'service_charge': serviceChargeController.text.trim(),
      });

      // Facility IDs Mapping as Multiple Key-Value Pairs (Hotel only)
      if (category == 'Hotel') {
        for (var id in selectedFacilityIds) {
          request.fields.addAll({'facilityIds[]': id.toString()});
        }
      }

      // Add Video File (If picked)
      if (selectedVideo.value != null) {
        if (kIsWeb) {
          final xfile = XFile(selectedVideo.value!.path);
          final bytes = await xfile.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              'video',
              bytes,
              filename: xfile.name.isNotEmpty ? xfile.name : 'video.mp4',
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              'video',
              selectedVideo.value!.path,
            ),
          );
        }
        debugPrint("✓ Video attached to request");
      }

      // Add Multiple Images (If picked)
      for (var i = 0; i < selectedImages.length; i++) {
        if (kIsWeb) {
          final xfile = XFile(selectedImages[i].path);
          final bytes = await xfile.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              'multi_img[]',
              bytes,
              filename: xfile.name.isNotEmpty ? xfile.name : 'room_img_$i.jpg',
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              'multi_img[]',
              selectedImages[i].path,
            ),
          );
        }
      }
      if (selectedImages.isNotEmpty) {
        debugPrint("✓ ${selectedImages.length} images attached to request");
      }

      // Send Request
      debugPrint("Sending update request...");
      http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        debugPrint("Update Success Response: $responseBody");
        showSuccessToast("Room updated successfully");
        Get.back(result: true); // রিলোড সিগন্যালসহ ব্যাক করবে
      } else {
        String errorBody = await response.stream.bytesToString();
        debugPrint("Failed to update: Status ${response.statusCode}, Body: $errorBody");
        
        String errorMsg = "Failed to update room. Status: ${response.statusCode}";
        try {
          final decoded = jsonDecode(errorBody);
          errorMsg = decoded['message'] ?? decoded['error'] ?? errorMsg;
        } catch (_) {}

        showErrorToast(errorMsg);
      }
    } catch (e) {
      debugPrint("Exception inside updateRoomDetails: $e");
      showErrorToast("Error: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchRoomDetails(int roomId) async {
    try {
      isLoading(true);
      errorMessage('');

      // Ensure dropdown data is loaded first
      if (properties.isEmpty) {
        await _loadCreateData();
      }

      final url = Api.roomDetails(roomId);
      final token = GetStorage().read(StorageKeys.accessToken);
debugPrint(url);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer $token",
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        roomDetails.value = QuicktechRoomDetails.fromJson(data);
        
        // Populate all controllers and select dropdowns
        await Future.delayed(const Duration(milliseconds: 100));
        _populateControllers();
        
        debugPrint("✓ Room details fetched and populated successfully");
      } else {
        errorMessage.value = "Error: ${response.statusCode}";
        showErrorToast("Failed to load room details");
      }
    } on SocketException {
      errorMessage.value = "Network error";
      showErrorToast("Network connection failed");
    } catch (e) {
      errorMessage.value = "Exception: $e";
      showErrorToast("Error: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  void _populateControllers() {
    final room = roomDetails.value.propertyRoom;
    if (room != null) {
      // TextFields
      roomNameController.text = room.roomName ?? '';
      roomPriceController.text = room.roomPricePerNight ?? '';
      capacityAdultsController.text = room.capacityOfAdults?.toString() ?? '';
      capacityChildrenController.text = room.capacityOfChildren?.toString() ?? '';
      roomSizeController.text = room.roomSize ?? '';
      roomDescriptionController.text = room.roomDescription ?? '';
      numberOfRoomController.text = room.numberOfRoom?.toString() ?? '';
      extraPriceAdultController.text = room.extraPricePerAdult ?? '';
      extraPriceChildController.text = room.extraPricePerChildBed ?? '';
      discountPriceController.text = room.discountPricePerNight ?? '';
      extraMattressPriceController.text = room.extraMattressPricePerNight ?? '';
      vatPercentageController.text = room.vatPercentage?.toString() ?? '';
      serviceChargeController.text = room.serviceCharge ?? '';

      // Dropdowns - Find matching items and set them
      if (room.propertyId != null) {
        final matchedProperty = properties.firstWhereOrNull(
          (p) => p.id == room.propertyId,
        );
        if (matchedProperty != null) {
          selectedProperty.value = matchedProperty;
          debugPrint("✓ Property selected: ${matchedProperty.title}");
        }
      }

      if (room.roomTypeId != null) {
        final matchedRoomType = roomTypes.firstWhereOrNull(
          (rt) => rt.id == room.roomTypeId,
        );
        if (matchedRoomType != null) {
          selectedRoomType.value = matchedRoomType;
          debugPrint("✓ Room Type selected: ${matchedRoomType.name}");
        }
      }

      if (room.bedTypeId != null) {
        final matchedBedType = bedTypes.firstWhereOrNull(
          (bt) => bt.id == room.bedTypeId,
        );
        if (matchedBedType != null) {
          selectedBedType.value = matchedBedType;
          debugPrint("✓ Bed Type selected: ${matchedBedType.name}");
        }
      }

      // Facilities
      if (room.facilities != null && room.facilities!.isNotEmpty) {
        selectedFacilityIds.value = room.facilities!
            .map((f) => f.id ?? 0)
            .where((id) => id != 0)
            .toList();
        debugPrint("✓ Facilities selected: ${selectedFacilityIds.length}");
      }
    }
  }

  void toggleFacility(int id) {
    if (selectedFacilityIds.contains(id)) {
      selectedFacilityIds.remove(id);
    } else {
      selectedFacilityIds.add(id);
    }
  }

  void clearControllers() {
    roomNameController.clear();
    roomPriceController.clear();
    capacityAdultsController.clear();
    capacityChildrenController.clear();
    roomSizeController.clear();
    roomDescriptionController.clear();
    numberOfRoomController.clear();
    extraPriceAdultController.clear();
    extraPriceChildController.clear();
    discountPriceController.clear();
    extraMattressPriceController.clear();
    vatPercentageController.clear();
    serviceChargeController.clear();
    selectedProperty.value = null;
    selectedRoomType.value = null;
    selectedBedType.value = null;
    selectedFacilityIds.clear();
  }

  @override
  void onClose() {
    roomNameController.dispose();
    roomPriceController.dispose();
    capacityAdultsController.dispose();
    capacityChildrenController.dispose();
    roomSizeController.dispose();
    roomDescriptionController.dispose();
    numberOfRoomController.dispose();
    extraPriceAdultController.dispose();
    extraPriceChildController.dispose();
    discountPriceController.dispose();
    extraMattressPriceController.dispose();
    vatPercentageController.dispose();
    serviceChargeController.dispose();
    super.onClose();
  }
}