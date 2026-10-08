import 'package:renth_manager/consts/consts.dart' hide PropertyRoom;
import 'package:renth_manager/model/response/quick_tech_room_model.dart';

class QuickTechRoomScreen extends StatefulWidget {
  final int propertyId;

  const QuickTechRoomScreen({super.key, required this.propertyId});

  @override
  State<QuickTechRoomScreen> createState() => _QuickTechRoomScreenState();
}

class _QuickTechRoomScreenState extends State<QuickTechRoomScreen> {
  final controller = locator.get<QuickTechRoomController>();

  int get _effectivePropertyId {
    if (widget.propertyId > 0) return widget.propertyId;
    final savedId = GetStorage().read(StorageKeys.selectedPropertyId);
    return int.tryParse(savedId?.toString() ?? '') ?? 0;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchRoomRecords(propertyId: _effectivePropertyId);
    });
  }

  Future<void> _refresh() async {
    await controller.fetchRoomRecords(propertyId: _effectivePropertyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (width < 600) {
            return RoomScreenMobileView(
              controller: controller,
              propertyId: _effectivePropertyId,
              onRefresh: _refresh,
            );
          } else if (width < 1024) {
            return RoomScreenTabletView(
              controller: controller,
              propertyId: _effectivePropertyId,
              onRefresh: _refresh,
            );
          } else {
            return RoomScreenDesktopView(
              controller: controller,
              propertyId: _effectivePropertyId,
              onRefresh: _refresh,
            );
          }
        },
      ),
    );
  }
}

class RoomScreenMobileView extends StatelessWidget {
  final QuickTechRoomController controller;
  final int propertyId;
  final Future<void> Function() onRefresh;

  const RoomScreenMobileView({
    super.key,
    required this.controller,
    required this.propertyId,
    required this.onRefresh,
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
                  const RoomBackButton(light: true),
                  14.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Room Inventory',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          'Browse and manage rooms by type',
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
                  child: RefreshIndicator(
                    color: mainColor,
                    onRefresh: onRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
                      child: RoomListContent(
                        controller: controller,
                        propertyId: propertyId,
                        columns: 1,
                      ),
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

class RoomScreenTabletView extends StatelessWidget {
  final QuickTechRoomController controller;
  final int propertyId;
  final Future<void> Function() onRefresh;

  const RoomScreenTabletView({
    super.key,
    required this.controller,
    required this.propertyId,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const RoomTopBar(horizontalPadding: 24),
          Expanded(
            child: RefreshIndicator(
              color: mainColor,
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: RoomListContent(
                      controller: controller,
                      propertyId: propertyId,
                      columns: 1,
                    ),
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

class RoomScreenDesktopView extends StatelessWidget {
  final QuickTechRoomController controller;
  final int propertyId;
  final Future<void> Function() onRefresh;

  const RoomScreenDesktopView({
    super.key,
    required this.controller,
    required this.propertyId,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const RoomTopBar(horizontalPadding: 40),
          Expanded(
            child: RefreshIndicator(
              color: mainColor,
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 28.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: RoomListContent(
                      controller: controller,
                      propertyId: propertyId,
                      columns: 2,
                    ),
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

class RoomListContent extends StatelessWidget {
  final QuickTechRoomController controller;
  final int propertyId;
  final int columns;

  const RoomListContent({
    super.key,
    required this.controller,
    required this.propertyId,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: CircularProgressIndicator(color: mainColor),
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return RoomErrorState(
          message: controller.errorMessage.value,
          onRetry: () => controller.fetchRoomRecords(propertyId: propertyId),
        );
      }

      final roomTypes = controller.getUniqueRoomTypes();

      if (roomTypes.isEmpty) {
        return const RoomEmptyState();
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          const double gap = 16;
          final double cardWidth =
              (constraints.maxWidth - gap * (columns - 1)) / columns;

          final List<Widget> cards = [];
          for (int i = 0; i < roomTypes.length; i++) {
            final roomTypeName = roomTypes[i];
            final roomTypeId = controller.getRoomTypeIdByName(roomTypeName);

            if (roomTypeId == null) continue;

            cards.add(
              SizedBox(
                width: cardWidth,
                child: RoomTypeCard(
                  controller: controller,
                  roomTypeName: roomTypeName,
                  roomTypeId: roomTypeId,
                  propertyId: propertyId,
                ).animate().fadeIn(duration: 300.ms, delay: (i * 60).ms),
              ),
            );
          }

          return Wrap(
            spacing: gap,
            runSpacing: gap,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: cards,
          );
        },
      );
    });
  }
}

class RoomTypeCard extends StatelessWidget {
  final QuickTechRoomController controller;
  final String roomTypeName;
  final int roomTypeId;
  final int propertyId;

  const RoomTypeCard({
    super.key,
    required this.controller,
    required this.roomTypeName,
    required this.roomTypeId,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rooms = controller.roomsByType[roomTypeId] ?? [];
      final bool isLoading =
          controller.isLoadingRoomsByType[roomTypeId] ?? false;

      return Container(
        clipBehavior: Clip.antiAlias,
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
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            shape: const Border(),
            collapsedShape: const Border(),
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            iconColor: Colors.black87,
            collapsedIconColor: Colors.black54,
            onExpansionChanged: (_) {
              controller.toggleRoomTypeExpansion(roomTypeId, propertyId);
            },
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.meeting_room_outlined,
                color: Colors.black87,
                size: 22,
              ),
            ),
            title: Text(
              roomTypeName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            subtitle:
                rooms.isEmpty
                    ? null
                    : Text(
                      '${rooms.length} ${rooms.length == 1 ? 'room' : 'rooms'}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF6B7280),
                      ),
                    ),
            children: [
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(color: mainColor),
                  ),
                )
              else if (rooms.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No rooms found for this type',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  ),
                )
              else
                Column(
                  children: [
                    for (int i = 0; i < rooms.length; i++) ...[
                      RoomItemTile(
                        room: rooms[i],
                        onTap: () {
                          final int? id = rooms[i].id;
                          if (id == null) return;
                          Get.toNamed(AppRoutes.roomDetails, arguments: id);
                        },
                        onDelete: () {
                          final int? id = rooms[i].id;
                          if (id == null) return;
                          showDeleteRoomDialog(
                            roomName: rooms[i].roomName ?? 'this room',
                            onConfirm: () {
                              controller.deleteRoom(id, roomTypeId, propertyId);
                            },
                          );
                        },
                      ),
                      if (i != rooms.length - 1) const SizedBox(height: 10),
                    ],
                  ],
                ),
            ],
          ),
        ),
      );
    });
  }
}

class RoomItemTile extends StatelessWidget {
  final PropertyRoom room;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const RoomItemTile({
    super.key,
    required this.room,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final nameColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          room.roomName ?? 'Unknown Room',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bed_outlined, size: 15, color: Color(0xFF9CA3AF)),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                room.bedType?.name ?? 'Standard',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ),
          ],
        ),
      ],
    );

    final priceBadge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: mainColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'BDT ${room.roomPricePerNight}',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );

    final deleteButton = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: IconButton(
        onPressed: onDelete,
        tooltip: 'Delete Room',
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
      ),
    );

    final chevron = const Icon(
      Icons.chevron_right_rounded,
      color: Color(0xFF9CA3AF),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: const Color(0xFFF9FAFB),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool narrow = constraints.maxWidth < 380;

                if (narrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: nameColumn),
                          deleteButton,
                          chevron,
                        ],
                      ),
                      const SizedBox(height: 10),
                      priceBadge,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: nameColumn),
                    const SizedBox(width: 10),
                    priceBadge,
                    const SizedBox(width: 6),
                    deleteButton,
                    chevron,
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

void showDeleteRoomDialog({
  required String roomName,
  required VoidCallback onConfirm,
}) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Delete Room',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to delete "$roomName"? This action cannot be undone.',
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.5,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

class RoomErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const RoomErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
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
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Color(0xFF374151)),
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

class RoomEmptyState extends StatelessWidget {
  const RoomEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.meeting_room_outlined,
                size: 44,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No room types found',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'No room types found for this property.',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomTopBar extends StatelessWidget {
  final double horizontalPadding;

  const RoomTopBar({super.key, required this.horizontalPadding});

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
          const RoomBackButton(light: false),
          16.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Room Inventory',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
              2.verticalSpace,
              Text(
                'Browse and manage rooms by type',
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

class RoomBackButton extends StatelessWidget {
  final bool light;

  const RoomBackButton({super.key, required this.light});

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
