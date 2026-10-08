import 'package:renth_manager/consts/consts.dart';

Widget multiplePackageFields() {
  var controller = Get.find<PostPropertyController>();
  return Obx(() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.packageList.length,
      itemBuilder: (context, index) {
        final item = controller.packageList[index];

        return HStack([
          Flexible(
            child: customTextField(
              controller: item['name'],
              hint: "Name",
              isSuffix: false,
              isVisible: true,
            ),
          ),
          5.widthBox,
          Flexible(
            child: customTextField(
              controller: item['price'],
              hint: "Price",
              isSuffix: false,keyboard: TextInputType.number,
              isVisible: true,
            ),
          ),
          5.widthBox,
          Icon(Icons.add).box
              .size(40, 44)
              .color(secondColor)
              .roundedSM
              .make()
              .onTap(controller.addPackageItem),
        ]).pOnly(bottom: 8); // optional padding
      },
    );
  });
}
Widget multiplePackageFieldsEdit() {
  var controller = Get.find<EditPropertyController>();
  return Obx(() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.packageList.length,
      itemBuilder: (context, index) {
        final item = controller.packageList[index];

        return HStack([
          Flexible(
            child: customTextField(
              controller: item['name'],
              hint: "Name",
              isSuffix: false,
              isVisible: true,
            ),
          ),
          5.widthBox,
          Flexible(
            child: customTextField(
              controller: item['price'],
              hint: "Price",
              isSuffix: false,keyboard: TextInputType.number,
              isVisible: true,
            ),
          ),
          5.widthBox,
          Icon(Icons.add).box
              .size(40, 44)
              .color(Colors.blue)
              .roundedSM
              .make()
              // .onTap(controller.addPackageItem),
        ]).pOnly(bottom: 8); // optional padding
      },
    );
  });
}

Widget multipleTermsFields() {
  var controller = Get.find<PostPropertyController>();

  return Obx(() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.rulesList.length,
      itemBuilder: (context, index) {
        final item = controller.rulesList[index];

        return HStack([
          Flexible(
            child: customTextField(
              controller: item['name'],
              hint: "Terms Name",
              isSuffix: false,
              isVisible: true,
            ),
          ),
          5.widthBox,
          Flexible(
            child: customTextField(
              controller: item['desc'],
              hint: "Descriptions",
              isSuffix: false,
              isVisible: true,
            ),
          ),
          5.widthBox,
          Icon(Icons.add).box
              .size(40, 44)
              .color(secondColor)
              .roundedSM
              .make()
              .onTap(controller.addRulesItem),
        ]).pOnly(bottom: 8); // optional padding
      },
    );
  });
}

Widget multipleTermsFieldsEdit() {
  var controller = Get.find<EditPropertyController>();

  return Obx(() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.rulesList.length,
      itemBuilder: (context, index) {
        final item = controller.rulesList[index];

        return HStack([
          Flexible(
            child: customTextField(
              controller: item['name'],
              hint: "Terms Name",
              isSuffix: false,
              isVisible: true,
            ),
          ),
          5.widthBox,
          Flexible(
            child: customTextField(
              controller: item['desc'],
              hint: "Descriptions",
              isSuffix: false,
              isVisible: true,
            ),
          ),
          5.widthBox,
          Icon(Icons.add).box
              .size(40, 44)
              .color(Colors.blue)
              .roundedSM
              .make()
              // .onTap(controller.addRulesItem),
        ]).pOnly(bottom: 8); // optional padding
      },
    );
  });
}
