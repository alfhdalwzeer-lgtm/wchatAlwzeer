import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_service.dart';

class StatusScreen extends StatelessWidget {
  final ChatService _chatService = ChatService();
  final TextEditingController _statusController = TextEditingController();

  StatusScreen({super.key});

  void _addStatus(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة حالة جديدة (24 ساعة)'),
        content: TextField(
          controller: _statusController,
          decoration: const InputDecoration(hintText: 'اكتب حالتك هنا...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_statusController.text.isNotEmpty) {
                _chatService.postStatus(_statusController.text);
                _statusController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('نشر'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحالات'),
        backgroundColor: const Color(0xFF075E54),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatService.getActiveStatuses(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('لا توجد حالات نشطة حالياً'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.person, color: Colors.black),
                ),
                title: Text(data['userPhone'] ?? 'مستخدم'),
                subtitle: Text(data['text'] ?? ''),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFD700),
        onPressed: () => _addStatus(context),
        child: const Icon(Icons.edit, color: Colors.black),
      ),
    );
  }
}
