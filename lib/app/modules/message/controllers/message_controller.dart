// File 1: /lib/app/modules/message/controllers/message_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/chat_message_model.dart';

class MessageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxMap<String, Map<String, dynamic>> messageList =
      <String, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
  }

  void fetchMessages() {
    _firestore
        .collection('chat_messages')
        .where('senderId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((snapshot) {
      final Map<String, Map<String, dynamic>> groupedMessages = {};
      for (var doc in snapshot.docs) {
        final message = ChatMessage.fromFirestore(doc);
        if (!groupedMessages.containsKey(message.serviceId)) {
          final serviceIdParts = message.serviceId.split('_');
          final title = serviceIdParts[1];
          final provider = serviceIdParts[2];
          groupedMessages[message.serviceId] = {
            'serviceId': message.serviceId,
            'title': title,
            'provider': provider,
            'lastMessage': message.message,
            'timestamp': message.timestamp,
          };
        } else {
          if (message.timestamp.millisecondsSinceEpoch >
              groupedMessages[message.serviceId]!['timestamp']
                  .millisecondsSinceEpoch) {
            groupedMessages[message.serviceId]!['lastMessage'] =
                message.message;
            groupedMessages[message.serviceId]!['timestamp'] =
                message.timestamp;
          }
        }
      }
      messageList.value = groupedMessages;
    });
  }
}
