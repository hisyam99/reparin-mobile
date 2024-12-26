// File 3: /lib/app/modules/bookmark/views/bookmark_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bookmark_controller.dart';
import '../../service/controllers/service_controller.dart';
import 'package:reparin_mobile/app/modules/navbar/views/navbar_view.dart'; // Assuming the custom navigation bar exists

class BookmarkView extends GetView<BookmarkController> {
  const BookmarkView({super.key});

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
          'Bookmark',
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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.bookmarkedServices.isEmpty) {
          return const Center(child: Text('No bookmarked services'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.bookmarkedServices.length,
          itemBuilder: (context, index) {
            final service = controller.bookmarkedServices[index];
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
                  child: service.image.isNotEmpty
                      ? Image.network(
                          service.image,
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
                  service.title,
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
                      'Price: \$${service.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Provider: ${service.provider}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Address: ${service.address}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.bookmark,
                    color: service.isBookmarked ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () => serviceController.toggleBookmark(service.id),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: const CustomBottomNavigationBar(), // Custom bottom navigation bar
    );
  }
}