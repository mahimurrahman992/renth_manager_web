import 'package:renth_manager/consts/consts.dart';


class QuickTechEditPropertyPage extends StatefulWidget {
  const QuickTechEditPropertyPage({super.key});

  @override
  State<QuickTechEditPropertyPage> createState() => _QuickTechEditPropertyPageState();
}

class _QuickTechEditPropertyPageState extends State<QuickTechEditPropertyPage> {
  final EditPropertyController editPropertyController=Get.find();
  final CommonController commonController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbarCommon(context, "Edit Property"),
      body: Obx(
            () => ListView(
          padding: EdgeInsets.symmetric(horizontal: dynamicSize),
          children: [
            customTextField(
              hint: "Title*",
              isSuffix: false,
              isVisible: true,
              controller: editPropertyController.title,
            ),
            10.heightBox,
            customTextField(
              hint: "About*",
              isSuffix: false,
              isVisible: true,
              controller: editPropertyController.about,
            ),
            10.heightBox,
            "Available Rooms*".text.semiBold.xl.make(),
            5.heightBox,

            ///
            HStack([
              Checkbox(
                value: editPropertyController.isSingle.value,
                onChanged: (v) {
                  editPropertyController.isSingle.value = v!;
                },
              ),
              5.widthBox,
              "Single Sharing".text.semiBold.sm.make(),
            ]),
            if (editPropertyController.isSingle.value)
              VStack([
                customTextField(
                    hint: "Single Sharing Price",
                    isSuffix: false,
                    isVisible: true,
                    controller: editPropertyController.singleSharingPrice,
                    keyboard: TextInputType.number
                ),
                5.heightBox,
                customTextField(
                    hint: "Number of Tenants",
                    isSuffix: false,
                    isVisible: true,
                    controller: editPropertyController.singleNumber,
                    keyboard: TextInputType.number
                ),
              ]),

            ///
            HStack([
              Checkbox(
                value: editPropertyController.isDouble.value,
                onChanged: (v) {
                  editPropertyController.isDouble.value = v!;
                },
              ),
              5.widthBox,
              "Double Sharing".text.semiBold.sm.make(),
            ]),
            if (editPropertyController.isDouble.value)
              VStack([
                customTextField(
                    hint: "Double Sharing Price",
                    isSuffix: false,
                    isVisible: true,
                    controller: editPropertyController.doubleSharingPrice,
                    keyboard: TextInputType.number
                ),
                5.heightBox,
                customTextField(
                    hint: "Number of Tenants",
                    isSuffix: false,
                    isVisible: true,
                    controller: editPropertyController.doubleNumber,
                    keyboard: TextInputType.number
                ),
              ]),

            ///
            HStack([
              Checkbox(
                value: editPropertyController.isTriple.value,
                onChanged: (v) {
                  editPropertyController.isTriple.value = v!;
                },
              ),
              5.widthBox,
              "Triple Sharing".text.semiBold.sm.make(),
            ]),
            if (editPropertyController.isTriple.value)
              VStack([
                customTextField(
                    hint: "Triple Sharing Price",
                    isSuffix: false,
                    isVisible: true,
                    controller: editPropertyController.tripleSharingPrice,
                    keyboard: TextInputType.number
                ),
                5.heightBox,
                customTextField(
                    hint: "Number of Tenants",
                    isSuffix: false,
                    isVisible: true,
                    controller: editPropertyController.tripleNumber,
                    keyboard: TextInputType.number
                ),
                10.heightBox,
              ]),

            ///
            "Property Amenities*".text.semiBold.xl.make(),
            5.heightBox,
            HStack([
              Checkbox(
                value: editPropertyController.isCommon.value,
                onChanged: (v) {
                  editPropertyController.isCommon.value = v!;
                },
              ),
              5.widthBox,
              "Common".text.semiBold.sm.make(),
            ]),
            if (editPropertyController.isCommon.value)
              customTextField(
                hint: "Common Amenities separate by coma(,)",
                isSuffix: false,
                isVisible: true,
                maxline: 3,
                controller: editPropertyController.common,
              ),

            ///
            HStack([
              Checkbox(
                value: editPropertyController.isRoom.value,
                onChanged: (v) {
                  editPropertyController.isRoom.value = v!;
                },
              ),
              5.widthBox,
              "Room".text.semiBold.sm.make(),
            ]),
            if (editPropertyController.isRoom.value)
              customTextField(
                hint: "Room Amenities separate by coma(,)",
                isSuffix: false,
                isVisible: true,
                maxline: 3,
                controller: editPropertyController.room,
              ),

            ///
            HStack([
              Checkbox(
                value: editPropertyController.isService.value,
                onChanged: (v) {
                  editPropertyController.isService.value = v!;
                },
              ),
              5.widthBox,
              "Service".text.semiBold.sm.make(),
            ]),
            if (editPropertyController.isService.value)
              customTextField(
                hint: "Service Amenities separate by coma(,)",
                isSuffix: false,
                isVisible: true,
                maxline: 3,
                controller: editPropertyController.service,
              ),
            if (editPropertyController.isService.value) 10.heightBox,

            ///
            "Rent Package*".text.semiBold.xl.make(),
            8.heightBox,

            multiplePackageFieldsEdit(),

            10.heightBox,
            "Rent Terms*".text.semiBold.xl.make(),
            8.heightBox,

            multipleTermsFieldsEdit(),
            10.heightBox,
            "Property Rules*".text.semiBold.xl.make(),
            8.heightBox,
            customTextField(
              hint: "Property Rules separate by coma(,)",
              isSuffix: false,
              isVisible: true,
              maxline: 3,
              controller: editPropertyController.rules,
            ),
            10.heightBox,
            Obx(() {
              var divisions = commonController.division.value.divisions;

              return DropdownButtonFormField<Divisions>(
                decoration: InputDecoration(
                  labelText: 'Select Division',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                value: editPropertyController.selectedDivision.value,
                items:
                divisions?.map((Divisions division) {
                  return DropdownMenuItem<Divisions>(
                    value: division,
                    child: Text(division.name ?? "Unknown"),
                  );
                }).toList(),
                onChanged: (Divisions? newValue) {
                  if (newValue != null) {
                    editPropertyController.setSelectedDivision(newValue);
                    commonController.fetchDistricts(newValue.id);
                  }
                },
              );
            }),
            10.heightBox,
            Obx(() {
              var divisions = commonController.district.value.districts;

              return DropdownButtonFormField<Districts>(
                decoration: InputDecoration(
                  labelText: 'Select District',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                value: editPropertyController.selectedDistrict.value,
                items:
                divisions?.map((Districts division) {
                  return DropdownMenuItem<Districts>(
                    value: division,
                    child: Text(division.name ?? "Unknown"),
                  );
                }).toList(),
                onChanged: (Districts? newValue) {
                  if (newValue != null) {
                    editPropertyController.setSelectedDistrict(newValue);
                    commonController.fetchThana(newValue.id);
                  }
                },
              );
            }),
            10.heightBox,
            Obx(() {
              var divisions = commonController.thana.value.upazilas;

              return DropdownButtonFormField<Upazilas>(
                decoration: InputDecoration(
                  labelText: 'Select Upzela',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                value: editPropertyController.selectedThana.value,
                items:
                divisions?.map((Upazilas thana) {
                  return DropdownMenuItem<Upazilas>(
                    value: thana,
                    child: Text(thana.name ?? "Unknown"),
                  );
                }).toList(),
                onChanged: (Upazilas? newValue) {
                  if (newValue != null) {
                    editPropertyController.setSelectedThanan(newValue);
                  }
                },
              );
            }),
            10.heightBox,

            customTextField(
              hint: "Address",
              isSuffix: false,
              isVisible: true,
              controller: editPropertyController.address,
            ),
            10.heightBox,
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Residents Gender*',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              value:
              editPropertyController.selectedGender.value.isEmpty
                  ? null
                  : editPropertyController.selectedGender.value,
              items:
              editPropertyController.genders.map((gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  editPropertyController.setGender(value);
                }
              },
            ),
            10.heightBox,
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Residents Type*',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              value:
              editPropertyController.selectedType.value.isEmpty
                  ? null
                  : editPropertyController.selectedType.value,
              items:
              editPropertyController.type.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  editPropertyController.setType(value);
                }
              },
            ),
            10.heightBox,
            customTextField(
              hint: "Total Price",
              keyboard: TextInputType.number,
              isSuffix: false,
              isVisible: true,
              controller: editPropertyController.totalPrice,
            ),
            10.heightBox,
            customTextField(
              hint: "Google Map Embed Code",
              isSuffix: false,
              isVisible: true,
              controller: editPropertyController.googleMap,
            ),
            10.heightBox,
            customTextField(
              hint: "Property Owner Name*",
              isSuffix: false,
              isVisible: true,
              controller: editPropertyController.ownerName,
            ),
            10.heightBox,
            customTextField(
              hint: "About Property Owner",
              isSuffix: false,
              isVisible: true,
              controller: editPropertyController.ownerAbout,
            ),
            10.heightBox,
            "Add Image".text.semiBold.make(),
            5.heightBox,
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    if (editPropertyController.selectedImages.isNotEmpty) {
                      // Show selected images from device
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: editPropertyController.selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Image.file(
                                editPropertyController
                                    .selectedImages[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ).box.alignCenter
                                  .border(color: Colors.black, width: 1.5)
                                  .rounded
                                  .clip(Clip.antiAlias)
                                  .make(),
                              Positioned(
                                top: -5,
                                right: -5,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                  onPressed:
                                      () => editPropertyController.removeImage(
                                    index,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ).onTap(editPropertyController.pickMultipleImages);
                    }
                    // else if (controller.multipleImageGet.isNotEmpty) {
                    //   // Show images from API
                    //   return GridView.builder(
                    //     shrinkWrap: true,
                    //     physics: NeverScrollableScrollPhysics(),
                    //     padding: EdgeInsets.all(8.0),
                    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 3,
                    //       crossAxisSpacing: 8.0,
                    //       mainAxisSpacing: 8.0,
                    //     ),
                    //     itemCount: controller.multipleImageGet.length,
                    //     itemBuilder: (context, index) {
                    //       return Image.network(
                    //         "${HostApi.imageUrl}${controller.multipleImageGet[index].multiImage}",
                    //         fit: BoxFit.cover,
                    //         width: double.infinity,
                    //         height: double.infinity,
                    //       )
                    //           .box
                    //           .alignCenter
                    //           .border(color: Colors.black, width: 1.5)
                    //           .rounded
                    //           .clip(Clip.antiAlias)
                    //           .make();
                    //     },
                    //   ).onTap(controller.pickMultipleImages);
                    // }
                    else {
                      // Show "No images selected"
                      return GestureDetector(
                        onTap: editPropertyController.pickMultipleImages,
                        child:
                        Text('No images selected').box
                            .size(context.screenWidth, 50)
                            .alignCenter
                            .border(color: Colors.black, width: 1.5)
                            .rounded
                            .makeCentered(),
                      );
                    }
                  }),
                ),
              ],
            ),
            20.heightBox,
            customButton(
              title: "Post",
              onPressed: () {
                // editPropertyController.uploadProperty();
              },
              color: secondColor,
              txtColor: white,
            ).w(context.screenWidth),
            10.heightBox,
          ],
        ),
      ),
    );
  }
}
