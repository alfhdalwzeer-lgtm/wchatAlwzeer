import 'package:flutter/material.dart';

void main() {
  runApp(const AlWazirChatApp());
}

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Al-Wazir Chat 👑',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFD4AF37),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Color(0xFFD4AF37),
          centerTitle: true,
        ),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const MainChatScreen(),
    );
  }
}

class MainChatScreen extends StatefulWidget {
  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'content': 'مرحباً بك في Al-Wazir Chat 👑 الملكي!',
      'isMe': false,
      'time': '10:00 م'
    },
    {
      'content': 'برنامج المراسلات الأسرع في العالم ⚡',
      'isMe': false,
      'time': '10:01 م'
    },
  ];

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      _messages.insert(0, {
        'content': _msgController.text.trim(),
        'isMe': true,
        'time': 'الآن'
      });
    });
    _msgController.clear();
  }

  void _showFeatureDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(feature, style: const TextStyle(color: Color(0xFFD4AF37))),
        content: const Text('هذه الميزة تعمل بشكل ممتاز وجاهزة للتطوير.', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً', style: TextStyle(color: Color(0xFFD4AF37))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFD4AF37),
              child: Text('👑', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(width: 8),
            Text('Al-Wazir Chat 👑', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Color(0xFFD4AF37)),
            onPressed: () => _showFeatureDialog('مكالمة صوتية'),
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Color(0xFFD4AF37)),
            onPressed: () => _showFeatureDialog('مكالمة فيديو'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['isMe'] as bool;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF2C2A1E) : const Color(0xFF222222),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isMe ? const Color(0xFFD4AF37) : Colors.transparent,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          msg['content'],
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'],
                          style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF1E1E1E),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Color(0xFFD4AF37)),
                  onPressed: () => _showFeatureDialog('التقاط صورة'),
                ),
                IconButton(
                  icon: const Icon(Icons.photo, color: Color(0xFFD4AF37)),
                  onPressed: () => _showFeatureDialog('اختيار صورة من المعرض'),
                ),
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالة...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFD4AF37)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
