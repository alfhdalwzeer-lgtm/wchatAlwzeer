import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  const ChatScreen({super.key, required this.userName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [
    Message(
      id: '1',
      senderId: 'user2',
      text: 'أهلاً بك في Al-Wazir Chat!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      status: MessageStatus.read,
    ),
    Message(
      id: '2',
      senderId: 'me',
      text: 'تم تفعيل علامات الصح الذهبية ✔️✔️',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      status: MessageStatus.read,
    ),
  ];

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;
    setState(() {
      _messages.add(
        Message(
          id: DateTime.now().toString(),
          senderId: 'me',
          text: _textController.text.trim(),
          timestamp: DateTime.now(),
          status: MessageStatus.sent,
        ),
      );
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E232A),
        title: Text(widget.userName, style: const TextStyle(color: Color(0xFFD4AF37))),
        actions: [
          IconButton(icon: const Icon(Icons.videocam, color: Color(0xFFD4AF37)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call, color: Color(0xFFD4AF37)), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return MessageBubble(message: msg, isMe: msg.senderId == 'me');
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: const Color(0xFF1E232A),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.attach_file, color: Color(0xFFD4AF37)), onPressed: () {}),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "اكتب رسالة...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                      fillColor: const Color(0xFF2C3038),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                CircleAvatar(
                  backgroundColor: const Color(0xFFD4AF37),
                  child: IconButton(icon: const Icon(Icons.send, color: Colors.black), onPressed: _sendMessage),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
