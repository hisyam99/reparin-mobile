// File 3: /lib/app/modules/popular_service/views/popular_service_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reparin_mobile/app/modules/popular_service/controllers/popular_service__controller.dart';
import 'package:reparin_mobile/app/routes/app_pages.dart';
import '../../service/controllers/service_controller.dart';

class PopularServiceView extends GetView<PopularServiceController> {
  const PopularServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceController serviceController = Get.find<ServiceController>();
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
          'Popular Services',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await serviceController.fetchServices();
          // The serviceList will be updated automatically through the ever listener
        },
        child: Obx(() {
          if (controller.serviceList.isEmpty) {
            return const Center(
              child: Text('No services available'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: controller.serviceList.length,
            itemBuilder: (context, index) {
              final item = controller.serviceList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 2.0,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: item.image.isNotEmpty
                        ? Image.network(
                            item.image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/default_repair.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/default_repair.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                  ),
                  title: Text(
                    item.title,
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
                        '\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.address,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Use named route with arguments
                    Get.toNamed(
                      Routes.SERVICEBOOKING,
                      arguments: {
                        'serviceType': item.title,
                        'providerName': item.provider,
                        'price': item.price,
                        'address': item.address,
                      },
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(
                      item.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: item.isBookmarked ? Colors.blue : null,
                    ),
                    onPressed: () => controller.toggleBookmark(item.id),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}