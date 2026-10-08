
import '../../consts/consts.dart';


Widget customListItem(BuildContext context) {

  return VStack([
    VxSwiper.builder(
      itemCount: 5,
      height: 180,
      autoPlay: true,
      isFastScrollingEnabled: true,
      viewportFraction: 1.0,
      autoPlayAnimationDuration: 1.seconds,
      // autoPlayCurve: Curves.bounceIn,
      itemBuilder: (context, index) {
        return Image.asset(
          "assets/images/catimage1.webp",
          fit: BoxFit.cover,
          width: context.screenWidth,
        );
      },
    ).box.roundedSM.clip(Clip.antiAlias).make(),
    5.heightBox,
    HStack([
      "Mirpur,Dhaka".text.semiBold.xl2.make().w(context.screenWidth / 1.3),Spacer(),
      Icon(Ionicons.heart_circle_outline,size: 35,)
    ]),
    "House #20,dhaka".text.semiBold.lg.make(),
    5.heightBox,
    HStack([
      Image.asset("assets/images/bed.png",scale: 17,),
      5.widthBox,
      "Single, Double, Triple".text.semiBold.lg.make()
    ]),
    5.heightBox,
    HStack([
      Image.asset("assets/images/children.png",scale: 17,),
      5.widthBox,
      "Boys/Girls".text.semiBold.lg.make()
    ]),
    5.heightBox,
    HStack([
      Image.asset("assets/images/graduating-student.png",scale: 17,),
      "Students/Working Professionals".text.semiBold.lg.make()
    ]),
    5.heightBox,
    Divider(
      thickness: 1.5,
      color:gry
    ),
    5.heightBox,
    HStack([
      "Start From TK 5000".text.semiBold.xl.make(),Spacer(),
      customButton(title: "I'm Interested", onPressed: (){
        // Get.to(()=>QuickTechPropertyDetailsPage());
      }, color: mainColor).h(40)
    ])
  ]).box.roundedSM.p8.margin(EdgeInsets.symmetric(vertical: 10)).border(color: gry).clip(Clip.antiAlias).make();
}

Widget customMyListItem(BuildContext context) {
  return VStack([
    VxSwiper
        .builder(
      itemCount: 5,
      height: 180,
      autoPlay: true,
      isFastScrollingEnabled: true,
      viewportFraction: 1.0,
      autoPlayAnimationDuration: 1.seconds,
      // autoPlayCurve: Curves.bounceIn,
      itemBuilder: (context, index) {
        return Image.asset(
          "assets/images/catimage1.webp",
          fit: BoxFit.cover,
          width: context.screenWidth,
        );
      },
    )
        .box
        .roundedSM
        .clip(Clip.antiAlias)
        .make(),
    5.heightBox,
    HStack([
      "Mirpur,Dhaka".text.semiBold.xl2.make().w(context.screenWidth / 1.3),
      Spacer(),
      Icon(Ionicons.heart_circle_outline, size: 35,)
    ]),
    "House #20,dhaka".text.semiBold.lg.make(),
    5.heightBox,
    HStack([
      Image.asset("assets/images/bed.png", scale: 17,),
      5.widthBox,
      "Single, Double, Triple".text.semiBold.lg.make()
    ]),
    5.heightBox,
    HStack([
      Image.asset("assets/images/children.png", scale: 17,),
      5.widthBox,
      "Boys/Girls".text.semiBold.lg.make()
    ]),
    5.heightBox,
    HStack([
      Image.asset("assets/images/graduating-student.png", scale: 17,),
      "Students/Working Professionals".text.semiBold.lg.make()
    ]),
    5.heightBox,
    Divider(
        thickness: 1.5,
        color: gry
    ),
    5.heightBox,
    HStack([
      5.widthBox,
      Icon(Ionicons.trash_outline, color: Colors.red, size: 30,),
      Spacer(),
      customButton(title: "View", onPressed: () {
        // Get.to(() => QuickTechPropertyDetailsPage());
      }, color: mainColor).h(40).w(context.screenWidth / 3)
    ])
  ]).box.roundedSM.p8.margin(EdgeInsets.symmetric(vertical: 10)).border(
      color: gry).clip(Clip.antiAlias).make();
}
