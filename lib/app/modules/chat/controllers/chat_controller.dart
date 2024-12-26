// File 1: /lib/app/modules/chat/controllers/chat_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/chat_message_model.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final messageController = TextEditingController();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxString userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    userId.value = _auth.currentUser?.uid ?? '';
    fetchMessages();
  }

  void fetchMessages() {
    _firestore
        .collection('chat_messages')
        .where('serviceId', isEqualTo: Get.parameters['serviceId'])
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .where((message) =>
              message.senderId == userId.value ||
              message.receiverId == userId.value ||
              message.senderId == 'admin' ||
              message.receiverId == 'admin')
          .toList();
    });
  }

  void sendMessage(String serviceId, String receiverId) {
    final message = messageController.text.trim();
    if (message.isNotEmpty) {
      final newMessage = ChatMessage(
        id: _firestore.collection('chat_messages').doc().id,
        senderId: userId.value,
        receiverId: receiverId,
        message: message,
        timestamp: Timestamp.now(),
        serviceId: serviceId,
      );
      _firestore
          .collection('chat_messages')
          .doc(newMessage.id)
          .set(newMessage.toJson())
          .then((_) {
        messageController.clear();
      }).catchError((error) {
        Get.snackbar('Error', 'Failed to send message: $error');
      });
    }
  }

  void sendAdminMessage(String serviceId, String userId, String message) {
    if (message.isNotEmpty) {
      final newMessage = ChatMessage(
        id: _firestore.collection('chat_messages').doc().id,
        senderId: 'admin',
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
        messageController.clear();
        Get.snackbar('Success', 'Message sent successfully');
      }).catchError((error) {
        Get.snackbar('Error', 'Failed to send message: $error');
      });
    }
  }
}
