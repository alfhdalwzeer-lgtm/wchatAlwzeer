import 'package:flutter/material.dart';

void main() {
  runApp(const AlWazirChatApp());
}

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Wazir Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF128C7E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF128C7E),
          secondary: const Color(0xFF25D366),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// ---------------- 1. شاشة التسجيل ----------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  void _login() {
    if (_phoneController.text.isNotEmpty && _nameController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userName: _nameController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_rounded, size: 80, color: Color(0xFF128C7E)),
            const SizedBox(height: 16),
            const Text(
              'Al-Wazir Chat',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'الاسم الكامل',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF128C7E),
                  foregroundColor: Colors.white,
                ),
                onPressed: _login,
                child: const Text('دخول / تسجيل', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- 2. شاشة قائمة المحادثات ----------------
class HomeScreen extends StatelessWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final names = ['م. صادق', 'خالد حسن', 'فريق الدعم', 'أحمد علي', 'محمد حسين'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF128C7E),
        foregroundColor: Colors.white,
        title: Text('Al-Wazir Chat ($userName)'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF128C7E),
              child: Text(
                names[index][0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(names[index]),
            subtitle: const Text('رسالة نصية أو تسجيل صوتي'),
            trailing: const Text('10:30 ص'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(contactName: names[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.chat, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}

// ---------------- 3. شاشة المحادثة الرئيسية ----------------
class ChatDetailScreen extends StatefulWidget {
  final String contactName;
  const ChatDetailScreen({super.key, required this.contactName});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final List<Map<String, dynamic>> _messages = [
    {'text': 'أهلاً بك في Al-Wazir Chat!', 'isMe': false, 'type': 'text'},
  ];

  final _textController = TextEditingController();
  bool _isRecording = false;

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _textController.text,
          'isMe': true,
          'type': 'text',
        });
        _textController.clear();
      });
    }
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (!_isRecording) {
        _messages.add({
          'text': 'مقطع صوتي (0:05)',
          'isMe': true,
          'type': 'audio',
        });
      }
    });
  }

  void _startCall(bool isVideo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          contactName: widget.contactName,
          isVideo: isVideo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF128C7E),
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              child: Text(widget.contactName[0]),
            ),
            const SizedBox(width: 8),
            Text(widget.contactName, style: const TextStyle(fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () => _startCall(true),
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () => _startCall(false),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: msg['isMe'] ? const Color(0xFFDCF8C6) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
                    ),
                    child: msg['type'] == 'audio'
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow, color: Color(0xFF128C7E)),
                              SizedBox(width: 8),
                              Text('تسجيل صوتي'),
                            ],
                          )
                        : Text(msg['text'], style: const TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[200],
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  color: _isRecording ? Colors.red : const Color(0xFF128C7E),
                  onPressed: _toggleRecording,
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالة...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF128C7E)),
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

// ---------------- 4. شاشة المكالمات الصوتية والمصورة ----------------
class CallScreen extends StatefulWidget {
  final String contactName;
  final bool isVideo;
  const CallScreen({super.key, required this.contactName, required this.isVideo});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF128C7E),
                  child: Text(
                    widget.contactName[0],
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.contactName,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isVideo ? 'مكالمة فيديو جارية...' : 'مكالمة صوتية جارية...',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: 'btnMute',
                    backgroundColor: _isMuted ? Colors.white : Colors.white24,
                    onPressed: () {
                      setState(() {
                        _isMuted = !_isMuted;
                      });
                    },
                    child: Icon(
                      _isMuted ? Icons.mic_off : Icons.mic,
                      color: _isMuted ? Colors.black : Colors.white,
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: 'btnEnd',
                    backgroundColor: Colors.red,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.call_end, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
