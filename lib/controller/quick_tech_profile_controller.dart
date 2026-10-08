import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:renth_manager/consts/consts.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var name = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  var country = TextEditingController();
  var profession = TextEditingController();
  var birthdate = TextEditingController();
  var address = TextEditingController();

  var box = GetStorage();
  var profile = ProfileModel().obs;
  final List<String> genders = ['Male', 'Female', 'Other'];
  var selectedGender = ''.obs;
  var imageFile = Rxn<File>();
  var pickedXFile = Rxn<XFile>();
  var pickedBytes = Rxn<Uint8List>();
  var selectedCountry = Rxn<Countries>();

  void setCountry(Countries? country) {
    selectedCountry.value = country;
  }

  final ImagePicker _picker = ImagePicker();
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      pickedXFile.value = pickedFile;
      final bytes = await pickedFile.readAsBytes();
      pickedBytes.value = bytes;
      if (!kIsWeb) {
        imageFile.value = File(pickedFile.path);
      }
      update();
    } else {
      Get.snackbar('No Image', 'You did not select an image.');
    }
  }

  Future<void> selectBirthDate() async {
    DateTime? selectedDate = await Get.dialog<DateTime>(
      DatePickerDialog(
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        helpText: 'Select Birth Date',
        cancelText: 'Cancel',
        confirmText: 'Select',
      ),
    );

    if (selectedDate != null) {
      String formattedDate =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
      birthdate.text = formattedDate;
    }
  }

  loadData() {
    name.text = profile.value.user?.name??'';
    email.text = profile.value.user?.email??'';
    phone.text = profile.value.user?.phone??'';

    profession.text = "${profile.value.user?.type ?? "N/A"}";

    if (profile.value.user?.birthday != null &&
        profile.value.user?.birthday != "N/A") {
      birthdate.text = "${profile.value.user?.birthday}";
    } else {
      birthdate.text = "";
    }

    setGender('${profile.value.user?.gender ?? ""}');
    address.text = "${profile.value.user?.address ?? "N/A"}";
    final countryName = profile.value.user?.country;

    if (countryName != null && countryName.isNotEmpty) {
      final common = locator.get<CommonController>();

      final matched = common.countries.firstWhereOrNull(
        (c) => c.name == countryName,
      );

      if (matched != null) {
        selectedCountry.value = matched;
      }
    }
  }

  void setGender(String value) {
    selectedGender.value = value;
  }

  Future<void> getProfile() async {
    final url = Uri.parse(Api.getProfile);
    final headers = {
      'Authorization': 'Bearer ${box.read(StorageKeys.accessToken)}',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    isLoading.value = true;
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("Profile Data: ${response.body}");
        profile.value = ProfileModel.fromJson(data);
        if (profile.value.user?.country != null) {
          final common = locator.get<CommonController>();

          ever(common.countries, (_) {
            final matched = common.countries.firstWhereOrNull(
              (c) => c.name == profile.value.user?.country,
            );

            if (matched != null) {
              selectedCountry.value = matched;
            }
          });
        }
      } else {
        debugPrint("❌ Error ${response.statusCode}: ${response.reasonPhrase}");
      }
      profile.refresh();
    } catch (e) {
      debugPrint("⚠️ Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    final Uri url = Uri.parse(Api.profileUpdate);

    var headers = {'Authorization': 'Bearer ${box.read(StorageKeys.accessToken)}'};

    var request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'name': name.text,
      'email': email.text,
      'phone': phone.text,
      'address': address.text,
      
      'type': profession.text,
      'gender': selectedGender.value,
      'birthday': birthdate.text,
    });

    // 🔥 IMPORTANT: overwrite with dropdown country if selected
    if (selectedCountry.value != null) {
      request.fields['country'] =
    selectedCountry.value?.name ?? "";
    }

    // image
    if (pickedBytes.value != null) {
      final filename = pickedXFile.value?.name.isNotEmpty == true
          ? pickedXFile.value!.name
          : 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      request.files.add(
        http.MultipartFile.fromBytes(
          'profile_photo',
          pickedBytes.value!,
          filename: filename,
        ),
      );
    } else if (pickedXFile.value != null) {
      final bytes = await pickedXFile.value!.readAsBytes();
      final filename = pickedXFile.value!.name.isNotEmpty
          ? pickedXFile.value!.name
          : 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      request.files.add(
        http.MultipartFile.fromBytes(
          'profile_photo',
          bytes,
          filename: filename,
        ),
      );
    } else if (imageFile.value != null) {
      if (kIsWeb) {
        final xfile = XFile(imageFile.value!.path);
        final bytes = await xfile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'profile_photo',
            bytes,
            filename: xfile.name.isNotEmpty ? xfile.name : 'profile.jpg',
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_photo',
            imageFile.value!.path,
          ),
        );
      }
    }

    request.headers.addAll(headers);

    try {
      isLoading.value = true;

      var response = await request.send();
      String body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        showSuccessToast("Profile Updated Successfully");
        Get.offAllNamed(AppRoutes.dashboard);
        //Get.offAll(() => QuickTechDashboard());
      } else {
        showErrorToast(body);
      }
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
