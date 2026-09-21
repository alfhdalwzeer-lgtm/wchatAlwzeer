cd ~/wchatAlwzeerPro
cat > lib/models/message_model.dart <<'EOF'
class MessageModel {
  final int? id;

  // معرف المحادثة حتى لا تختلط رسائل المستخدمين
  final String chatId;

  final String text;
  final bool isMe;
  final String time;
  final bool isRead;

  // نوع الرسالة: text / image / file
  final String type;

  // مسار الصورة أو الملف على الجهاز
  final String? filePath;

  // اسم الملف عند إرسال مستند
  final String? fileName;

  MessageModel({
    this.id,
    required this.chatId,
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = false,
    this.type = 'text',
    this.filePath,
    this.fileName,
  });
}
EOF
