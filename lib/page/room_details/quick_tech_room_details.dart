import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:renth_manager/controller/quick_tech_room_details_controller.dart';
import 'package:renth_manager/model/response/quickech_get_room_data.dart';
import 'package:renth_manager/widgets/quick_tech_custom_dropdown.dart';
import 'package:renth_manager/widgets/web_image.dart';

import '../../consts/consts.dart';

class RoomDetailsPage extends StatefulWidget {
  final int roomId;

  const RoomDetailsPage({super.key, required this.roomId});

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  final controller = Get.put(RoomDetailsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.roomDetails.value.propertyRoom == null) {
        controller.fetchRoomDetails(widget.roomId);
      }
    });
  }

  void _pickImages() {
    showRoomSourcePicker(
      title: 'Select Image Source',
      onSourceSelected: (source) => controller.pickImages(source),
    );
  }

  void _pickVideo() {
    showRoomSourcePicker(
      title: 'Select Video Source',
      onSourceSelected: (source) => controller.pickVideo(source),
    );
  }

  void _retry() {
    controller.fetchRoomDetails(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (width < 600) {
            return RoomDetailsMobileView(
              controller: controller,
              roomId: widget.roomId,
              onPickImages: _pickImages,
              onPickVideo: _pickVideo,
              onRetry: _retry,
            );
          } else if (width < 1024) {
            return RoomDetailsTabletView(
              controller: controller,
              roomId: widget.roomId,
              onPickImages: _pickImages,
              onPickVideo: _pickVideo,
              onRetry: _retry,
            );
          } else {
            return RoomDetailsDesktopView(
              controller: controller,
              roomId: widget.roomId,
              onPickImages: _pickImages,
              onPickVideo: _pickVideo,
              onRetry: _retry,
            );
          }
        },
      ),
    );
  }
}

void showRoomSourcePicker({
  required String title,
  required void Function(ImageSource source) onSourceSelected,
}) {
  if (kIsWeb) {
    onSourceSelected(ImageSource.gallery);
    return;
  }

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: RoomDetailsSourceOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: () {
                      Get.back();
                      onSourceSelected(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: RoomDetailsSourceOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () {
                      Get.back();
                      onSourceSelected(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

class RoomDetailsLabels {
  final String category;

  const RoomDetailsLabels(this.category);

  bool get isHotel => category == 'Hotel';
  bool get isFlat => category == 'Flat Sale/Buy';
  bool get isHome => category == 'Family Home';
  bool get isRider => category == 'Rider';
  bool get isBachelor => category == 'Bachelor';
  bool get showBed => !isFlat && !isRider;
  bool get showAdults => !isRider;
  bool get showChildren => !isBachelor && !isRider && !isFlat;

  String get name {
    if (isFlat) return 'Flat Name';
    if (isHome) return 'Home Name';
    if (isRider) return 'Rider Name';
    return 'Room Name';
  }

  String get type {
    if (isFlat || isHome) return 'Flat Type';
    if (isRider) return 'Rider Type';
    return 'Room Type';
  }

  String get price {
    if (isFlat) return 'Sale Price';
    if (isHotel) return 'Price Per Night';
    return 'Monthly Rent';
  }

  String get discount {
    if (isFlat) return 'Discount Sale Price';
    if (isHotel) return 'Discount Price Per Night';
    return 'Discount Monthly Rent';
  }

  String get size {
    if (isFlat) return 'Flat Size';
    if (isHome) return 'Home Size';
    return 'Room Size (sq ft)';
  }

  String get count {
    if (isFlat) return 'Total Flats';
    if (isHome) return 'Total Homes';
    return 'Total Rooms';
  }

  String get description {
    if (isFlat) return 'Flat Description';
    if (isHome) return 'Home Description';
    if (isRider) return 'Rider Description';
    return 'Description';
  }

  String get media {
    if (isFlat) return 'Flat Media Attachments';
    if (isHome) return 'Home Media Attachments';
    if (isRider) return 'Rider Media Attachments';
    return 'Media Attachments';
  }
}

RoomDetailsLabels _labelsOf(RoomDetailsController controller) {
  return RoomDetailsLabels(
    controller.selectedProperty.value?.propertyCategory?.name ?? 'Hotel',
  );
}

class RoomDetailsMobileView extends StatelessWidget {
  final RoomDetailsController controller;
  final int roomId;
  final VoidCallback onPickImages;
  final VoidCallback onPickVideo;
  final VoidCallback onRetry;

  const RoomDetailsMobileView({
    super.key,
    required this.controller,
    required this.roomId,
    required this.onPickImages,
    required this.onPickVideo,
    required this.onRetry,
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
                  const RoomDetailsBackButton(light: true),
                  14.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Room Details',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          'Edit pricing, facilities and media',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: textColor,
                          ),
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
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32.r)),
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32.r)),
                  child: RoomDetailsGate(
                    controller: controller,
                    padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
                    maxWidth: 600,
                    onRetry: onRetry,
                    content: RoomDetailsForm(
                      controller: controller,
                      wide: false,
                      twoColumns: false,
                      onPickImages: onPickImages,
                      onPickVideo: onPickVideo,
                    ),
                    footer: RoomDetailsFooter(
                      controller: controller,
                      roomId: roomId,
                      maxWidth: 600,
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

class RoomDetailsTabletView extends StatelessWidget {
  final RoomDetailsController controller;
  final int roomId;
  final VoidCallback onPickImages;
  final VoidCallback onPickVideo;
  final VoidCallback onRetry;

  const RoomDetailsTabletView({
    super.key,
    required this.controller,
    required this.roomId,
    required this.onPickImages,
    required this.onPickVideo,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const RoomDetailsTopBar(horizontalPadding: 24),
          Expanded(
            child: RoomDetailsGate(
              controller: controller,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              maxWidth: 760,
              onRetry: onRetry,
              content: RoomDetailsForm(
                controller: controller,
                wide: true,
                twoColumns: false,
                onPickImages: onPickImages,
                onPickVideo: onPickVideo,
              ),
              footer: RoomDetailsFooter(
                controller: controller,
                roomId: roomId,
                maxWidth: 760,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoomDetailsDesktopView extends StatelessWidget {
  final RoomDetailsController controller;
  final int roomId;
  final VoidCallback onPickImages;
  final VoidCallback onPickVideo;
  final VoidCallback onRetry;

  const RoomDetailsDesktopView({
    super.key,
    required this.controller,
    required this.roomId,
    required this.onPickImages,
    required this.onPickVideo,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const RoomDetailsTopBar(horizontalPadding: 40),
          Expanded(
            child: RoomDetailsGate(
              controller: controller,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 28.h),
              maxWidth: 1240,
              onRetry: onRetry,
              content: RoomDetailsForm(
                controller: controller,
                wide: true,
                twoColumns: true,
                onPickImages: onPickImages,
                onPickVideo: onPickVideo,
              ),
              footer: RoomDetailsFooter(
                controller: controller,
                roomId: roomId,
                maxWidth: 1240,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoomDetailsGate extends StatelessWidget {
  final RoomDetailsController controller;
  final EdgeInsets padding;
  final double maxWidth;
  final Widget content;
  final Widget footer;
  final VoidCallback onRetry;

  const RoomDetailsGate({
    super.key,
    required this.controller,
    required this.padding,
    required this.maxWidth,
    required this.content,
    required this.footer,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: mainColor));
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return RoomDetailsErrorState(
          message: controller.errorMessage.value,
          onRetry: onRetry,
        );
      }

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: padding,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: content,
                ),
              ),
            ),
          ),
          footer,
        ],
      );
    });
  }
}

class RoomDetailsForm extends StatelessWidget {
  final RoomDetailsController controller;
  final bool wide;
  final bool twoColumns;
  final VoidCallback onPickImages;
  final VoidCallback onPickVideo;

  const RoomDetailsForm({
    super.key,
    required this.controller,
    required this.wide,
    required this.twoColumns,
    required this.onPickImages,
    required this.onPickVideo,
  });

  @override
  Widget build(BuildContext context) {
    final left = RoomDetailsMainColumn(controller: controller, wide: wide);
    final right = RoomDetailsExtraColumn(
      controller: controller,
      onPickImages: onPickImages,
      onPickVideo: onPickVideo,
    );

    if (!twoColumns) {
      return Column(children: [left, 16.verticalSpace, right]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        24.horizontalSpace,
        Expanded(child: right),
      ],
    );
  }
}

class RoomDetailsMainColumn extends StatelessWidget {
  final RoomDetailsController controller;
  final bool wide;

  const RoomDetailsMainColumn({
    super.key,
    required this.controller,
    required this.wide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoomDetailsSectionCard(
          title: 'Basic Information',
          icon: Icons.info_outline_rounded,
          child: RoomDetailsBasicFields(controller: controller, wide: wide),
        ),
        16.verticalSpace,
        RoomDetailsSectionCard(
          title: 'Pricing & Charges',
          icon: Icons.payments_outlined,
          child: RoomDetailsPricingFields(controller: controller, wide: wide),
        ),
        16.verticalSpace,
        RoomDetailsSectionCard(
          title: 'Capacity & Dimensions',
          icon: Icons.straighten_rounded,
          child: RoomDetailsCapacityFields(controller: controller, wide: wide),
        ),
      ],
    );
  }
}

class RoomDetailsExtraColumn extends StatelessWidget {
  final RoomDetailsController controller;
  final VoidCallback onPickImages;
  final VoidCallback onPickVideo;

  const RoomDetailsExtraColumn({
    super.key,
    required this.controller,
    required this.onPickImages,
    required this.onPickVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final labels = _labelsOf(controller);

          return RoomDetailsSectionCard(
            title: labels.description,
            icon: Icons.description_outlined,
            child: customTextField(
              hint: labels.description,
              controller: controller.roomDescriptionController,
              isSuffix: false,
              isVisible: true,
              maxline: 4,
            ),
          );
        }),
        Obx(() {
          final isHotel = (controller
                      .selectedProperty.value?.propertyCategory?.name
                      ?.trim()
                      .toLowerCase() ??
                  '') ==
              'hotel';

          if (!isHotel) return const SizedBox.shrink();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoomDetailsSectionCard(
                title: 'Facilities Available',
                icon: Icons.all_inclusive_rounded,
                child: RoomDetailsFacilities(controller: controller),
              ),
              16.verticalSpace,
            ],
          );
        }),
        RoomDetailsMediaCard(
          controller: controller,
          onPickImages: onPickImages,
          onPickVideo: onPickVideo,
        ),
      ],
    );
  }
}

class RoomDetailsBasicFields extends StatelessWidget {
  final RoomDetailsController controller;
  final bool wide;

  const RoomDetailsBasicFields({
    super.key,
    required this.controller,
    required this.wide,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final labels = _labelsOf(controller);

      return RoomDetailsFieldGrid(
        wide: wide,
        children: [
          customDropdownField<Properties>(
            hint: 'Property',
            items: controller.properties.map((prop) {
              return DropdownMenuItem<Properties>(
                value: prop,
                child: Text(prop.title ?? ''),
              );
            }).toList(),
            value: controller.selectedProperty.value,
            onChanged: (val) {
              controller.selectedProperty.value = val;
              final isHotel =
                  (val?.propertyCategory?.name?.trim().toLowerCase() ?? '') ==
                      'hotel';
              if (!isHotel) {
                controller.selectedFacilityIds.clear();
              }
            },
          ),
          customTextField(
            hint: labels.name,
            controller: controller.roomNameController,
            isSuffix: false,
            isVisible: true,
            icon: Icons.meeting_room_outlined,
          ),
          customDropdownField<Type>(
            hint: labels.type,
            items: controller.roomTypes.map((rt) {
              return DropdownMenuItem<Type>(
                value: rt,
                child: Text(rt.name ?? ''),
              );
            }).toList(),
            value: controller.selectedRoomType.value,
            onChanged: (val) => controller.selectedRoomType.value = val,
          ),
          if (labels.showBed)
            customDropdownField<Type>(
              hint: 'Bed Type',
              items: controller.bedTypes.map((bt) {
                return DropdownMenuItem<Type>(
                  value: bt,
                  child: Text(bt.name ?? ''),
                );
              }).toList(),
              value: controller.selectedBedType.value,
              onChanged: (val) => controller.selectedBedType.value = val,
            ),
        ],
      );
    });
  }
}

class RoomDetailsPricingFields extends StatelessWidget {
  final RoomDetailsController controller;
  final bool wide;

  const RoomDetailsPricingFields({
    super.key,
    required this.controller,
    required this.wide,
  });

  Widget _number(
    String hint,
    TextEditingController textController,
    IconData icon,
  ) {
    return customTextField(
      hint: hint,
      controller: textController,
      isSuffix: false,
      isVisible: true,
      icon: icon,
      keyboard: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final labels = _labelsOf(controller);

      return RoomDetailsFieldGrid(
        wide: wide,
        children: [
          _number(
            labels.price,
            controller.roomPriceController,
            Icons.attach_money_rounded,
          ),
          _number(
            labels.discount,
            controller.discountPriceController,
            Icons.money_off_rounded,
          ),
          if (labels.isHotel) ...[
            _number(
              'Extra Price Per Adult',
              controller.extraPriceAdultController,
              Icons.person_add_alt_1_outlined,
            ),
            _number(
              'Extra Price Per Child Bed',
              controller.extraPriceChildController,
              Icons.child_care_rounded,
            ),
            _number(
              'Extra Mattress Price Per Night',
              controller.extraMattressPriceController,
              Icons.bed_rounded,
            ),
          ],
          _number(
            'VAT %',
            controller.vatPercentageController,
            Icons.percent_rounded,
          ),
          _number(
            'Service Charge',
            controller.serviceChargeController,
            Icons.room_service_outlined,
          ),
        ],
      );
    });
  }
}

class RoomDetailsCapacityFields extends StatelessWidget {
  final RoomDetailsController controller;
  final bool wide;

  const RoomDetailsCapacityFields({
    super.key,
    required this.controller,
    required this.wide,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final labels = _labelsOf(controller);

      return RoomDetailsFieldGrid(
        wide: wide,
        children: [
          if (labels.showAdults)
            customTextField(
              hint: 'Adults Limit',
              controller: controller.capacityAdultsController,
              isSuffix: false,
              isVisible: true,
              icon: Icons.people_alt_outlined,
              keyboard: TextInputType.number,
            ),
          if (labels.showChildren)
            customTextField(
              hint: 'Children Limit',
              controller: controller.capacityChildrenController,
              isSuffix: false,
              isVisible: true,
              icon: Icons.child_friendly_outlined,
              keyboard: TextInputType.number,
            ),
          customTextField(
            hint: labels.size,
            controller: controller.roomSizeController,
            isSuffix: false,
            isVisible: true,
            icon: Icons.photo_size_select_small_rounded,
          ),
          customTextField(
            hint: labels.count,
            controller: controller.numberOfRoomController,
            isSuffix: false,
            isVisible: true,
            icon: Icons.layers_outlined,
            keyboard: TextInputType.number,
          ),
        ],
      );
    });
  }
}

class RoomDetailsFacilities extends StatelessWidget {
  final RoomDetailsController controller;

  const RoomDetailsFacilities({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Wrap(
        spacing: 8,
        runSpacing: 10,
        children: controller.facilities.map((facility) {
          final bool isSelected = controller.selectedFacilityIds.contains(
            facility.id,
          );

          return RoomDetailsFacilityChip(
            name: facility.name ?? '',
            isSelected: isSelected,
            onTap: () => controller.toggleFacility(facility.id ?? 0),
          );
        }).toList(),
      );
    });
  }
}

class RoomDetailsFacilityChip extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const RoomDetailsFacilityChip({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: isSelected ? mainColor : Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: isSelected ? mainColor : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.add_circle_outline_rounded,
                  size: 18,
                  color: isSelected ? Colors.black87 : Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoomDetailsMediaCard extends StatelessWidget {
  final RoomDetailsController controller;
  final VoidCallback onPickImages;
  final VoidCallback onPickVideo;

  const RoomDetailsMediaCard({
    super.key,
    required this.controller,
    required this.onPickImages,
    required this.onPickVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final labels = _labelsOf(controller);

      return RoomDetailsSectionCard(
        title: labels.media,
        icon: Icons.perm_media_outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: RoomDetailsUploadButton(
                    icon: Icons.image_outlined,
                    label: 'Pick Images',
                    onTap: onPickImages,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoomDetailsUploadButton(
                    icon: Icons.video_library_outlined,
                    label: 'Pick Video',
                    onTap: onPickVideo,
                  ),
                ),
              ],
            ),
            Obx(() {
              final images =
                  controller.roomDetails.value.propertyRoom?.roomImages ?? [];
              if (images.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const RoomDetailsSubTitle(text: 'Existing Images'),
                  const SizedBox(height: 10),
                  RoomDetailsImageGrid(
                    children: images.map<Widget>((img) {
                      return RoomDetailsImageTile(
                        onRemove: null,
                        child: WebSafeNetworkImage(
                          imageUrl: img.photoName,
                          fit: BoxFit.cover,
                        ));
                      //   Image.network(
                      //     '${Api.imageUrl}${img.photoName}',
                      //     fit: BoxFit.cover,
                      //     errorBuilder: (context, error, stackTrace) {
                      //       return Container(
                      //         color: const Color(0xFFF3F4F6),
                      //         child: const Icon(
                      //           Icons.broken_image_outlined,
                      //           color: Colors.grey,
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // );
                    }).toList(),
                  ),
                ],
              );
            }),
            Obx(() {
              final video = controller.selectedVideo.value;
              if (video == null) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Video Selected: ${video.path.split('/').last}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => controller.selectedVideo.value = null,
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Obx(() {
              final images = controller.selectedImages;
              if (images.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const RoomDetailsSubTitle(text: 'New Images'),
                  const SizedBox(height: 10),
                  RoomDetailsImageGrid(
                    children: List.generate(images.length, (index) {
                      return RoomDetailsImageTile(
                        onRemove: () => controller.selectedImages.removeAt(
                          index,
                        ),
                        child: kIsWeb
                            ? 
                            WebSafeNetworkImage(
                                imageUrl: images[index].path,
                                fit: BoxFit.cover,
                              )
                            // Image.network(
                            //     images[index].path,
                            //       fit: BoxFit.cover,
                            //     )
                            : Image.file(images[index], fit: BoxFit.cover),
                      );
                    }),
                  ),
                ],
              );
            }),
          ],
        ),
      );
    });
  }
}

class RoomDetailsFooter extends StatelessWidget {
  final RoomDetailsController controller;
  final int roomId;
  final double maxWidth;

  const RoomDetailsFooter({
    super.key,
    required this.controller,
    required this.roomId,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 52,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: OutlinedButton(
                      onPressed: () => controller.clearControllers(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFD1D5DB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Clear All',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Obx(() {
                  return customButton2(
                    title: 'Save Details',
                    icon: Icons.save_rounded,
                    height: 52,
                    isLoading: controller.isLoading.value,
                    onTap: () {
                      if (controller.isLoading.value) return;
                      controller.updateRoomDetails(roomId);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomDetailsSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const RoomDetailsSectionCard({
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

class RoomDetailsFieldGrid extends StatelessWidget {
  final bool wide;
  final List<Widget> children;

  const RoomDetailsFieldGrid({
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
              child: i + 1 < children.length
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

class RoomDetailsUploadButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const RoomDetailsUploadButton({
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
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 28, color: mainColor),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoomDetailsSubTitle extends StatelessWidget {
  final String text;

  const RoomDetailsSubTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF374151),
      ),
    );
  }
}

class RoomDetailsImageGrid extends StatelessWidget {
  final List<Widget> children;

  const RoomDetailsImageGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      children: children,
    );
  }
}

class RoomDetailsImageTile extends StatelessWidget {
  final Widget child;
  final VoidCallback? onRemove;

  const RoomDetailsImageTile({
    super.key,
    required this.child,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: child),
        if (onRemove != null)
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
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class RoomDetailsSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const RoomDetailsSourceOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF3F4F6),
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(icon, color: mainColor, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomDetailsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const RoomDetailsErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 160,
              child: customButton2(
                title: 'Retry',
                icon: Icons.refresh_rounded,
                onTap: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomDetailsTopBar extends StatelessWidget {
  final double horizontalPadding;

  const RoomDetailsTopBar({super.key, required this.horizontalPadding});

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
          const RoomDetailsBackButton(light: false),
          16.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Room Details',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
              2.verticalSpace,
              Text(
                'Edit pricing, facilities and media',
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

class RoomDetailsBackButton extends StatelessWidget {
  final bool light;

  const RoomDetailsBackButton({super.key, required this.light});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: light
                ? Colors.white.withValues(alpha: 0.18)
                : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: light ? Colors.black : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}