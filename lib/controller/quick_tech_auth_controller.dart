import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../consts/consts.dart';

enum LoginType { email, phone }

class AuthController extends GetxController {
  static bool _isGoogleSignInInitialized = false;
  static const String _googleClientId =
      '382899224834-6nnq4kgs0t8gqns9eper4mn0qvmq84t3.apps.googleusercontent.com';

  StreamSubscription<GoogleSignInAuthenticationEvent>?
      _googleSignInSubscription;

  @override
  void onInit() {
    super.onInit();
    initGoogleSignIn();
  }

  @override
  void onClose() {
    _googleSignInSubscription?.cancel();
    super.onClose();
  }

  Future<void> initGoogleSignIn() async {
    if (!_isGoogleSignInInitialized) {
      try {
        final googleSignIn = GoogleSignIn.instance;
        if (kIsWeb) {
          await googleSignIn.initialize(
            clientId: _googleClientId,
          );
        } else {
          await googleSignIn.initialize(
            serverClientId: _googleClientId,
          );
        }
        _isGoogleSignInInitialized = true;
      } catch (e) {
        if (e.toString().contains('already been called')) {
          _isGoogleSignInInitialized = true;
        } else {
          debugPrint("Google Sign-In initialization warning: $e");
        }
      }
    }

    _googleSignInSubscription ??=
        GoogleSignIn.instance.authenticationEvents.listen(
      (event) async {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          await _handleGoogleUser(event.user);
        }
      },
      onError: (error) {
        debugPrint("Google Sign-In Stream Error: $error");
      },
    );
  }

  Future<void> _handleGoogleUser(GoogleSignInAccount googleUser) async {
    try {
      isLoading.value = true;
      String name = googleUser.displayName ?? '';
      String email = googleUser.email;

      debugPrint("Google User: Name=$name, Email=$email");

      if (!kIsWeb) {
        try {
          final GoogleSignInAuthentication googleAuth =
              googleUser.authentication;
          if (googleAuth.idToken != null) {
            final firebase_auth.AuthCredential credential =
                firebase_auth.GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
            );

            final firebase_auth.UserCredential userCredential =
                await firebase_auth.FirebaseAuth.instance
                    .signInWithCredential(credential);

            final firebase_auth.User? firebaseUser = userCredential.user;
            if (firebaseUser != null) {
              name = (firebaseUser.displayName?.isNotEmpty ?? false)
                  ? firebaseUser.displayName!
                  : name;
              email = (firebaseUser.email?.isNotEmpty ?? false)
                  ? firebaseUser.email!
                  : email;
            }
          }
        } catch (e) {
          debugPrint("Firebase Auth credential link warning: $e");
        }
      }

      if (name.isEmpty && email.isNotEmpty) {
        name = email.split('@').first;
      }

      await googleLoginApi(name: name, email: email);
    } catch (e) {
      debugPrint("Handle Google User Error: $e");
      Get.snackbar('Error', 'Google Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  var isLoading = false.obs;
  var box = GetStorage();
  var selectedCategory = Rxn<PropertyCategories>();

  var name = TextEditingController();
  var password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  RxBool isShowPassword = RxBool(false);
  RxBool isShowConfirmPassword = RxBool(false);
  RxBool isRememberMe = RxBool(false);
  var confirmPassword = TextEditingController();

  var imageFile = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  void selectCategory(PropertyCategories? category) {
    selectedCategory.value = category;
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    } else {
      showWarningToast("No Image Selected");
    }
  }

  Future<void> registerManager(LoginType loginType) async {
    if (name.text.isEmpty ||
        password.text.isEmpty ||
        confirmPassword.text.isEmpty ||
        selectedCategory.value == null) {
      showErrorToast("Required fields missing");
      return;
    }

    if (loginType == LoginType.email && email.text.isEmpty) {
      showErrorToast("Email is required");
      return;
    }

    if (loginType == LoginType.phone && phone.text.isEmpty) {
      showErrorToast("Phone is required");
      return;
    }

    if (password.text.length < 8) {
      showErrorToast("Password must be at least 8 characters long.");
      return;
    }
    if (password.text != confirmPassword.text) {
      showErrorToast("Passwords do not match");
      return;
    }

    final url = Uri.parse(Api.register);
    var request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'name': name.text,
      'password': password.text,
      'password_confirmation': confirmPassword.text,
      'property_category_id': selectedCategory.value!.id.toString(),
    });

    if (loginType == LoginType.email) {
      request.fields['email'] = email.text.trim();
    } else {
      request.fields['phone'] = phone.text.trim();
    }

    if (imageFile.value != null) {
      if (kIsWeb) {
        final bytes = await imageFile.value!.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'profile_photo',
            bytes,
            filename: 'profile.jpg',
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_photo',
            imageFile.value!.path,
            filename: path.basename(imageFile.value!.path),
          ),
        );
      }
    }

    try {
      isLoading.value = true;

      var streamedResponse = await request.send();
      var responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        showSuccessToast("Registration Success");
        Get.offAllNamed(AppRoutes.login, arguments: {'loginType': loginType});
      } else {
        showErrorToast(responseBody);
      }
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithPhone() async {
    final phoneInput = phone.text.trim();
    final passwordInput = password.text;

    if (phoneInput.isEmpty || passwordInput.isEmpty) {
      showErrorToast("Phone number and password are required.");
      return;
    }

    final url = Uri.parse(Api.phoneLogin);
    isLoading.value = true;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneInput, 'password': passwordInput}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        box.write(StorageKeys.accessToken, data['access_token']);

        showSuccessToast("Login Success");
        Get.offAllNamed(AppRoutes.dashboard);
        //Get.offAll(() => QuickTechDashboard());
      } else {
        showErrorToast("Invalid phone credentials");
      }
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithEmail() async {
    final emailInput = email.text.trim();
    final passwordInput = password.text;

    if (emailInput.isEmpty || passwordInput.isEmpty) {
      showErrorToast("Email and password are required.");
      return;
    }

    final url = Uri.parse(Api.emailLogin);
    isLoading.value = true;

    try {
      var request = http.MultipartRequest('POST', url);

      request.fields.addAll({'email': emailInput, 'password': passwordInput});

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        box.write(StorageKeys.accessToken, data['access_token']);

        showSuccessToast("Login Success");
        Get.offAllNamed(AppRoutes.dashboard);
        //Get.offAll(() => QuickTechDashboard());
      } else {
        showErrorToast("Invalid email credentials");
      }
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(LoginType type) async {
    if (type == LoginType.phone) {
      await loginWithPhone();
    } else {
      await loginWithEmail();
    }
  }

  Future<void> forgotPassword(String phone) async {
    if (phone.trim().isEmpty) {
      showErrorToast("Phone number is required");
      return;
    }

    try {
      isLoading.value = true;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Api.forgotPassword),
      );

      request.fields.addAll({'phone': phone.trim()});

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);

        debugPrint("Response: $data");
        debugPrint("Token: ${data['passresetToken']}");

        showSuccessToast(data['message'] ?? "OTP sent successfully");
      } else {
        showErrorToast("Failed to send reset token");
        debugPrint(responseBody);
      }
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword({
    required String phone,
    required String token,
    required String password,
  }) async {
    if (phone.trim().isEmpty ||
        token.trim().isEmpty ||
        password.trim().isEmpty) {
      showErrorToast("All fields are required");
      return;
    }

    try {
      isLoading.value = true;

      var request = http.MultipartRequest('POST', Uri.parse(Api.resetPassword));

      request.fields.addAll({
        'phone': phone.trim(),
        'passresetToken': token.trim(),
        'password': password.trim(),
      });

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);

        debugPrint("Reset Response: $data");

        showSuccessToast(data['message'] ?? "Password reset successful");
        Get.offAllNamed(
          AppRoutes.login,
          arguments: {'loginType': LoginType.phone},
        );
      } else {
        debugPrint(responseBody);
        showErrorToast("Password reset failed");
      }
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleLoginApi({
    required String name,
    required String email,
  }) async {
    try {
      isLoading.value = true;

      debugPrint("googleLoginApi called");
      debugPrint("URL: ${Api.googleLogin}");
      final url = Uri.parse(Api.googleLogin);
      var body = {'name': name, 'email': email};
      debugPrint("  Body: $body");
      final response = await http
          .post(url, body: body)
          .timeout(const Duration(seconds: 30));

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final token = responseData['access_token'];

        box.write(StorageKeys.accessToken, token);

        debugPrint("TOken:$token");

        showSuccessToast("Login Success");
        Get.offAllNamed(AppRoutes.dashboard);
        //Get.offAll(() => QuickTechDashboard());
      } else {
        Get.snackbar('Warning', '${responseData['message']}');
      }
    } catch (e) {
      debugPrint("Google Login API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleLogin() async {
    try {
      isLoading.value = true;
      await initGoogleSignIn();

      if (GoogleSignIn.instance.supportsAuthenticate()) {
        final GoogleSignInAccount googleUser =
            await GoogleSignIn.instance.authenticate();
        await _handleGoogleUser(googleUser);
      } else if (kIsWeb) {
        final GoogleSignInAccount? user =
            await GoogleSignIn.instance.attemptLightweightAuthentication();
        if (user != null) {
          await _handleGoogleUser(user);
        }
      }
    } catch (e) {
      debugPrint("Google Login Error: $e");

      Get.snackbar('Error', 'Google Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleLogout() async {
    try {
      try {
        await GoogleSignIn.instance.disconnect();
      } catch (_) {
        await GoogleSignIn.instance.signOut();
      }

      if (!kIsWeb) {
        try {
          await firebase_auth.FirebaseAuth.instance.signOut();
        } catch (_) {}
      }

      await box.erase();

      Get.offAllNamed(AppRoutes.chooseLoginType);

      // Get.offAll(
      //   () => QuickTechChooseLoginTypeScreen(),
      // );
    } catch (e) {
      Get.snackbar('Error', 'Google Logout failed: ${e.toString()}');
    }
  }
}
