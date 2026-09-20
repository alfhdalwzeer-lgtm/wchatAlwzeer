import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userName;

  const ChatScreen({
    super.key,
    required this.userName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  bool _showMediaMenu = false;
  bool _showStickers = false;

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'السلام عليكم ورحمة الله وبركاته',
      isMe: false,
      time: '10:20 م',
      isRead: true,
    ),
    _ChatMessage(
      text: 'وعليكم السلام ورحمة الله وبركاته 🌹',
      isMe: true,
      time: '10:21 م',
      isRead: true,
    ),
    _ChatMessage(
      text: 'أهلاً بك في الفهد 🐆',
      isMe: false,
      time: '10:21 م',
      isRead: true,
    ),
    _ChatMessage(
      text: 'تطبيق الفهد جاهز للمحادثة',
      isMe: true,
      time: '10:22 م',
      isRead: true,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(
          text: text,
          isMe: true,
          time: _currentTime(),
          isRead: true,
        ),
      );

      _messageController.clear();
      _showMediaMenu = false;
      _showStickers = false;
    });

    _scrollToBottom();
  }

  String _currentTime() {
    final now = TimeOfDay.now();
    return now.format(context);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF151D24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 15),
                _menuItem(
                  Icons.search,
                  'بحث في المحادثة',
                ),
                _menuItem(
                  Icons.notifications_none,
                  'كتم الإشعارات',
                ),
                _menuItem(
                  Icons.lock_outline,
                  'قفل المحادثة',
                ),
                _menuItem(
                  Icons.cleaning_services_outlined,
                  'مسح المحادثة',
                ),
                _menuItem(
                  Icons.block,
                  'حظر جهة الاتصال',
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFD4AF37),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  void _openMediaMenu() {
    setState(() {
      _showMediaMenu = !_showMediaMenu;
      _showStickers = false;
    });
  }

  void _openStickers() {
    setState(() {
      _showStickers = !_showStickers;
      _showMediaMenu = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF080B0F),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildMessages(),
                  if (_showMediaMenu) _buildMediaPanel(),
                  if (_showStickers) _buildStickerPanel(),
                ],
              ),
            ),
            _buildComposer(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1E2A31),
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF151D24),
              border: Border.all(
                color: const Color(0xFFD4AF37),
                width: 1.3,
              ),
            ),
            child: Center(
              child: Text(
                widget.userName == 'الفهد' ? '🐆' : '👤',
                style: const TextStyle(fontSize: 23),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    widget.userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'متصل الآن',
                    style: TextStyle(
                      color: Color(0xFF9CCC65),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.videocam_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          IconButton(
            onPressed: _showMoreMenu,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(
        12,
        18,
        12,
        18,
      ),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];

        return _MessageBubble(
          message: message,
        );
      },
    );
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        8,
        8,
        8,
        9,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF111820),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 50,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2A31),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: const Color(0xFF2C3942),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _openStickers,
                          icon: const Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.white54,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            textDirection: TextDirection.rtl,
                            minLines: 1,
                            maxLines: 5,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            onTap: () {
                              setState(() {
                                _showMediaMenu = false;
                                _showStickers = false;
                              });
                            },
                            decoration:
                                const InputDecoration(
                              hintText: 'اكتب رسالة...',
                              hintStyle: TextStyle(
                                color: Colors.white38,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _openMediaMenu,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.white54,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4AF37),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.black,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPanel() {
    return Positioned(
      left: 12,
      right: 12,
      bottom: 12,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF18232C),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(.25),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'مركز الوسائط',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                _MediaButton(
                  icon: Icons.camera_alt,
                  title: 'الكاميرا',
                  onTap: () {
                    setState(() {
                      _showMediaMenu = false;
                    });
                  },
                ),
                _MediaButton(
                  icon: Icons.photo,
                  title: 'المعرض',
                  onTap: () {
                    setState(() {
                      _showMediaMenu = false;
                    });
                  },
                ),
                _MediaButton(
                  icon: Icons.videocam,
                  title: 'فيديو',
                  onTap: () {
                    setState(() {
                      _showMediaMenu = false;
                    });
                  },
                ),
                _MediaButton(
                  icon: Icons.insert_drive_file,
                  title: 'ملف',
                  onTap: () {
                    setState(() {
                      _showMediaMenu = false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickerPanel() {
    const stickers = [
      '🐆',
      '❤️',
      '😂',
      '😍',
      '🔥',
      '👍',
      '👏',
      '😊',
      '😎',
      '🤍',
      '🌹',
      '✨',
    ];

    return Positioned(
      left: 8,
      right: 8,
      bottom: 8,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF18232C),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(.25),
          ),
        ),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: stickers.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                _messageController.text +=
                    stickers[index];

                setState(() {
                  _showStickers = false;
                });
              },
              child: Center(
                child: Text(
                  stickers[index],
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// فقاعة الرسالة
// ============================================================

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = message.isMe
        ? const Color(0xFF075E54)
        : const Color(0xFF1F2C34);

    return Align(
      alignment: message.isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * .78,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(
          12,
          8,
          10,
          6,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(
              message.isMe ? 15 : 3,
            ),
            bottomRight: Radius.circular(
              message.isMe ? 3 : 15,
            ),
          ),
          border: message.isMe
              ? Border.all(
                  color: const Color(0xFF0B7165),
                  width: .5,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              message.time,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 9,
              ),
            ),
            if (message.isMe) ...[
              const SizedBox(width: 3),
              Icon(
                Icons.done_all,
                size: 15,
                color: message.isRead
                    ? const Color(0xFF53BDEB)
                    : Colors.white54,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// زر الوسائط
// ============================================================

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MediaButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF111820),
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    const Color(0xFFD4AF37).withOpacity(.35),
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFD4AF37),
              size: 24,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// نموذج الرسالة المحلي
// ============================================================

class _ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;

  const _ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    required this.isRead,
  });
}
