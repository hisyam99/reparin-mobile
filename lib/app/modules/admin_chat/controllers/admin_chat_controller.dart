// File 1: /lib/app/modules/admin_chat/controllers/admin_chat_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/chat_message_model.dart';

class AdminChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxMap<String, List<ChatMessage>> serviceChats =
      <String, List<ChatMessage>>{}.obs;
  final RxMap<String, Map<String, List<ChatMessage>>> userChats =
      <String, Map<String, List<ChatMessage>>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChats();
  }

  void fetchChats() {
    _firestore
        .collection('chat_messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      serviceChats.clear();
      userChats.clear();
      for (var doc in snapshot.docs) {
        final message = ChatMessage.fromFirestore(doc);
        if (!serviceChats.containsKey(message.serviceId)) {
          serviceChats[message.serviceId] = [];
        }
        serviceChats[message.serviceId]!.add(message);

        if (!userChats.containsKey(message.serviceId)) {
          userChats[message.serviceId] = {};
        }
        if (!userChats[message.serviceId]!.containsKey(message.senderId)) {
          userChats[message.serviceId]![message.senderId] = [];
        }
        userChats[message.serviceId]![message.senderId]!.add(message);
      }
      serviceChats.refresh();
      userChats.refresh();
    });
  }

  void sendAdminMessage(String serviceId, String userId, String message) {
    final newMessage = ChatMessage(
      id: _firestore.collection('chat_messages').doc().id,
      senderId: 'admin', // Assuming admin's ID is 'admin'
      receiverId: userId,
      message: message,
      timestamp: Timestamp.now(),
      serviceId: serviceId,
    );
    _firestore
        .collection('chat_messages')
        .doc(newMessage.id)
        .set(newMessage.toJson())
        .then((_) {
      Get.snackbar('Success', 'Message sent successfully');
    }).catchError((error) {
      Get.snackbar('Error', 'Failed to send message: $error');
    });
  }
}
