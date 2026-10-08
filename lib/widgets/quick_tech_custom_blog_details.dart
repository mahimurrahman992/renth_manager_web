import '../../consts/consts.dart';

Widget customBlogList(BuildContext context){
  final ThemeController themeController = Get.find();
  return Obx(
    () =>
        VStack([
              Image.asset(
                "assets/images/blog_img1.png",
                width: context.screenWidth,
                height: 160,
                fit: BoxFit.fill,
              ),
              "Demo Title".text.semiBold.xl2.make().paddingAll(5),
              "Demo Sub Title".text.semiBold.lg.make().paddingAll(5),
              Spacer(),
              HStack(alignment: MainAxisAlignment.spaceBetween, [
                "Admin".text.semiBold.make(),
                "10 Oct 2024".text.semiBold.make(),
              ]).w(context.screenWidth).paddingAll(5),
            ])
            .h(300)
            .w(context.screenWidth)
            .card
            .elevation(1.5)
            .color(
              themeController.isDarkMode.value ? gry.withValues(alpha: 0.4) : white,
            )
            .make()
            .p8(),
  );
}
