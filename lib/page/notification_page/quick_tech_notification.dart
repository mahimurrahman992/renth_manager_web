import 'package:renth_manager/consts/consts.dart';
import 'package:renth_manager/controller/quick_tech_notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (width < 600) {
            return NotificationMobileView(controller: controller);
          } else if (width < 1024) {
            return NotificationTabletView(controller: controller);
          } else {
            return NotificationDesktopView(controller: controller);
          }
        },
      ),
    );
  }
}

class NotificationMobileView extends StatelessWidget {
  final NotificationController controller;

  const NotificationMobileView({super.key, required this.controller});

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
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
              child: Row(
                children: [
                  const NotificationBackButton(light: true),
                  14.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          'Stay updated with your bookings',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  NotificationRefreshButton(
                    controller: controller,
                    light: true,
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
                  child: RefreshIndicator(
                    onRefresh: () => controller.fetchNotifications(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
                      child: NotificationContent(
                        controller: controller,
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

class NotificationTabletView extends StatelessWidget {
  final NotificationController controller;

  const NotificationTabletView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          NotificationTopBar(controller: controller, horizontalPadding: 24),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.fetchNotifications(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: NotificationContent(
                      controller: controller,
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

class NotificationDesktopView extends StatelessWidget {
  final NotificationController controller;

  const NotificationDesktopView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          NotificationTopBar(controller: controller, horizontalPadding: 40),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.fetchNotifications(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 28.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: NotificationContent(
                      controller: controller,
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

class NotificationContent extends StatelessWidget {
  final NotificationController controller;
  final int columns;

  const NotificationContent({
    super.key,
    required this.controller,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const NotificationLoadingState();
      }

      if (controller.hasError.value) {
        return NotificationErrorState(
          message: controller.errorMessage.value,
          onRetry: () => controller.fetchNotifications(),
        );
      }

      final items = controller.notifications;

      if (items.isEmpty) {
        return const NotificationEmptyState();
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          const double gap = 14;
          final double cardWidth =
              (constraints.maxWidth - gap * (columns - 1)) / columns;

          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: List.generate(items.length, (index) {
              return SizedBox(
                width: cardWidth,
                child: NotificationCard(notification: items[index])
                    .animate()
                    .fadeIn(duration: 300.ms, delay: (index * 50).ms),
              );
            }),
          );
        },
      );
    });
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final bool isRead = notification.isRead;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : mainColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead ? const Color(0xFFE5E7EB) : mainColor,
          width: isRead ? 1 : 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isRead
                  ? const Color(0xFFF3F4F6)
                  : mainColor.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isRead
                  ? Icons.notifications_none_rounded
                  : Icons.notifications_active_rounded,
              size: 22,
              color: isRead ? Colors.grey : Colors.black87,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _notificationTitle(notification.type),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isRead
                              ? const Color(0xFF6B7280)
                              : const Color(0xFF111827),
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notification.data['message'] ?? 'No message',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isRead
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 14,
                  runSpacing: 4,
                  children: [
                    NotificationMeta(
                      icon: Icons.access_time_rounded,
                      text: _formatDate(notification.createdAt),
                    ),
                    if (isRead && notification.readAt != null)
                      NotificationMeta(
                        icon: Icons.done_all_rounded,
                        text: 'Read ${_formatDate(notification.readAt!)}',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationMeta extends StatelessWidget {
  final IconData icon;
  final String text;

  const NotificationMeta({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
        ),
      ],
    );
  }
}

class NotificationLoadingState extends StatelessWidget {
  const NotificationLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: CircularProgressIndicator(color: mainColor),
      ),
    );
  }
}

class NotificationErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const NotificationErrorState({
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
                color: Colors.red,
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

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

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
                Icons.notifications_off_outlined,
                size: 44,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No notifications available',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'New updates will show up here',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationTopBar extends StatelessWidget {
  final NotificationController controller;
  final double horizontalPadding;

  const NotificationTopBar({
    super.key,
    required this.controller,
    required this.horizontalPadding,
  });

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
          const NotificationBackButton(light: false),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                ),
                2.verticalSpace,
                Text(
                  'Stay updated with your bookings',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          NotificationRefreshButton(controller: controller, light: false),
        ],
      ),
    );
  }
}

class NotificationRefreshButton extends StatelessWidget {
  final NotificationController controller;
  final bool light;

  const NotificationRefreshButton({
    super.key,
    required this.controller,
    required this.light,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => controller.fetchNotifications(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: light
                ? Colors.white.withValues(alpha: 0.18)
                : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.refresh_rounded,
            size: 20,
            color: light ? Colors.white : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

class NotificationBackButton extends StatelessWidget {
  final bool light;

  const NotificationBackButton({super.key, required this.light});

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
            color: light ? Colors.white : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

String _notificationTitle(String type) {
  if (type.contains('ReserveProperty')) {
    return 'Property Reservation';
  }
  return 'Notification';
}

String _formatDate(DateTime date) {
  return '${date.hour}:${date.minute.toString().padLeft(2, '0')} • ${date.day}/${date.month}/${date.year}';
}