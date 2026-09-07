import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. حفظ جلسة التسجيل محلياً لمنع الخروج التلقائي
  Future<void> keepUserLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
  }

  // 2. تحديث حالة المتصل، وجاري الكتابة، وآخر ظهور
  Future<void> updatePresence({required bool isOnline, bool isTyping = false}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'isOnline': isOnline,
        'isTyping': isTyping,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  // 3. إرسال الرسائل مع حالة التسليم (✓ sent, ✓✓ delivered, ✓✓ read)
  Future<void> sendMessage(String receiverId, String messageText) async {
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
      'message': messageText,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'sent', // 'sent' = ✓, 'delivered' = ✓✓, 'read' = ✓✓ (blue)
    });
  }

  // 4. تحديث الرسائل إلى قُدِمَت / قُرِئَت (✓✓ أزرق)
  Future<void> markAsRead(String chatRoomId, String messageDocId) async {
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageDocId)
        .update({'status': 'read'});
  }

  // 5. إضافة حالة (Story) تنتهي تلقائياً بعد 24 ساعة
  Future<void> postStatus(String textContent, {String imageUrl = ''}) async {
    final user = _auth.currentUser;
    if (user != null) {
      final now = DateTime.now();
      final expiryTime = now.add(const Duration(hours: 24));

      await _firestore.collection('statuses').add({
        'userId': user.uid,
        'userPhone': user.phoneNumber ?? '',
        'text': textContent,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(expiryTime),
      });
    }
  }

  // 6. جلب الحالات النشطة فقط (خلال الـ 24 ساعة الماضية)
  Stream<QuerySnapshot> getActiveStatuses() {
    return _firestore
        .collection('statuses')
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .orderBy('expiresAt', descending: true)
        .snapshots();
  }
}
