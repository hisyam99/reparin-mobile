// File 11: /lib/app/modules/selected_location/views/selected_location_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/selected_location_controller.dart';
import '../../booking_service/controllers/booking_service_controller.dart';
import '../../booking_service/views/booking_service_view.dart';

class SelectedLocationView extends GetView<SelectedLocationController> {
  const SelectedLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location: ${controller.selectedLocation}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.reloadServices(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.serviceList.isEmpty) {
          return const Center(
            child: Text('No services available in this location'),
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
                  Get.to(
                    () => ServiceBookingView(
                      serviceType: item.title,
                      providerName: item.provider,
                      price: item.price,
                      longitude: item.longitude,
                      latitude: item.latitude,
                      address: item.address,
                    ),
                    binding: BindingsBuilder(() {
                      Get.lazyPut(() => ServiceBookingController());
                    }),
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
