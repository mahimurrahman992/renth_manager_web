import '../../consts/consts.dart';

Widget customRow(BuildContext context, String title, String subtitle,onTap) {
  return Row(
    children: [
      title.tr.text.xl2.semiBold.make().w(context.screenWidth/1.5),
      Spacer(),
      subtitle.text.semiBold.xl.color(mainColor).make().onTap(onTap)
    ],
  );
}

Widget customRowWithBg(BuildContext context, String title, String subtitle,onTap,bgc){
  return Row(
    children: [
      title.tr.text.xl.semiBold.make().w(context.screenWidth/1.5),
      Spacer(),
      subtitle.text.semiBold.color(mainColor).make().onTap(onTap)
    ],
  ).box.color(bgc??mainColor.withValues(alpha: 0.15)).roundedSM.p8.clip(Clip.antiAlias).make();
}

