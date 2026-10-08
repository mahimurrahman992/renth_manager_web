import 'consts.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;
  final storage = GetStorage();
  final String _themeKey = 'isDarkMode';
  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(size: 30, color: Colors.black),
      backgroundColor:  Colors.transparent,),
  );

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(size: 30, color: Colors.white),
      backgroundColor:  Colors.transparent,),
  );

  // Toggle between light and dark themes
  @override
  void onInit() {
    super.onInit();
    _loadTheme(); // Load theme on initialization
  }

  // Load theme from GetStorage
  void _loadTheme() {
    isDarkMode.value = storage.read(_themeKey) ?? false;
  }

  // Save theme to GetStorage
  void _saveTheme(bool isDark) {
    storage.write(_themeKey, isDark);
  }

  // Toggle theme and save preference
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _saveTheme(isDarkMode.value);
  }

  // Get the current theme
  ThemeData get currentTheme => isDarkMode.value ? darkTheme : lightTheme;
}


