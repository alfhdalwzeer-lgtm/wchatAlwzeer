import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. حفظ جلسة الدخول لمنع الخروج التلقائي
  Future<void> setLoggedIn(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', status);
  }

  // 2. تحديث متصل / جاري الكتابة / آخر ظهور
  Future<void> updatePresence(bool isOnline, {bool isTyping = false}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'isOnline': isOnline,
        'isTyping': isTyping,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  // 3. إرسال رسالة مع صح الاستلام والقراءة (✓ sent, ✓✓ delivered, ✓✓ read)
  Future<void> sendMessage(String receiverId, String text) async {
    final user = _auth.currentUser;
    if (user == null) return;

    List<String> ids = [user.uid, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'senderId': user.uid,
      'receiverId': receiverId,
      'message': text,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'sent', // sent = ✓ , read = ✓✓ أزرق
    });
  }

  // 4. تحديث حالة الرسالة إلى مقروءة (✓✓ أزرق)
  Future<void> markAsRead(String chatRoomId, String messageId) async {
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .update({'status': 'read'});
  }

  // 5. إضافة حالة 24 ساعة
  Future<void> addStatus(String text) async {
    final user = _auth.currentUser;
    if (user != null) {
      final now = DateTime.now();
      await _firestore.collection('statuses').add({
        'userId': user.uid,
        'userPhone': user.phoneNumber ?? '',
        'text': text,
        'createdAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(now.add(const Duration(hours: 24))),
      });
    }
  }

  // 6. مزامنة جهات الاتصال
  Future<List<Contact>> syncContacts() async {
    if (await FlutterContacts.requestPermission()) {
      return await FlutterContacts.getContacts(withProperties: true);
    }
    return [];
  }
}
