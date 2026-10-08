import 'dart:async';
import 'package:intl/intl.dart';
import 'package:renth_manager/widgets/web_image.dart';
import '../../consts/consts.dart';
import '../../controller/quick_tech_chat_controller.dart';
import '../../model/message_list_model.dart';

class QuickTechChatDetailPage extends StatelessWidget {
  final String userName;
  final int receiverId;
  final String profilePhoto;

  const QuickTechChatDetailPage({
    super.key,
    required this.userName,
    required this.receiverId,
    required this.profilePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (width < 600) {
            return ChatDetailMobileView(
              userName: userName,
              receiverId: receiverId,
              profilePhoto: profilePhoto,
            );
          } else if (width < 1024) {
            return ChatDetailTabletView(
              userName: userName,
              receiverId: receiverId,
              profilePhoto: profilePhoto,
            );
          } else {
            return ChatDetailDesktopView(
              userName: userName,
              receiverId: receiverId,
              profilePhoto: profilePhoto,
            );
          }
        },
      ),
    );
  }
}

class ChatDetailMobileView extends StatelessWidget {
  final String userName;
  final int receiverId;
  final String profilePhoto;

  const ChatDetailMobileView({
    super.key,
    required this.userName,
    required this.receiverId,
    required this.profilePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: ChatDetailPanel(
          userName: userName,
          receiverId: receiverId,
          profilePhoto: profilePhoto,
          showBack: true,
        ),
      ),
    );
  }
}

class ChatDetailTabletView extends StatelessWidget {
  final String userName;
  final int receiverId;
  final String profilePhoto;

  const ChatDetailTabletView({
    super.key,
    required this.userName,
    required this.receiverId,
    required this.profilePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ChatDetailCard(
              child: ChatDetailPanel(
                userName: userName,
                receiverId: receiverId,
                profilePhoto: profilePhoto,
                showBack: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatDetailDesktopView extends StatelessWidget {
  final String userName;
  final int receiverId;
  final String profilePhoto;

  const ChatDetailDesktopView({
    super.key,
    required this.userName,
    required this.receiverId,
    required this.profilePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: ChatDetailCard(
              child: ChatDetailPanel(
                userName: userName,
                receiverId: receiverId,
                profilePhoto: profilePhoto,
                showBack: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatDetailCard extends StatelessWidget {
  final Widget child;

  const ChatDetailCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class ChatDetailPanel extends StatefulWidget {
  final String userName;
  final int receiverId;
  final String? profilePhoto;
  final bool showBack;

  const ChatDetailPanel({
    super.key,
    required this.userName,
    required this.receiverId,
    required this.profilePhoto,
    required this.showBack,
  });

  @override
  State<ChatDetailPanel> createState() => _ChatDetailPanelState();
}

class _ChatDetailPanelState extends State<ChatDetailPanel> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatController chatController = Get.find<ChatController>();
  Timer? _timer;
  Worker? _worker;
  int _lastCount = 0;

  @override
  void initState() {
    super.initState();

    _worker = ever(chatController.messages, (_) {
      final int count = chatController.messages.length;
      if (count != _lastCount) {
        _lastCount = count;
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.messages.clear();
      chatController.fetchMessageList(widget.receiverId);
    });

    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      chatController.fetchMessageList(widget.receiverId);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _worker?.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _send() {
    final String text = _messageController.text.trim();
    if (text.isEmpty) return;

    chatController.sendMessage(text, widget.receiverId);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChatDetailHeader(
          userName: widget.userName,
          profilePhoto: widget.profilePhoto,
          showBack: widget.showBack,
        ),
        Expanded(
          child: Container(
            color: const Color(0xFFF7F8FA),
            child: ChatMessageList(
              controller: chatController,
              scrollController: _scrollController,
              receiverId: widget.receiverId,
            ),
          ),
        ),
        ChatInputBar(controller: _messageController, onSend: _send),
      ],
    );
  }
}

class ChatDetailHeader extends StatelessWidget {
  final String userName;
  final String? profilePhoto;
  final bool showBack;

  const ChatDetailHeader({
    super.key,
    required this.userName,
    required this.profilePhoto,
    required this.showBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          if (showBack) ...[
            const ChatBackButton(light: false),
            12.horizontalSpace,
          ],
          ChatUserAvatar(photo: profilePhoto, name: userName, size: 42),
          12.horizontalSpace,
          Expanded(
            child: Text(
              userName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessageList extends StatelessWidget {
  final ChatController controller;
  final ScrollController scrollController;
  final int receiverId;

  const ChatMessageList({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final messages = controller.messages;

      if (controller.isMessageLoading.value && messages.isEmpty) {
        return Center(child: CircularProgressIndicator(color: mainColor));
      }

      if (messages.isEmpty) {
        return const ChatEmptyMessages();
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final double maxBubble =
              (constraints.maxWidth * 0.75).clamp(0.0, 520.0).toDouble();

          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final bool isMe = message.receiverId == receiverId;

              return ChatBubble(
                message: message,
                isMe: isMe,
                maxWidth: maxBubble,
              );
            },
          );
        },
      );
    });
  }
}

class ChatBubble extends StatelessWidget {
  final Messages message;
  final bool isMe;
  final double maxWidth;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? mainColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: isMe ? null : Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            SelectableText(
              message.msg ?? '',
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.4,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.updatedAt != null
                  ? DateFormat('hh:mm a').format(message.updatedAt!)
                  : '',
              style: TextStyle(
                fontSize: 10.5,
                color: isMe ? Colors.black54 : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatEmptyMessages extends StatelessWidget {
  const ChatEmptyMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 36,
              color: mainColor,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Say hello to start the conversation',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(28),
              ),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                style: const TextStyle(fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Material(
              color: mainColor,
              shape: const CircleBorder(),
              elevation: 3,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onSend,
                child: const Padding(
                  padding: EdgeInsets.all(13),
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.black87,
                    size: 22,
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

class ChatUserAvatar extends StatelessWidget {
  final String? photo;
  final String name;
  final double size;

  const ChatUserAvatar({
    super.key,
    required this.photo,
    required this.name,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasPhoto = photo != null && photo!.isNotEmpty;
    final String initial =
        name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

    final Widget fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      color: mainColor.withValues(alpha: 0.25),
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: hasPhoto
            ? WebSafeNetworkImage(
                imageUrl: photo,
                width: size,
                height: size,
                fit: BoxFit.cover,
                isCircle: true,
                errorWidget: fallback,
              )
            : fallback,
      ),
    );
  }
}

class ChatBackButton extends StatelessWidget {
  final bool light;

  const ChatBackButton({super.key, required this.light});

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