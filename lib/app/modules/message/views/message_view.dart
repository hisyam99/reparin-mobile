// File 2: /lib/app/modules/message/views/message_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/message_controller.dart';
import '../../chat/views/chat_view.dart';
import '../../chat/bindings/chat_binding.dart';

class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Messages',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Add search functionality if required
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.messageList.isEmpty) {
          return const Center(child: Text('No messages yet.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.messageList.length,
          itemBuilder: (context, index) {
            final serviceId = controller.messageList.keys.elementAt(index);
            final message = controller.messageList[serviceId]!;
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 2.0,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const Icon(Icons.message,
                    color: Colors
                        .blue), // You can replace this with an image if you have one
                title: Text(
                  message['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Last Message: ${message['lastMessage']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message['provider'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  message['timestamp'].toDate().toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  Get.to(
                    () => ChatView(
                      serviceId: message['serviceId'],
                      receiverId: 'provider_${message['provider']}',
                    ),
                    binding: ChatBinding(),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
