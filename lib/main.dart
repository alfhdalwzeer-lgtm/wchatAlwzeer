import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // تفعيل قاعدة البيانات عند الربط
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
        primaryColor: const Color(0xFFD4AF37), // اللون الذهبي
        scaffoldBackgroundColor: const Color(0xFF121212), // خلفية داكنة فاخرة
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Color(0xFFD4AF37),
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
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = false;
  bool _isUploading = false;
  final bool _isUserOnline = true; // حالة الاتصال
  bool _isTyping = false;     // حالة جاري الكتابة

  final String _currentUserId = "user_sadiq";
  final String _chatRoomId = "general_room";

  @override
  void initState() {
    super.initState();
    _msgController.addListener(() {
      if (_msgController.text.isNotEmpty && !_isTyping) {
        _updateTypingStatus(true);
      } else if (_msgController.text.isEmpty && _isTyping) {
        _updateTypingStatus(false);
      }
    });
  }

  void _updateTypingStatus(bool typing) {
    setState(() => _isTyping = typing);
  }

  void _startCall({required bool isVideo}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Row(
          children: [
            Icon(
              isVideo ? Icons.videocam : Icons.call,
              color: const Color(0xFFD4AF37),
            ),
            const SizedBox(width: 10),
            Text(
              isVideo ? 'مكالمة فيديو 👑' : 'مكالمة صوتية 👑',
              style: const TextStyle(color: Color(0xFFD4AF37)),
            ),
          ],
        ),
        content: Text(
          isVideo ? 'جاري الاتصال بالفيديو...' : 'جاري الاتصال الصوتي...',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إنهاء', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadAndSendMedia(File file, String type) async {
    setState(() => _isUploading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isUploading = false);
  }

  Future<void> _pickMedia(ImageSource source, bool isVideo) async {
    final XFile? media = isVideo 
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source, imageQuality: 70);
    if (media != null) {
      await _uploadAndSendMedia(File(media.path), isVideo ? 'video' : 'image');
    }
  }

  Future<void> _toggleAudioRecord() async {
    if (await _audioRecorder.hasPermission()) {
      if (_isRecording) {
        final path = await _audioRecorder.stop();
        setState(() => _isRecording = false);
        if (path != null) {
          await _uploadAndSendMedia(File(path), 'audio');
        }
      } else {
        final Directory dir = await getApplicationDocumentsDirectory();
        String filePath = '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: filePath,
        );
        setState(() => _isRecording = true);
      }
    }
  }

  void _sendTextMessage() {
    if (_msgController.text.trim().isEmpty) return;
    _msgController.clear();
    _updateTypingStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFD4AF37),
              child: Text('👑', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Al-Wazir Chat 👑',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _isTyping 
                      ? 'جاري الكتابة...' 
                      : (_isUserOnline ? 'متصل الآن 🟢' : 'غير متصل 🔴'),
                  style: TextStyle(
                    fontSize: 12, 
                    color: _isTyping ? const Color(0xFFD4AF37) : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Color(0xFFD4AF37)),
            onPressed: () => _startCall(isVideo: false),
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Color(0xFFD4AF37)),
            onPressed: () => _startCall(isVideo: true),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isUploading)
            const LinearProgressIndicator(color: Color(0xFFD4AF37)),

          Expanded(
            child: ListView(
              reverse: true,
              children: [
                _buildMessageBubble(
                  content: 'أهلاً بك في تطبيق الوزير شات الملكي 👑',
                  isMe: false,
                  type: 'text',
                  time: '10:00 م',
                  isRead: true,
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF1E1E1E),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Color(0xFFD4AF37)),
                  onPressed: () => _pickMedia(ImageSource.camera, false),
                ),
                IconButton(
                  icon: const Icon(Icons.photo, color: Color(0xFFD4AF37)),
                  onPressed: () => _pickMedia(ImageSource.gallery, false),
                ),
                IconButton(
                  icon: const Icon(Icons.videocam, color: Color(0xFFD4AF37)),
                  onPressed: () => _pickMedia(ImageSource.gallery, true),
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
                  onPressed: _sendTextMessage,
                ),
                GestureDetector(
                  onTap: _toggleAudioRecord,
                  child: CircleAvatar(
                    backgroundColor: _isRecording ? Colors.red : const Color(0xFFD4AF37),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      color: Colors.black,
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

  Widget _buildMessageBubble({
    required String content,
    required bool isMe,
    required String type,
    required String time,
    required bool isRead,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
            _buildMediaContent(type, content),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
                const SizedBox(width: 4),
                if (isMe)
                  Icon(
                    Icons.done_all,
                    size: 16,
                    color: isRead ? Colors.blue : Colors.grey,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent(String type, String content) {
    if (type == 'image') {
      return Image.network(content, height: 180, fit: BoxFit.cover);
    } else if (type == 'audio') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.audiotrack, color: Color(0xFFD4AF37)),
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            onPressed: () => _audioPlayer.play(UrlSource(content)),
          ),
          const Text('تسجيل صوتي', style: TextStyle(color: Colors.white)),
        ],
      );
    } else if (type == 'video') {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.videocam, color: Color(0xFFD4AF37)),
          SizedBox(width: 8),
          Text('فيديو', style: TextStyle(color: Colors.white)),
        ],
      );
    }
    return Text(content, style: const TextStyle(color: Colors.white, fontSize: 15));
  }
}
