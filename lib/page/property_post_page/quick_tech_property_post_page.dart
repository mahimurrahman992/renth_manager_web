import 'package:renth_manager/consts/consts.dart';


class QuickTechPropertyPostPage extends StatefulWidget {
  const QuickTechPropertyPostPage({super.key});

  @override
  State<QuickTechPropertyPostPage> createState() =>
      _QuickTechPropertyPostPageState();
}

class _QuickTechPropertyPostPageState extends State<QuickTechPropertyPostPage> {
  final  postPropertyController = Get.put(PostPropertyController());
  final  commonController = Get.put(CommonController());

  @override
  void initState() {
   
    super.initState();
    postPropertyController.rulesList.clear();
    postPropertyController.packageList.clear();
    postPropertyController.addPackageItem();
    postPropertyController.addRulesItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbarCommon(context, "Post Property"),
      body: Obx(
        () => ListView(
          padding: EdgeInsets.symmetric(horizontal: dynamicSize),
          children: [
            customTextField(
              hint: "Title*",
              isSuffix: false,
              isVisible: true,
              controller: postPropertyController.title,
            ),
            10.heightBox,
            customTextField(maxline: 4,
              hint: "About*",
              isSuffix: false,
              isVisible: true,
              controller: postPropertyController.about,
            ),
            10.heightBox,
            "Available Rooms*".text.semiBold.xl.make(),
            5.heightBox,

            ///
            HStack([
              Checkbox(
                value: postPropertyController.isSingle.value,
                onChanged: (v) {
                  postPropertyController.isSingle.value = v!;
                },
              ),
              5.widthBox,
              "Single Sharing".text.semiBold.sm.make(),
            ]),
            if (postPropertyController.isSingle.value)
              VStack([
                customTextField(
                  hint: "Single Sharing Price",
                  isSuffix: false,
                  isVisible: true,
                  controller: postPropertyController.singleSharingPrice,
                    keyboard: TextInputType.number
                ),
                5.heightBox,
                customTextField(
                  hint: "Number of Tenants",
                  isSuffix: false,
                  isVisible: true,
                  controller: postPropertyController.singleNumber,
                  keyboard: TextInputType.number
                ),
              ]),

            ///
            HStack([
              Checkbox(
                value: postPropertyController.isDouble.value,
                onChanged: (v) {
                  postPropertyController.isDouble.value = v!;
                },
              ),
              5.widthBox,
              "Double Sharing".text.semiBold.sm.make(),
            ]),
            if (postPropertyController.isDouble.value)
              VStack([
                customTextField(
                  hint: "Double Sharing Price",
                  isSuffix: false,
                  isVisible: true,
                  controller: postPropertyController.doubleSharingPrice,
                    keyboard: TextInputType.number
                ),
                5.heightBox,
                customTextField(
                  hint: "Number of Tenants",
                  isSuffix: false,
                  isVisible: true,
                  controller: postPropertyController.doubleNumber,
                    keyboard: TextInputType.number
                ),
              ]),

            ///
            HStack([
              Checkbox(
                value: postPropertyController.isTriple.value,
                onChanged: (v) {
                  postPropertyController.isTriple.value = v!;
                },
              ),
              5.widthBox,
              "Triple Sharing".text.semiBold.sm.make(),
            ]),
            if (postPropertyController.isTriple.value)
              VStack([
                customTextField(
                  hint: "Triple Sharing Price",
                  isSuffix: false,
                  isVisible: true,
                  controller: postPropertyController.tripleSharingPrice,
                    keyboard: TextInputType.number
                ),
                5.heightBox,
                customTextField(
                  hint: "Number of Tenants",
                  isSuffix: false,
                  isVisible: true,
                  controller: postPropertyController.tripleNumber,
                    keyboard: TextInputType.number
                ),
                10.heightBox,
              ]),

            ///
            "Property Amenities*".text.semiBold.xl.make(),
            5.heightBox,
            HStack([
              Checkbox(
                value: postPropertyController.isCommon.value,
                onChanged: (v) {
                  postPropertyController.isCommon.value = v!;
                },
              ),
              5.widthBox,
              "Common".text.semiBold.sm.make(),
            ]),
            if (postPropertyController.isCommon.value)
              customTextField(
                hint: "Common Amenities separate by coma(,)",
                isSuffix: false,
                isVisible: true,
                maxline: 3,
                controller: postPropertyController.common,
              ),

            ///
            HStack([
              Checkbox(
                value: postPropertyController.isRoom.value,
                onChanged: (v) {
                  postPropertyController.isRoom.value = v!;
                },
              ),
              5.widthBox,
              "Room".text.semiBold.sm.make(),
            ]),
            if (postPropertyController.isRoom.value)
              customTextField(
                hint: "Room Amenities separate by coma(,)",
                isSuffix: false,
                isVisible: true,
                maxline: 3,
                controller: postPropertyController.room,
              ),

            ///
            HStack([
              Checkbox(
                value: postPropertyController.isService.value,
                onChanged: (v) {
                  postPropertyController.isService.value = v!;
                },
              ),
              5.widthBox,
              "Service".text.semiBold.sm.make(),
            ]),
            if (postPropertyController.isService.value)
              customTextField(
                hint: "Service Amenities separate by coma(,)",
                isSuffix: false,
                isVisible: true,
                maxline: 3,
                controller: postPropertyController.service,
              ),
            if (postPropertyController.isService.value) 10.heightBox,

            ///
            "Rent Package*".text.semiBold.xl.make(),
            8.heightBox,

            multiplePackageFields(),

            10.heightBox,
            "Rent Terms*".text.semiBold.xl.make(),
            8.heightBox,

            multipleTermsFields(),
            10.heightBox,
            "Property Rules*".text.semiBold.xl.make(),
            8.heightBox,
            customTextField(
              hint: "Property Rules separate by coma(,)",
              isSuffix: false,
              isVisible: true,
              maxline: 5,
              controller: postPropertyController.rules,
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
                value: postPropertyController.selectedDivision.value,
                items:
                    divisions?.map((Divisions division) {
                      return DropdownMenuItem<Divisions>(
                        value: division,
                        child: Text(division.name ?? "Unknown"),
                      );
                    }).toList(),
                onChanged: (Divisions? newValue) {
                  if (newValue != null) {
                    postPropertyController.setSelectedDivision(newValue);
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
                value: postPropertyController.selectedDistrict.value,
                items:
                    divisions?.map((Districts division) {
                      return DropdownMenuItem<Districts>(
                        value: division,
                        child: Text(division.name ?? "Unknown"),
                      );
                    }).toList(),
                onChanged: (Districts? newValue) {
                  if (newValue != null) {
                    postPropertyController.setSelectedDistrict(newValue);
                    commonController.fetchThana(newValue.id);
                  }
                },
              );
            }),
            10.heightBox,
            Obx(() {
              var upazilas = commonController.thana.value.upazilas;
              var selectedThana = postPropertyController.selectedThana.value;

              // Check if the selected value exists in the current items list
              bool isSelectedValueValid = selectedThana != null &&
                  upazilas != null &&
                  upazilas.any((upazila) => upazila.id == selectedThana.id);

              return DropdownButtonFormField<Upazilas>(
                decoration: InputDecoration(
                  labelText: 'Select Upazila',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                value: isSelectedValueValid ? selectedThana : null,
                items: upazilas?.map((Upazilas thana) {
                      return DropdownMenuItem<Upazilas>(
                        value: thana,
                        child: Text(thana.name ?? "Unknown"),
                      );
                    }).toList(),
                onChanged: (Upazilas? newValue) {
                  if (newValue != null) {
                    postPropertyController.setSelectedThanan(newValue);
                  }
                },
              );
            }),
            10.heightBox,

            customTextField(
              hint: "Address",
              isSuffix: false,
              isVisible: true,
              controller: postPropertyController.address,
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
                  postPropertyController.selectedGender.value.isEmpty
                      ? null
                      : postPropertyController.selectedGender.value,
              items:
                  postPropertyController.genders.map((gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  postPropertyController.setGender(value);
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
                  postPropertyController.selectedType.value.isEmpty
                      ? null
                      : postPropertyController.selectedType.value,
              items:
                  postPropertyController.type.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  postPropertyController.setType(value);
                }
              },
            ),
            10.heightBox,
            customTextField(
              hint: "Total Price",
              keyboard: TextInputType.number,
              isSuffix: false,
              isVisible: true,
              controller: postPropertyController.totalPrice,
            ),
            // 10.heightBox,
            // customTextField(
            //   hint: "Google Map Embed Code",
            //   isSuffix: false,
            //   isVisible: true,
            //   controller: postPropertyController.googleMap,
            // ),
            10.heightBox,
            customTextField(
              hint: "Property Owner Name*",
              isSuffix: false,
              isVisible: true,
              controller: postPropertyController.ownerName,
            ),
            10.heightBox,
            customTextField(
              hint: "About Property Owner",
              isSuffix: false,
              isVisible: true,
              controller: postPropertyController.ownerAbout,maxline: 3
            ),
            10.heightBox,
            "Add Image".text.semiBold.make(),
            5.heightBox,
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    if (postPropertyController.selectedImages.isNotEmpty) {
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
                        itemCount: postPropertyController.selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Image.file(
                                    postPropertyController
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
                                      () => postPropertyController.removeImage(
                                        index,
                                      ),
                                ),
                              ),
                            ],
                          );
                        },
                      ).onTap(postPropertyController.pickMultipleImages);
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
                        onTap: postPropertyController.pickMultipleImages,
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
                postPropertyController.uploadProperty();
                
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