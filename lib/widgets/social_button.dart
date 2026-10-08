import '../consts/consts.dart';

Widget socialLoginButton(IconData icon, String text, VoidCallback onTap) {
  return Container(
    width: 200,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade300),
      color: Colors.white,
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: mainColor, size: 24),
            10.widthBox,
            text.text.color(Colors.grey.shade800).size(14).semiBold.make(),
          ],
        ),
      ),
    ),
  );
}