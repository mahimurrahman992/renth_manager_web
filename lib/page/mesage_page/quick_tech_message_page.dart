import '../../consts/consts.dart';
import '../../controller/quick_tech_chat_controller.dart';
import '../../model/chat_list_model.dart';

class QuickTechChatListPage extends StatefulWidget {
  const QuickTechChatListPage({super.key});

  @override
  State<QuickTechChatListPage> createState() => _QuickTechChatListPageState();
}

class _QuickTechChatListPageState extends State<QuickTechChatListPage> {
  final ChatController chatController = Get.put(ChatController());
  Users? selectedUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.fetchChatList();
    });
  }

  void _openChat(Users user) {
    Get.toNamed(
      AppRoutes.chatDetail,
      arguments: {
        'userName': user.name ?? 'Unknown',
        'receiverId': user.id ?? 0,
        'profilePhoto': user.profilePhoto ?? '',
      },
    );
    // Get.to(
    //   () => QuickTechChatDetailPage(
    //     userName: user.name ?? 'Unknown',
    //     receiverId: user.id ?? 0,
    //     profilePhoto: user.profilePhoto ?? '',
    //   ),
    // );
  }

  void _selectChat(Users user) {
    setState(() => selectedUser = user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (width < 600) {
            return ChatListMobileView(
              controller: chatController,
              onOpen: _openChat,
            );
          } else if (width < 1024) {
            return ChatListTabletView(
              controller: chatController,
              onOpen: _openChat,
            );
          } else {
            return ChatListDesktopView(
              controller: chatController,
              selectedUser: selectedUser,
              onSelect: _selectChat,
            );
          }
        },
      ),
    );
  }
}

class ChatListMobileView extends StatelessWidget {
  final ChatController controller;
  final void Function(Users user) onOpen;

  const ChatListMobileView({
    super.key,
    required this.controller,
    required this.onOpen,
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
                  const ChatBackButton(light: true),
                  14.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Messages',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          'Chat with your customers',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white70,
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
                  child: ChatListView(
                    controller: controller,
                    onTap: onOpen,
                    selectedId: null,
                    padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
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

class ChatListTabletView extends StatelessWidget {
  final ChatController controller;
  final void Function(Users user) onOpen;

  const ChatListTabletView({
    super.key,
    required this.controller,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const ChatTopBar(horizontalPadding: 24),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ChatListView(
                  controller: controller,
                  onTap: onOpen,
                  selectedId: null,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
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

class ChatListDesktopView extends StatelessWidget {
  final ChatController controller;
  final Users? selectedUser;
  final void Function(Users user) onSelect;

  const ChatListDesktopView({
    super.key,
    required this.controller,
    required this.selectedUser,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final Users? user = selectedUser;

    return SafeArea(
      child: Column(
        children: [
          const ChatTopBar(horizontalPadding: 40),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 380,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      right: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                  child: ChatListView(
                    controller: controller,
                    onTap: onSelect,
                    selectedId: user?.id,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                Expanded(
                  child: user == null
                      ? const ChatSelectPlaceholder()
                      : Container(
                          color: Colors.white,
                          child: ChatDetailPanel(
                            key: ValueKey(user.id),
                            userName: user.name ?? 'Unknown',
                            receiverId: user.id ?? 0,
                            profilePhoto: user.profilePhoto,
                            showBack: false,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatListView extends StatelessWidget {
  final ChatController controller;
  final void Function(Users user) onTap;
  final int? selectedId;
  final EdgeInsets padding;

  const ChatListView({
    super.key,
    required this.controller,
    required this.onTap,
    required this.selectedId,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchChatList();
      },
      child: Obx(() {
        if (controller.isLoading.value && controller.chatList.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 0.3.sh),
              Center(child: CircularProgressIndicator(color: mainColor)),
            ],
          );
        }

        if (controller.chatList.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 0.2.sh),
              const ChatListEmptyState(),
            ],
          );
        }

        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: padding,
          itemCount: controller.chatList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final user = controller.chatList[index];

            return ChatTile(
              user: user,
              isSelected: selectedId != null && selectedId == user.id,
              onTap: () => onTap(user),
            );
          },
        );
      }),
    );
  }
}

class ChatTile extends StatelessWidget {
  final Users user;
  final bool isSelected;
  final VoidCallback onTap;

  const ChatTile({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: isSelected ? mainColor.withValues(alpha: 0.12) : Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? mainColor : const Color(0xFFE5E7EB),
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                ChatUserAvatar(
                  photo: user.profilePhoto,
                  name: user.name ?? '',
                  size: 48,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? 'Unknown',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatListEmptyState extends StatelessWidget {
  const ChatListEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.forum_outlined, size: 40, color: mainColor),
          ),
          const SizedBox(height: 14),
          const Text(
            'No chats available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your conversations will appear here',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}

class ChatSelectPlaceholder extends StatelessWidget {
  const ChatSelectPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 48,
              color: mainColor,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Select a conversation',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose a chat from the list to start messaging',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}

class ChatTopBar extends StatelessWidget {
  final double horizontalPadding;

  const ChatTopBar({super.key, required this.horizontalPadding});

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
          const ChatBackButton(light: false),
          16.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Messages',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
              2.verticalSpace,
              Text(
                'Chat with your customers',
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