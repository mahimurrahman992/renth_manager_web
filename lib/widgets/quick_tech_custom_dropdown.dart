import '../../consts/consts.dart';

Widget customDropdownField<T>({
  required String hint,
  required List<DropdownMenuItem<T>> items,
  required T? value,
  required Function(T?) onChanged,
  Widget? prefixIcon,
  Widget? suffixIcon,
  EdgeInsetsGeometry? contentPadding,
  bool enabled = true,
}) {
  final ThemeController themeController = Get.find();

  return DropdownButtonFormField<T>(
    value: value,
    items: items,
    onChanged: enabled ? onChanged : null,
    decoration: InputDecoration(
      contentPadding:contentPadding?? EdgeInsets.only(
        left: 15.w,
        top: 18.h,
        bottom: 18.h,
        right: 15.w,
      ),

      filled: true,
      fillColor: Colors.white,

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: themeController.isDarkMode.value
              ? Colors.white
              : mainColor,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: mainColor,
          width: 1.5,
        ),
      ),

      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: themeController.isDarkMode.value
              ? Colors.white
              : mainColor,
        ),
      ),

      labelText: hint.tr,

      labelStyle: TextStyle(
        color: themeController.isDarkMode.value
            ? Colors.white70
            : Colors.black54,
      ),

      floatingLabelStyle: const TextStyle(
        color: Colors.black,
      ),

      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    ),

    icon: const Icon(
      Icons.keyboard_arrow_down_rounded,
      color: mainColor,
    ),

    dropdownColor: Colors.white,

    borderRadius: BorderRadius.circular(10),
  );
}