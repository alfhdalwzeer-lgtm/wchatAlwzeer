import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // إضافة حالة جديدة مخصصة لمستخدمين محددين
  Future<void> addStatus({
    required String mediaUrl,
    required List<String> visibleToUserIds,
  }) async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) return;

    DateTime now = DateTime.now();
    DateTime expiresAt = now.add(const Duration(hours: 24));

    await _firestore.collection('statuses').add({
      'userId': uid,
      'mediaUrl': mediaUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': expiresAt.millisecondsSinceEpoch,
      'visibleTo': visibleToUserIds, // قائمة المعرفات المسموح لها بالمشاهدة
    });
  }

  // استعلام للحالات النشطة فقط (التي لم تنتهِ 24 ساعة)
  Stream<QuerySnapshot> getActiveStatuses() {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    int nowMillis = DateTime.now().millisecondsSinceEpoch;

    return _firestore
        .collection('statuses')
        .where('expiresAt', isGreaterThan: nowMillis)
        .where('visibleTo', arrayContains: uid)
        .snapshots();
  }
}
