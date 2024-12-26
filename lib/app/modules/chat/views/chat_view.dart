// File 2: /lib/app/modules/chat/views/chat_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  final String serviceId;
  final String receiverId;

  ChatView({required this.serviceId, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${receiverId.split('_')[1]}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(child: Text('No messages yet.'));
              }
              return ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isSender = message.senderId == controller.userId ||
                      message.senderId == 'admin';
                  return Align(
                    alignment:
                        isSender ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isSender ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: isSender
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.message,
                            style: TextStyle(
                                color: isSender ? Colors.white : Colors.black),
                          ),
                          Text(
                            message.timestamp.toDate().toString(),
                            style: TextStyle(
                                fontSize: 10,
                                color: isSender ? Colors.white70 : Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    decoration:
                        const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (controller.userId == 'admin') {
                      controller.sendAdminMessage(serviceId, receiverId,
                          controller.messageController.text.trim());
                    } else {
                      controller.sendMessage(serviceId, receiverId);
                    }
                    controller.messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
