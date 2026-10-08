
import 'package:renth_manager/widgets/quick_tech_custom_row_design.dart';

import '../../consts/consts.dart';
import '../controller/quick_tech_property_details_controller.dart';
var list=["Common","Room","Service"];
var list2 = ["Single Sharing", "Double Sharing", "Triple Sharing"];

Widget customSliderImageProperty(BuildContext context){
  return VxSwiper.builder(
    itemCount: 5,
    height: 200,
    autoPlay: true,
    isFastScrollingEnabled: true,

    viewportFraction: 1.0,
    autoPlayAnimationDuration: 1.seconds,
    // autoPlayCurve: Curves.bounceIn,
    itemBuilder: (context, index) {
      return Image.asset("assets/images/catimage1.webp",fit: BoxFit.cover,width: context.screenWidth,);
    },
  ).box.roundedSM.clip(Clip.antiAlias).make();
}

Widget customAboutProperty(BuildContext context) {
  return VStack([
    "Mirpur, Dhaka".text.semiBold.xl3.make(),
    10.heightBox,
    customRowWithBg(context, "About Property", "", () {}, null),
    10.heightBox,
    "Welcome to The Willow Creek Residence, a beautifully designed 4-bedroom, 3-bathroom single-family home nestled in a quiet, tree-lined neighborhood in Austin, Texas. This elegant home features an open-concept layout with soaring ceilings, large windows that flood the space with natural light, and rich hardwood floors throughout. The gourmet kitchen is a chef’s dream, complete with quartz countertops, custom cabinetry, and high-end stainless steel appliances. The spacious master suite includes a walk-in closet and a luxurious bathroom with a soaking tub and separate glass shower. Step outside to a private, fenced backyard with a covered patio—perfect for entertaining or relaxing evenings. Located minutes from top-rated schools, parks, and downtown Austin, this home combines comfort, style, and convenience in one stunning package."
        .text
        .semiBold
        .make().p2(),
  ]);
}

Widget customAmenitiesProperty(BuildContext context){
  final PropertyDetailsController  controller= Get.find();
  return VStack([
    customRowWithBg(context, "Property Amenities", "", () {}, null),

    ListView.builder(scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      padding: EdgeInsets.all(8),
      itemCount: 3, // Change this if you have a dynamic list
      itemBuilder: (context, index) {
        return Obx(
            ()=>Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(8),topLeft: Radius.circular(8)),
              border:  controller.selectedIndex.value == index
                  ? Border(
                top: BorderSide(width: 1, color: gry),
                right: BorderSide(width: 1, color: gry),
                left: BorderSide(width: 1, color: gry),
              )
                  : Border(bottom: BorderSide(width: 1, color: gry) ),
            ),
            child: list[index].text.semiBold.xl.make(),
          ).onTap((){
            controller.selectedIndex.value = index;
          }),
        );
      },
    ).h(60),
    ListView.builder(
      physics: NeverScrollableScrollPhysics(),
        itemCount: 3,shrinkWrap: true,
        itemBuilder: (context,index){
      return ListTile(leading:Icon(Ionicons.home_outline),

          title: "demo Title".text.semiBold.make(),);
    })
  ]);
}

Widget customTermsProperty(BuildContext context){
  return VStack([
    customRowWithBg(context, "Renting Terms", "", (){}, null),
    ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3,shrinkWrap: true,
        itemBuilder: (context,index){
          return ListTile(leading:Icon(Ionicons.document_text_outline),

            title: "demo Terms".text.semiBold.make(),);
        })
  ]);
}

Widget customPackageProperty(BuildContext context){
  return VStack([
    customRowWithBg(context, "Rent Package", "", () {}, null),
    ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3,shrinkWrap: true,
        itemBuilder: (context,index){
          return ListTile(leading:Icon(Ionicons.people_outline),

            title: "Couple Share".text.semiBold.make(),
          trailing: "Tk 250/-".text.semiBold.make(),
          );
        })
  ]);
}

Widget customRulesProperty(BuildContext context){
  return VStack([
    customRowWithBg(context, "Property Rules", "", () {}, null),
    ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3,shrinkWrap: true,
        itemBuilder: (context,index){
          return ListTile(leading:Icon(Ionicons.checkmark_done),

            title: "Demo Rules".text.semiBold.make(),

          );
        })
  ]);
}

Widget customLocationProperty(BuildContext context){
  return VStack([
    customRowWithBg(context, "Property Location", "", () {}, null),
    10.heightBox,
    Image.asset("assets/images/map.png",width: context.screenWidth,height: 200,fit: BoxFit.cover,).box.roundedSM.clip(Clip.antiAlias).make()
  ]);
}

Widget customOwnerProperty(BuildContext context) {
  return VStack([
    HStack([
      Image
          .asset("assets/images/rent.png")
          .box
          .size(70, 70)
          .roundedFull
          .clip(Clip.antiAlias)
          .make(),
      15.widthBox,
      VStack([
        "Property Owner Name".text.semiBold.xl.make(),
        5.heightBox,
        "Property Owner Address".text.bold.make()
      ])
    ]).box
        .color(mainColor.withValues(alpha: 0.15))
        .roundedSM
        .width(context.screenWidth)
        .p8
        .clip(Clip.antiAlias)
        .make(),
    10.heightBox,

  ]);
}

Widget customAvailableProperty(BuildContext context) {
  final PropertyDetailsController controller = Get.find();
  return VStack([
    customRowWithBg(context, "Available Rooms", "", () {}, null),
    10.heightBox,
    ListView.builder(scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      padding: EdgeInsets.all(8),
      itemCount: 3,
      // Change this if you have a dynamic list
      itemBuilder: (context, index) {
        return Obx(
              () =>
              Container(
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8),
                      topLeft: Radius.circular(8)),
                  border: controller.selectedAvailableIndex.value == index
                      ? Border(
                    top: BorderSide(width: 1, color: gry),
                    right: BorderSide(width: 1, color: gry),
                    left: BorderSide(width: 1, color: gry),
                  )
                      : Border(bottom: BorderSide(width: 1, color: gry)),
                ),
                child: list2[index].text.semiBold.lg.make(),
              ).onTap(() {
                controller.selectedAvailableIndex.value = index;
                controller.selectedAvailableIndexName.value=list2[index];
              }),
        );
      },

    ).h(60),
    10.heightBox,
    Obx(
  ()=> ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Icon(Icons.bed_outlined, color: mainColor,size: 20,).box.roundedFull
            .clip(Clip.antiAlias)
            .color(gry)
            .p4
            .make(),
        title: controller.selectedAvailableIndexName.value.text.semiBold.maxLines(1).make(),
        trailing: HStack([
          "Starts from ".text.semiBold.make(),
          "TK. 970/room".text.semiBold.lg.color(secondColor).make()
        ]),
      ),
    ),
    10.heightBox,
    Divider(),
    10.heightBox,
    HStack([
      "88 Tenants staying".text.semiBold.xl.make(),
      Spacer(),
      customButton(title: "Login To Rserve", onPressed: (){}, color: secondColor,txtColor: white).h(38)
    ]),
    10.heightBox,
  ]);
}