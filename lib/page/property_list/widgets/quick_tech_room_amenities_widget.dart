import 'package:renth_manager/controller/quick_tech_property_room_store_controller.dart';
import 'package:renth_manager/widgets/web_image.dart';

import '../../../consts/consts.dart';

class QuickTechRoomAmenitiesWidget extends StatelessWidget {
  QuickTechRoomAmenitiesWidget({super.key});

  final roomController = locator.get<QuickTechPropertyRoomController>();
  final commonController = locator.get<CommonController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final facilities = commonController.facilities;

      if (facilities.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator(color: mainColor)),
        );
      }

      return GridView.builder(
        itemCount: facilities.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 230,
          mainAxisExtent: 56,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final data = facilities[index];

          return Obx(() {
            final isSelected = roomController.selectedFacilities.contains(
              data.id,
            );

            return AmenityTile(
              name: data.name ?? '',
              photo: data.facilityPhoto,
              isSelected: isSelected,
              onTap: () {
                if (data.id != null) {
                  roomController.toggleFacility(data.id!);
                }
              },
            );
          });
        },
      );
    });
  }
}

class AmenityTile extends StatelessWidget {
  final String name;
  final String? photo;
  final bool isSelected;
  final VoidCallback onTap;

  const AmenityTile({
    super.key,
    required this.name,
    required this.photo,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String? url = photo == null
        ? null
        : (photo!.startsWith('http') ? photo : '${Api.baseUrl}/$photo');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: isSelected ? mainColor.withValues(alpha: 0.14) : Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? mainColor : const Color(0xFFE5E7EB),
            width: isSelected ? 1.6 : 1.2,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: WebSafeNetworkImage(
                    imageUrl: url,
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(6),
                    errorWidget: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 26,
                      color: Colors.grey,
                    ),
                  ),
                ),
                8.horizontalSpace,
                Expanded(
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, size: 18, color: mainColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}