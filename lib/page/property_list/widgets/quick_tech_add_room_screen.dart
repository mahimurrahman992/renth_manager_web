import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:renth_manager/controller/quick_tech_property_room_store_controller.dart';
import 'package:renth_manager/model/response/quickech_get_room_data.dart';
import 'package:renth_manager/widgets/quick_tech_custom_dropdown.dart';
import 'package:renth_manager/widgets/web_image.dart';
import '../../../consts/consts.dart';

class QuickTechAddRoomScreen extends StatefulWidget {
  const QuickTechAddRoomScreen({super.key});

  @override
  State<QuickTechAddRoomScreen> createState() => _QuickTechAddRoomScreenState();
}

class _QuickTechAddRoomScreenState extends State<QuickTechAddRoomScreen> {
  final dashboardController = locator.get<DashboardController>();
  final commonController = locator.get<CommonController>();
  final roomController = locator.get<QuickTechPropertyRoomController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((v) {
      roomController.selectedRoomType.value = null;
      roomController.selectedProperty.value = null;
      roomController.selectedBedType.value = null;

      commonController.fetchRoomCreateData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;

              if (width < 600) {
                return AddRoomMobileView(
                  roomController: roomController,
                  commonController: commonController,
                );
              } else if (width < 1024) {
                return AddRoomTabletView(
                  roomController: roomController,
                  commonController: commonController,
                );
              } else {
                return AddRoomDesktopView(
                  roomController: roomController,
                  commonController: commonController,
                );
              }
            },
          ),
          AddRoomLoadingOverlay(roomController: roomController),
        ],
      ),
    );
  }
}

class RoomLabels {
  final String category;

  const RoomLabels(this.category);

  bool get isHotel => category == 'Hotel';
  bool get isFlat => category == 'Flat Sale/Buy';
  bool get isHome => category == 'Family Home';
  bool get isRider => category == 'Rider';
  bool get isMonthly =>
      isHome || isRider || category == 'Bachelor' || category == 'Hostel';
  bool get showBed => !isFlat && !isRider;

  String get name {
    if (isFlat) return 'Flat Name';
    if (isHome) return 'Home Name';
    if (isRider) return 'Rider Name';
    return 'Room Name';
  }

  String get type {
    if (isFlat || isHome) return 'Type of Flat';
    if (isRider) return 'Type of Rider';
    return 'Type of Room';
  }

  String get price {
    if (isFlat) return 'Sale Price';
    if (isMonthly) return 'Monthly Rent';
    return 'Room Price(Per Night)';
  }

  String get discount {
    if (isFlat) return 'Discount Sale Price';
    if (isMonthly) return 'Discount Monthly Rent';
    return 'Room Discount Price(Per Night)';
  }

  String get size {
    if (isFlat) return 'Flat Size';
    if (isHome) return 'Home Size';
    return 'Room Size';
  }

  String get count {
    if (isFlat) return 'Total Flats';
    if (isHome) return 'Total Homes';
    return 'Total Rooms';
  }

  String get images {
    if (isFlat) return 'Flat Images';
    if (isHome) return 'Home Images';
    if (isRider) return 'Rider Images';
    return 'Room Images';
  }

  String get video {
    if (isFlat) return 'Flat Video (Optional)';
    if (isHome) return 'Home Video (Optional)';
    if (isRider) return 'Rider Video (Optional)';
    return 'Room Video (Optional)';
  }
}

RoomLabels _labelsOf(QuickTechPropertyRoomController controller) {
  return RoomLabels(
    controller.selectedProperty.value?.propertyCategory?.name ?? 'Hotel',
  );
}

class AddRoomMobileView extends StatelessWidget {
  final QuickTechPropertyRoomController roomController;
  final CommonController commonController;

  const AddRoomMobileView({
    super.key,
    required this.roomController,
    required this.commonController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [mainColor, mainColor.withValues(alpha: 0.75)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 24.w, 20.h),
              child: Row(
                children: [
                  const AddRoomBackButton(light: true),
                  14.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Room',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          'Fill in the details below',
                          style: TextStyle(fontSize: 13.sp, color: textColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32.r),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32.r),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
                    child: Column(
                      children: [
                        AddRoomDetailsColumn(
                          roomController: roomController,
                          commonController: commonController,
                          wide: false,
                        ),
                        16.verticalSpace,
                        AddRoomExtrasColumn(
                          roomController: roomController,
                          commonController: commonController,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddRoomTabletView extends StatelessWidget {
  final QuickTechPropertyRoomController roomController;
  final CommonController commonController;

  const AddRoomTabletView({
    super.key,
    required this.roomController,
    required this.commonController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const AddRoomTopBar(horizontalPadding: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    children: [
                      AddRoomDetailsColumn(
                        roomController: roomController,
                        commonController: commonController,
                        wide: true,
                      ),
                      16.verticalSpace,
                      AddRoomExtrasColumn(
                        roomController: roomController,
                        commonController: commonController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddRoomDesktopView extends StatelessWidget {
  final QuickTechPropertyRoomController roomController;
  final CommonController commonController;

  const AddRoomDesktopView({
    super.key,
    required this.roomController,
    required this.commonController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const AddRoomTopBar(horizontalPadding: 40),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 28.h),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AddRoomDetailsColumn(
                          roomController: roomController,
                          commonController: commonController,
                          wide: true,
                        ),
                      ),
                      24.horizontalSpace,
                      Expanded(
                        child: AddRoomExtrasColumn(
                          roomController: roomController,
                          commonController: commonController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddRoomDetailsColumn extends StatelessWidget {
  final QuickTechPropertyRoomController roomController;
  final CommonController commonController;
  final bool wide;

  const AddRoomDetailsColumn({
    super.key,
    required this.roomController,
    required this.commonController,
    required this.wide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddRoomSectionCard(
          title: 'Basic Information',
          icon: Icons.apartment_rounded,
          child: AddRoomBasicFields(
            roomController: roomController,
            commonController: commonController,
            wide: wide,
          ),
        ),
        16.verticalSpace,
        AddRoomSectionCard(
          title: 'Pricing & Charges',
          icon: Icons.payments_outlined,
          child: AddRoomPricingFields(
            roomController: roomController,
            wide: wide,
          ),
        ),
        16.verticalSpace,
        AddRoomSectionCard(
          title: 'Capacity & Size',
          icon: Icons.people_outline_rounded,
          child: AddRoomCapacityFields(
            roomController: roomController,
            wide: wide,
          ),
        ),
      ],
    );
  }
}

class AddRoomExtrasColumn extends StatelessWidget {
  final QuickTechPropertyRoomController roomController;
  final CommonController commonController;

  const AddRoomExtrasColumn({
    super.key,
    required this.roomController,
    required this.commonController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final isHotel = (roomController
                      .selectedProperty.value?.propertyCategory?.name
                      ?.trim()
                      .toLowerCase() ??
                  '') ==
              'hotel';

          if (!isHotel) return const SizedBox.shrink();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AddRoomSectionCard(
                title: 'Amenities',
                icon: Icons.checklist_rounded,
                child: QuickTechRoomAmenitiesWidget(),
              ),
              16.verticalSpace,
            ],
          );
        }),
        AddRoomSectionCard(
          title: 'Description',
          icon: Icons.notes_rounded,
          child: customTextField(
            hint: 'Room Description',
            isSuffix: true,
            maxline: 5,
            isVisible: true,
            controller: roomController.roomDescriptionController,
            supColor: Colors.black,
          ),
        ),
        16.verticalSpace,
        AddRoomImagesCard(roomController: roomController),
        16.verticalSpace,
        AddRoomVideoCard(roomController: roomController),
        24.verticalSpace,
        AddRoomSaveButton(roomController: roomController),
      ],
    );
  }
}

class AddRoomBasicFields extends StatelessWidget {
  final QuickTechPropertyRoomController roomController;
  final CommonController commonController;
  final bool wide;

  const AddRoomBasicFields({
    super.key,
    required this.roomController,
    required this.commonController,
    required this.wide,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final labels = _labelsOf(roomController);

      return AddRoomFieldGrid(
        wide: wide,
        children: [
          customDropdownField(
            hint: 'Select Property',
            items:
                commonController.properties.map((item) {
                  return DropdownMenuItem<Properties>(
                    value: item,
                    child: Text(item.title ?? ''),
                  );
                }).toList(),
            value: roomController.selectedProperty.value,
            onChanged: (value) {
              roomController.selectedProperty.value = value;
              final isHotel =
                  (value?.propertyCategory?.name?.trim().toLowerCase() ?? '') ==
                      'hotel';
              if (!isHotel) {
                roomController.selectedFacilities.clear();
              }
            },
          ),
          customTextField(
            hint: labels.name,
            isSuffix: false,
            isVisible: true,
            controller: roomController.roomNameController,
          ),
          customDropdownField(
            hint: labels.type,
            items:
                commonController.roomTypes.map((item) {
                  return DropdownMenuItem<Type>(
                    value: item,
                    child: Text(item.name ?? ''),
                  );
                }).toList(),
            value: roomController.selectedRoomType.value,
            onChanged: (value) {
              roomController.selectedRoomType.value = value;
            },
          ),
          if (labels.showBed)
            customDropdownField(
              hint: 'Type of Beds',
              items:
                  commonController.bedTypes.map((item) {
                    return DropdownMenuItem<Type>(
                      value: item,
                      child: Text(item.name ?? ''),
                    );
                  }).toList(),
              value: roomController.selectedBedType.value,
              onChanged: (value) {
                roomController.selectedBedType.value = value;
              },
            ),
        ],
      );
    });
  }
}

class AddRoomPricingFields extends StatelessWidget {
  final QuickTechPropertyRoomController roomController;
  final bool wide;

  const AddRoomPricingFields({
    super.key,
    required this.roomController,
    required this.wide,
  });

  Widget _number(String hint, TextEditingController controller) {
    return customTextField(
      hint: hint,
      isSuffix: true,
      isVisible: true,
      controller: controller,
      keyboard: TextInputType.number,
      supColor: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final labels = _labelsOf(roomController);

      return AddRoomFieldGrid(
        wide: wide,
        children: [
          _number(labels.price, roomController.roomPriceController),
          // _number(labels.discount, roomController.roomDiscountPriceController),
          //  if (labels.isHotel) ...[
          //    _number(
          //      'Extra Price Per Mattress',
          //      roomController.extraPriceMattressController,
          //    ),
          //    _number(
          //      'Extra Price Per Adult',
          //      roomController.extraPriceAdultController,
          //    ),
          //    _number(
          //      'Extra Price Per Child Bed',
          //      roomController.extraPriceChildController,
          //    ),
          //  ],
          _number('VAT Percentage', roomController.vatPercentageController),
          _number('Service Charge', roomController.serviceChargeController),
        ],
      );
    });
  }
}

class AddRoomCapacityFields extends StatelessWidget {
  final QuickTechPropertyRoomController roomController;
  final bool wide;

  const AddRoomCapacityFields({
    super.key,
    required this.roomController,
    required this.wide,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final labels = _labelsOf(roomController);

      return AddRoomFieldGrid(
        wide: wide,
        children: [
          if (!labels.isRider)
            customTextField(
              hint: 'Capacity of Adults',
              isSuffix: true,
              isVisible: true,
              controller: roomController.adultCapacityController,
              keyboard: TextInputType.number,
              supColor: Colors.black,
            ),
          if (labels.isHotel)
            customTextField(
              hint: 'Capacity of Children',
              isSuffix: true,
              isVisible: true,
              controller: roomController.childCapacityController,
              keyboard: TextInputType.number,
              supColor: Colors.black,
            ),
          customTextField(
            hint: labels.size,
            isSuffix: true,
            isVisible: true,
            controller: roomController.roomSizeController,
            supColor: Colors.black,
          ),
          customTextField(
            hint: labels.count,
            isSuffix: true,
            keyboard: TextInputType.number,
            isVisible: true,
            controller: roomController.numberOfRoomController,
            supColor: Colors.black,
          ),
        ],
      );
    });
  }
}

class AddRoomImagesCard extends StatelessWidget {
  final QuickTechPropertyRoomController roomController;

  const AddRoomImagesCard({super.key, required this.roomController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final labels = _labelsOf(roomController);
      final images = roomController.selectedImages;

      return AddRoomSectionCard(
        title: labels.images,
        icon: Icons.photo_library_outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddRoomUploadButton(
              icon: Icons.cloud_upload_outlined,
              label: 'Choose Images',
              onTap: () => roomController.pickRoomImages(),
            ),
            if (images.isNotEmpty) ...[
              16.verticalSpace,
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(images.length, (index) {
                  return AddRoomImageThumb(
                    path: images[index],
                    onRemove: () => roomController.removeImage(index),
                  );
                }),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class AddRoomVideoCard extends StatelessWidget {
  final QuickTechPropertyRoomController roomController;

  const AddRoomVideoCard({super.key, required this.roomController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final labels = _labelsOf(roomController);
      final String? video = roomController.selectedVideo.value;

      return AddRoomSectionCard(
        title: labels.video,
        icon: Icons.videocam_outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddRoomUploadButton(
              icon: Icons.video_library_outlined,
              label: 'Choose Video',
              onTap: () => roomController.pickRoomVideo(),
            ),
            if (video != null && video.isNotEmpty) ...[
              16.verticalSpace,
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.video_file_rounded, color: mainColor),
                    10.horizontalSpace,
                    Expanded(
                      child: Text(
                        video.split('/').last,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => roomController.removeVideo(),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class AddRoomSaveButton extends StatelessWidget {
  final QuickTechPropertyRoomController roomController;

  const AddRoomSaveButton({super.key, required this.roomController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return customButton2(
        title: 'Save & Continue',
        icon: Icons.save_rounded,
        isLoading: roomController.isLoading.value,
        onTap: () {
          if (roomController.isLoading.value) return;
          roomController.submitRoom();
        },
      );
    });
  }
}

class AddRoomLoadingOverlay extends StatelessWidget {
  final QuickTechPropertyRoomController roomController;

  const AddRoomLoadingOverlay({super.key, required this.roomController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!roomController.isLoading.value) return const SizedBox.shrink();

      return SizedBox.expand(
        child: ColoredBox(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: mainColor),
                  16.verticalSpace,
                  Text(
                    'Submitting...',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class AddRoomTopBar extends StatelessWidget {
  final double horizontalPadding;

  const AddRoomTopBar({super.key, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          const AddRoomBackButton(light: false),
          16.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Room',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
              2.verticalSpace,
              Text(
                'Fill in the details below to list a new room',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddRoomBackButton extends StatelessWidget {
  final bool light;

  const AddRoomBackButton({super.key, required this.light});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                light
                    ? Colors.white.withValues(alpha: 0.18)
                    : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: light ? textColor : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

class AddRoomSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const AddRoomSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: mainColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: mainColor, size: 20),
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          20.verticalSpace,
          child,
        ],
      ),
    );
  }
}

class AddRoomFieldGrid extends StatelessWidget {
  final bool wide;
  final List<Widget> children;

  const AddRoomFieldGrid({
    super.key,
    required this.wide,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (!wide) {
      return Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) 14.verticalSpace,
          ],
        ],
      );
    }

    final List<Widget> rows = [];
    for (int i = 0; i < children.length; i += 2) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: children[i]),
            16.horizontalSpace,
            Expanded(
              child:
                  i + 1 < children.length
                      ? children[i + 1]
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      if (i + 2 < children.length) rows.add(14.verticalSpace);
    }

    return Column(children: rows);
  }
}

class AddRoomUploadButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const AddRoomUploadButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: mainColor.withValues(alpha: 0.06),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: mainColor.withValues(alpha: 0.6), width: 1.4),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 30, color: mainColor),
                  8.verticalSpace,
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    'Tap to browse',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddRoomImageThumb extends StatelessWidget {
  final String path;
  final VoidCallback onRemove;

  const AddRoomImageThumb({
    super.key,
    required this.path,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child:
              kIsWeb
                  ? WebSafeNetworkImage(
                    imageUrl: path,
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                  )
                  // Image.network(path, width: 88, height: 88, fit: BoxFit.cover)
                  : Image.file(
                    File(path),
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                  ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
