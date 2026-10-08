import '../../consts/consts.dart';

Widget customSearchWidget(BuildContext context){
return  Stack(
    children: [
      Positioned.fill(
        child: Image.asset(
          "assets/images/banner.png",
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        left: 10,
        top: 10,
        child:
        "What you see is What you get".text.semiBold.xl
            .textStyle(GoogleFonts.oswald())
            .make(),
      ),
      Positioned(
        top: 70,
        left: 0,
        right: 0,
        child: HStack(alignment: MainAxisAlignment.spaceBetween, [
          "Search Here".text.semiBold.make(),

          Icon(Icons.search),
        ])
            .p12()
            .card
            .rounded
            .shadowColor(mainColor)
            .elevation(2)
            .make()
            .paddingSymmetric(horizontal: dynamicSize).onTap((){
          // Get.to(()=>QuickTechSearchPage());
        })
      ),
    ],
  ).w(context.screenWidth).h(200);
}