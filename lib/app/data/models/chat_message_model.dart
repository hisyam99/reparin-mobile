import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String serviceId;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.serviceId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': timestamp,
        'serviceId': serviceId,
      };

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'] as Timestamp,
      serviceId: data['serviceId'] ?? '',
    );
  }
}
