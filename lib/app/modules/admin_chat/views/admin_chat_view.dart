// File 2: /lib/app/modules/admin_chat/views/admin_chat_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_chat_controller.dart';
import '../../chat/views/chat_view.dart';
import '../../chat/bindings/chat_binding.dart';

class AdminChatView extends GetView<AdminChatController> {
  const AdminChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All User Chats'),
      ),
      body: Obx(() {
        if (controller.serviceChats.isEmpty) {
          return const Center(child: Text('No chats yet.'));
        }
        return ListView.builder(
          itemCount: controller.serviceChats.length,
          itemBuilder: (context, index) {
            final serviceId = controller.serviceChats.keys.elementAt(index);
            final lastMessage = controller.serviceChats[serviceId]!.isNotEmpty
                ? controller.serviceChats[serviceId]!.first.message
                : 'No messages';
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text('Service: $serviceId'),
                subtitle: Text('Last Message: $lastMessage'),
                onTap: () {
                  Get.to(
                    () => UserChatsView(serviceId: serviceId),
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

class UserChatsView extends GetView<AdminChatController> {
  final String serviceId;
  UserChatsView({required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats for Service: $serviceId'),
      ),
      body: Obx(() {
        if (!controller.userChats.containsKey(serviceId) ||
            controller.userChats[serviceId]!.isEmpty) {
          return const Center(child: Text('No user chats for this service.'));
        }
        return ListView.builder(
          itemCount: controller.userChats[serviceId]!.length,
          itemBuilder: (context, index) {
            final userId =
                controller.userChats[serviceId]!.keys.elementAt(index);
            final lastMessage =
                controller.userChats[serviceId]![userId]!.isNotEmpty
                    ? controller.userChats[serviceId]![userId]!.first.message
                    : 'No messages';
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text('User: $userId'),
                subtitle: Text('Last Message: $lastMessage'),
                onTap: () {
                  Get.to(
                    () => ChatView(
                      serviceId: serviceId,
                      receiverId: userId,
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
