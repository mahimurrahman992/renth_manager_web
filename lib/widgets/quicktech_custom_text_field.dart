
import '../../consts/consts.dart';

// Regular TextField
Widget customTextField({
  icon,
  controller,
  readOnly,
  required String hint,
  required bool isSuffix,
  suIcon,
  keyboard,
  maxline,
  required bool isVisible,
  suppixtap,
  Color? supColor,
  bool? enabled,
}) {
  final ThemeController themeController = Get.find();

  return TextField(
    enabled: enabled,
    obscureText: !isVisible,
    maxLines: maxline ?? 1,
    controller: controller,
    keyboardType: keyboard ?? TextInputType.text,
    readOnly: readOnly ?? false,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.only(left: 15.w, top: 18.h, bottom: 18.h),

      // 🔥 Added disabled border
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: themeController.isDarkMode.value ? Colors.white : mainColor,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: themeController.isDarkMode.value ? Colors.white : mainColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: mainColor, width: 1.5),
      ),

      // 🔥 Helps label appear
      filled: true,
      fillColor: Colors.white,

      isDense: true,
      prefixIcon: icon == null
          ? null
          : Icon(
        icon,
        color: mainColor.withValues(alpha: 0.7),
        size: 27,
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

      suffixIcon: isSuffix
          ? Icon(
        suIcon,
        color: supColor ?? mainColor.withValues(alpha: 0.7),
        size: 26,
      ).onTap(suppixtap)
          : null,
    ),
  );
}
Widget emailTextField({
  required TextEditingController controller,
  required String hint,
  bool isSuffix = false,
  IconData? suIcon,
  VoidCallback? suffixTap,
}) {
  final ThemeController themeController = Get.find();

  return TextField(
    controller: controller,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.only(
        left: 0,
        top: 18.h,
        bottom: 18.h,
        right: 15.w,
      ),

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

      isDense: true,

      // Email prefix icon
      prefixIcon: Icon(
        Icons.email_outlined,
        color: themeController.isDarkMode.value
            ? Colors.white
            : Colors.black,
      ),

      labelText: hint.tr,
      labelStyle: TextStyle(
        color: themeController.isDarkMode.value
            ? Colors.white70
            : Colors.black54,
      ),

      floatingLabelStyle: const TextStyle(
        color: mainColor,
      ),

      floatingLabelBehavior: FloatingLabelBehavior.auto,

      suffixIcon: isSuffix
          ? Icon(
              suIcon,
              color: mainColor.withValues(alpha: 0.7),
              size: 24,
            ).onTap(suffixTap)
          : null,
    ),
  );
}

Widget phoneTextField({
  required TextEditingController controller,
  required String hint,
  String countryCode = '+88',
  bool isSuffix = false,
  suIcon,
  suppixtap,
}) {
  final ThemeController themeController = Get.find();
  final RxString selectedCode = countryCode.obs;

  return TextField(
    controller: controller,
    keyboardType: TextInputType.phone,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.only(left: 0, top: 18.h, bottom: 18.h, right: 15.w),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: themeController.isDarkMode.value ? Colors.white : mainColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: mainColor, width: 1.5),
      ),
      isDense: true,
      prefixIcon: Obx(() => Container(
        padding: EdgeInsets.only(left: 15, right: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedCode.value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: themeController.isDarkMode.value ? Colors.white : Colors.black,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: themeController.isDarkMode.value ? Colors.white : Colors.black,
            ),
          ],
        ),
      )),
      labelText: hint.tr,
      labelStyle: TextStyle(
        color: themeController.isDarkMode.value ? Colors.white70 : Colors.black54,
      ),
      floatingLabelStyle: TextStyle(
        color: mainColor,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      suffixIcon: isSuffix
          ? Icon(
        suIcon,
        color: mainColor.withValues(alpha: 0.7),
        size: 24,
      ).onTap(suppixtap)
          : null,
    ),
  );
}
Widget customTextFieldIconWidget({
  Widget? prefixIcon,
  Widget? suIcon,
  TextEditingController? controller,
  bool readOnly = false,
  bool enabled = true,
  required String hint,
  bool isSuffix = false,
  TextInputType? keyboard,
  int? maxline,
  required bool isVisible,
  VoidCallback? onTap,
  Color? supColor,
}) {
  final ThemeController themeController = Get.find();

  return GestureDetector(
    onTap: onTap, // 👈 full field tap support
    child: AbsorbPointer(
      absorbing: onTap != null, // prevent keyboard if tap handled externally
      child: TextField(
        enabled: enabled,
        obscureText: !isVisible,
        maxLines: maxline ?? 1,
        controller: controller,
        keyboardType: keyboard ?? TextInputType.text,
        readOnly: readOnly,

        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 15.w,
            top: 18.h,
            bottom: 18.h,
          ),

          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: themeController.isDarkMode.value
                  ? Colors.white
                  : mainColor,
            ),
          ),

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
            borderSide: const BorderSide(color: mainColor, width: 1.5),
          ),

          filled: true,
          fillColor: Colors.white,
          isDense: true,

          prefixIcon: prefixIcon,

          labelText: hint.tr,
          labelStyle: TextStyle(
            color: themeController.isDarkMode.value
                ? Colors.white70
                : Colors.black54,
          ),

          floatingLabelStyle: const TextStyle(
            color: Colors.black,
          ),

          suffixIcon: suIcon,
        ),
      ),
    ),
  );
}