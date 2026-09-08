enum MessageStatus { sent, delivered, read }

class Message {
  final String id;
  final String senderId;
  final String text;
  final String? mediaUrl;
  final DateTime timestamp;
  final MessageStatus status;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    this.mediaUrl,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });
}
