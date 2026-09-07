import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isRecording = false;

  void _updateTyping(bool typing) {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) return;
    FirebaseFirestore.instance.collection('chats').doc(widget.chatId).set({
      'typing_$uid': typing,
    }, SetOptions(merge: true));
  }

  void _sendMessage(String text, {String type = 'text'}) async {
    if (text.trim().isEmpty && type == 'text') return;
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    _controller.clear();
    _updateTyping(false);

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'senderId': uid,
      'text': text,
      'type': type,
      'status': 'sent', // sent = ✅, read = ✅✅
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Widget _buildStatusIcon(String status) {
    if (status == 'read') {
      return const Icon(Icons.done_all, size: 16, color: Colors.blue);
    } else if (status == 'delivered') {
      return const Icon(Icons.done_all, size: 16, color: Colors.grey);
    }
    return const Icon(Icons.check, size: 16, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.receiverName, style: const TextStyle(fontSize: 16)),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(widget.receiverId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                bool isOnline = snapshot.data?.get('isOnline') ?? false;
                return Text(
                  isOnline ? "متصل الآن" : "آخر ظهور قريباً",
                  style: TextStyle(fontSize: 11, color: isOnline ? Colors.green : Colors.grey),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                var docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    var data = docs[i].data() as Map<String, dynamic>;
                    bool isMe = data['senderId'] == FirebaseAuth.instance.currentUser?.uid;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? const Color(0xFF2C2C2E) : const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFFD700), width: 0.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(data['text'] ?? '', style: const TextStyle(color: Colors.white)),
                            const SizedBox(width: 5),
                            if (isMe) _buildStatusIcon(data['status'] ?? 'sent'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(isRecording ? Icons.stop : Icons.mic, color: const Color(0xFFFFD700)),
                  onPressed: () {
                    setState(() => isRecording = !isRecording);
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (v) => _updateTyping(v.isNotEmpty),
                    decoration: const InputDecoration(
                      hintText: "اكتب رسالة...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: const Color(0xFFFFD700)),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
