import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:renth_manager/model/response/quickech_get_room_data.dart';

import '../consts/consts.dart';

class CommonController extends GetxController {
  var division = DivisionModel().obs;
  var district = DistrictModel().obs;
  var thana = ThanaModel().obs;

  var countries = <Countries>[].obs;
  var propertyCategories = <PropertyCategories>[].obs;
  var districtsOfCountry = <District>[].obs;

  var selectedCategory = Rxn<PropertyCategories>();
  var selectedCountry = Rxn<Countries>();
  var selectedDistrict = Rxn<District>();

  var properties = <Properties>[].obs;
  var roomTypes = <Type>[].obs;
  var bedTypes = <Type>[].obs;
  var facilities = <Faciliti>[].obs;

  var selectedProperty = Rxn<Properties>();
  var selectedRoomType = Rxn<Type>();
  var selectedBedType = Rxn<Type>();

  var selectedFacility = Rxn<Faciliti>();
  var isLoading = false.obs;

  final token = GetStorage().read(StorageKeys.accessToken);

  var selectedFacilityIds = <int>[].obs;
  void toggleFacility(int id) {
    if (selectedFacilityIds.contains(id)) {
      selectedFacilityIds.remove(id);
    } else {
      selectedFacilityIds.add(id);
    }
  }

  // =========================
  // SELECTORS
  // =========================
  void selectCategory(PropertyCategories? category) {
    selectedCategory.value = category;
  }

  void selectCountry(Countries? country) {
    selectedCountry.value = country;
  }

  void selectDistrict(District? district) {
    selectedDistrict.value = district;
  }

  // =========================
  // API: DIVISION
  // =========================
  Future<void> fetchDivisions() async {
    final url = Uri.parse(Api.division);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        division.value = DivisionModel.fromJson(data);
      } else {
        showErrorToast("Failed to load divisions");
      }
    } catch (e) {
      showErrorToast("Error: $e");
      log("fetchDivisions error: $e");
    }
  }

  // =========================
  // API: DISTRICT
  // =========================
  Future<void> fetchDistricts(id) async {
    final url = Uri.parse("${Api.district}$id");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        district.value = DistrictModel.fromJson(data);
      } else {
        showErrorToast("Failed to load districts");
      }
    } catch (e) {
      showErrorToast("Error loading districts");
    }
  }

  // =========================
  // API: THANA
  // =========================
  Future<void> fetchThana(id) async {
    final url = Uri.parse("${Api.thana}$id");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        thana.value = ThanaModel.fromJson(data);
      } else {
        showErrorToast("Failed to load thana");
      }
    } catch (e) {
      showErrorToast("Error loading thana");
    }
  }

  // =========================
  // API: COUNTRY + CATEGORY
  // =========================
  Future<void> fetchPropertyCategories() async {
    final url = Uri.parse(Api.getCountryCategories);
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final responseData = QuicktechCountryProperyCatgResponse.fromJson(data);

        countries.value = responseData.countries ?? [];
        propertyCategories.value = responseData.propertyCategories ?? [];
        debugPrint(
          "Countries: ${countries.length}, Property Categoris Fetched",
        );
        debugPrint("Tokehn: $token");
        //showSuccessToast("Data loaded successfully");
      } else {
        showErrorToast("Failed to load categories");
      }
    } catch (e) {
      showErrorToast("Error: $e");
    }
  }

  // =========================
  // API: DISTRICT BY COUNTRY
  // =========================
  Future<void> fetchDistrictsByCountry(int countryId) async {
    final url = Uri.parse(Api.getdistrictsbyCountry(countryId));
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final responseData = QuicktechgetdistrictByCountryResponse.fromJson(
          data,
        );

        districtsOfCountry.value = responseData.districts ?? [];
      } else {
        showErrorToast("Failed to load districts");
      }
    } catch (e) {
      showErrorToast("Error: $e");
    }
  }

  // =========================
  // API: ROOM CREATE DATA
  // =========================
  Future<void> fetchRoomCreateData() async {
    final token = GetStorage().read(StorageKeys.accessToken);
    try {
      isLoading.value = true;

      var headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('GET', Uri.parse(Api.getRoomData));
      debugPrint("Get Room Data Api:${Api.getRoomData}");
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String body = await response.stream.bytesToString();
      final data = jsonDecode(body);
      debugPrint("Room data response: $data");

      if (response.statusCode == 200) {
        final model = QuicktechgetroomDataResponse.fromJson(data);

        properties.value = model.properties;
        roomTypes.value = model.roomTypes;
        bedTypes.value = model.bedTypes;
        facilities.value = model.facilities;
        showSuccessToast("Room data loaded");
      } else {
        debugPrint("Failed to load room data: ${body.toString()}");
        showErrorToast("${data['message'] ?? 'Failed to load room data'}");
      }
    } catch (e) {
      debugPrint("Error fetching room data: $e");
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
