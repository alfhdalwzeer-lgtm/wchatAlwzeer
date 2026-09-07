import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_service.dart';

class StatusScreen extends StatelessWidget {
  final ChatService _chatService = ChatService();
  final TextEditingController _statusController = TextEditingController();

  StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحالات (24 ساعة)'),
        backgroundColor: const Color(0xFF075E54),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('statuses')
            .where('expiresAt', isGreaterThan: Timestamp.now())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(data['userPhone'] ?? 'مستخدم'),
                subtitle: Text(data['text'] ?? ''),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('إضافة حالة جديدة'),
              content: TextField(controller: _statusController),
              actions: [
                TextButton(
                  onPressed: () {
                    _chatService.addStatus(_statusController.text);
                    _statusController.clear();
                    Navigator.pop(ctx);
                  },
                  child: const Text('نشر'),
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
