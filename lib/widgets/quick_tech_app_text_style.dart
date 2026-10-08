
import '../consts/consts.dart';

class QuickTechAppTextStyle {
  // ================= Display (boro title) =================
  static TextStyle displayLarge() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w800,
        fontSize: 44.sp,
        height: 1.2,
      ),
    );
  }

  static TextStyle displayMedium() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w800,
        fontSize: 32.sp,
      ),
    );
  }

  static TextStyle displaySmall() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w800,
        fontSize: 28.sp,
      ),
    );
  }

  // ================= Underline / Link (16sp) =================
  static TextStyle bodyUnderline() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontSize: 16.sp,
        decoration: TextDecoration.underline,
      ),
    );
  }

  static TextStyle bodyLink() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: mainColor,
        fontWeight: FontWeight.w700,
        fontSize: 16.sp,
      ),
    );
  }

  // ================= Small link (14sp) =================
  static TextStyle linkSmall() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: mainColorDark,
        fontWeight: FontWeight.w600,
        fontSize: 14.sp,
      ),
    );
  }

  // ================= Subtitle (grey text) =================
  static TextStyle subtitle() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: hintColor,
        fontSize: 14.sp,
      ),
    );
  }

  static TextStyle subtitleLarge() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: hintColor,
        fontSize: 16.sp,
      ),
    );
  }

  // ================= Headlines =================
  static TextStyle headline1() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 30.sp,
      ),
    );
  }

  static TextStyle headline2() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontWeight: FontWeight.w600,
        fontSize: 24.sp,
      ),
    );
  }

  static TextStyle headline3() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontWeight: FontWeight.w600,
        fontSize: 20.sp,
      ),
    );
  }

  static TextStyle headline4() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontWeight: FontWeight.w600,
        fontSize: 18.sp,
      ),
    );
  }

  static TextStyle headline5() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 10.sp,
      ),
    );
  }

  static TextStyle headline6() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
      ),
    );
  }

  // ================= Body =================
  static TextStyle bodyText1() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontSize: 18.sp,
      ),
    );
  }

  static TextStyle bodyText2() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontSize: 16.sp,
      ),
    );
  }

  static TextStyle bodyText3() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontSize: 14.sp,
      ),
    );
  }

  // color optional: bodyText4() ba bodyText4(color: white)
  static TextStyle bodyText4({Color color = Colors.black}) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: color,
        fontSize: 12.sp,
      ),
    );
  }

  static TextStyle bodyText5() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.grey,
        fontSize: 10.sp,
      ),
    );
  }

  // ================= Bold Body =================
  static TextStyle bodyBold1() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
      ),
    );
  }

  static TextStyle bodyBold2() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontWeight: FontWeight.w600,
        fontSize: 14.sp,
      ),
    );
  }

  static TextStyle bodyBold3() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontWeight: FontWeight.w600,
        fontSize: 12.sp,
      ),
    );
  }

  // ================= App Bar =================
  static TextStyle appBarTitle() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 20.sp,
      ),
    );
  }

  // ================= Buttons =================
  static TextStyle button() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: textOnMain,
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
      ),
    );
  }

  static TextStyle buttonSmall() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: textOnMain,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
    );
  }

  // ================= Form / TextField =================
  static TextStyle inputText() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontSize: 16.sp,
      ),
    );
  }

  static TextStyle hintText() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.grey,
        fontSize: 14.sp,
      ),
    );
  }

  static TextStyle labelText() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
    );
  }

  static TextStyle errorText() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.red,
        fontSize: 12.sp,
      ),
    );
  }

  static TextStyle successText() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.green,
        fontSize: 12.sp,
      ),
    );
  }

  // ================= Others =================
  static TextStyle caption() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.grey,
        fontSize: 12.sp,
      ),
    );
  }

  static TextStyle link() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
        decoration: TextDecoration.underline,
      ),
    );
  }

  static TextStyle price() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 18.sp,
      ),
    );
  }

  static TextStyle oldPrice() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.grey,
        fontSize: 14.sp,
        decoration: TextDecoration.lineThrough,
      ),
    );
  }

  static TextStyle badge() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 10.sp,
      ),
    );
  }

  static TextStyle tabLabel() {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: gryBlack,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
    );
  }
}