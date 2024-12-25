import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.toNamed('/admin-dashboard/add-service');
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.services.isEmpty) {
          return const Center(
            child: Text('No services available'),
          );
        }
        return ListView.builder(
          itemCount: controller.services.length,
          itemBuilder: (context, index) {
            final service = controller.services[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (service.image.isNotEmpty)
                    Image.network(
                      service.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ListTile(
                    title: Text(service.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Provider: ${service.provider}'),
                        Text('Price: \$${service.price.toStringAsFixed(2)}'),
                        Text('Address: ${service.address}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await controller.deleteService(service.id);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
