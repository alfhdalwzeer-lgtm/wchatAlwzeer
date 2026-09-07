import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: const LoginScreen(),
    );
  }
}

// 1. شاشة التسجيل الدولية
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+967';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFD4AF37),
              child: Text('👑', style: TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 20),
            const Text('Al-Wazir Chat 👑', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37))),
            const SizedBox(height: 10),
            const Text('أدخل رقم هاتفك بترميز الدولة للاشتراك', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD4AF37)), borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCountryCode,
                      dropdownColor: const Color(0xFF1E1E1E),
                      items: ['+967', '+966', '+971', '+1', '+44', '+20'].map((code) {
                        return DropdownMenuItem(value: code, child: Text(code, style: const TextStyle(color: Colors.white)));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedCountryCode = val!),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'رقم الهاتف',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                if (_phoneController.text.isNotEmpty) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainHomeScreen()));
                }
              },
              child: const Text('دخول / تسجيل', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

// 2. الشاشة الرئيسية للتطبيقات (محادثات - حالات - مجموعات)
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const ChatDetailScreen(),
    const StatusScreen(),
    const GroupScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E1E1E),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'المحادثات'),
          BottomNavigationBarItem(icon: Icon(Icons.style), label: 'الحالات'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'المجموعات'),
        ],
      ),
    );
  }
}

// 3. شاشة المحادثة مع التخزين المحلي والوسائط
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> _messages = [];
  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    _loadStoredMessages();
  }

  // حفظ المحادثة محلياً
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encoded = _messages.map((e) => jsonEncode({
      'type': e['type'],
      'content': e['content'] is File ? (e['content'] as File).path : e['content'],
      'isMe': e['isMe'],
      'time': e['time'],
    })).toList();
    await prefs.setStringList('saved_chat', encoded);
  }

  // استرجاع المحادثات عند فتح التطبيق
  Future<void> _loadStoredMessages() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? saved = prefs.getStringList('saved_chat');
    if (saved != null) {
      setState(() {
        _messages = saved.map((e) {
          var decoded = jsonDecode(e);
          return {
            'type': decoded['type'],
            'content': decoded['type'] == 'image' ? File(decoded['content']) : decoded['content'],
            'isMe': decoded['isMe'],
            'time': decoded['time'],
          };
        }).toList();
      });
    }
  }

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty || _isBlocked) return;
    setState(() {
      _messages.insert(0, {
        'type': 'text',
        'content': _msgController.text.trim(),
        'isMe': true,
        'time': 'الآن'
      });
    });
    _msgController.clear();
    _saveMessages();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_isBlocked) return;
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _messages.insert(0, {
          'type': 'image',
          'content': File(pickedFile.path),
          'isMe': true,
          'time': 'الآن'
        });
      });
      _saveMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Wazir Chat 👑'),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () => _startCall(false)),
          IconButton(icon: const Icon(Icons.videocam), onPressed: () => _startCall(true)),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'block') {
                setState(() => _isBlocked = !_isBlocked);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_isBlocked ? 'تم حظر الرقم' : 'تم إلغاء الحظر')),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'block', child: Text(_isBlocked ? 'إلغاء الحظر' : 'حظر الرقم')),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          if (_isBlocked)
            Container(color: Colors.red, padding: const EdgeInsets.all(4), child: const Center(child: Text('هذا الرقم محظور', style: TextStyle(color: Colors.white)))),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: msg['isMe'] ? const Color(0xFF2C2A1E) : const Color(0xFF222222),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: msg['type'] == 'text'
                        ? Text(msg['content'], style: const TextStyle(color: Colors.white))
                        : Image.file(msg['content'] as File, width: 180, height: 180, fit: BoxFit.cover),
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
                IconButton(icon: const Icon(Icons.camera_alt, color: Color(0xFFD4AF37)), onPressed: () => _pickImage(ImageSource.camera)),
                IconButton(icon: const Icon(Icons.photo, color: Color(0xFFD4AF37)), onPressed: () => _pickImage(ImageSource.gallery)),
                Expanded(child: TextField(controller: _msgController, decoration: const InputDecoration(hintText: 'اكتب رسالة...', border: InputBorder.none))),
                IconButton(icon: const Icon(Icons.send, color: Color(0xFFD4AF37)), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startCall(bool isVideo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(isVideo ? 'مكالمة فيديو' : 'مكالمة صوتية', style: const TextStyle(color: Color(0xFFD4AF37))),
        content: Text(isVideo ? 'جاري فتح الكاميرا والاتصال المباشر...' : 'جاري الاتصال الصوتي...'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق'))],
      ),
    );
  }
}

// 4. شاشة الحالات (Status)
class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الحالات')),
      body: const Center(child: Text('اضغط + لإضافة حالة جديدة (صور / فيديو)')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: () {},
        child: const Icon(Icons.add_a_photo, color: Colors.black),
      ),
    );
  }
}

// 5. شاشة المجموعات (Groups)
class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المجموعات')),
      body: const Center(child: Text('لا توجد مجموعات حالياً')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: () {},
        child: const Icon(Icons.group_add, color: Colors.black),
      ),
    );
  }
}
