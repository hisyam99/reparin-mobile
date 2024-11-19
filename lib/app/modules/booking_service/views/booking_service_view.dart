import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/booking_service_controller.dart';

class ServiceBookingView extends GetView<ServiceBookingController> {
  final String serviceType;
  final String providerName;
  final double price;

  const ServiceBookingView({
    super.key,
    required this.serviceType,
    required this.providerName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Book $serviceType',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Details Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Details',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Service Type:', serviceType),
                      _buildDetailRow('Provider:', providerName),
                      _buildDetailRow(
                          'Price:', '\$${price.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // User Details Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Details',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Name:',
                        controller.userProfile.value.name.value,
                      ),
                      _buildDetailRow(
                        'Phone:',
                        controller.userProfile.value.phone.value,
                      ),
                      _buildDetailRow(
                        'Email:',
                        controller.userProfile.value.email.value,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Service Description
              TextField(
                controller: controller.descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description of the problem',
                  border: OutlineInputBorder(),
                  hintText: 'Please describe the issue you are facing...',
                ),
              ),
              const SizedBox(height: 16),

              // Address
              TextField(
                controller: controller.addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Service Address',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the address for service...',
                ),
              ),
              const SizedBox(height: 24),

              // Book Now Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0093B7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (controller.addressController.text.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please enter service address',
                        snackPosition: SnackPosition.TOP,
                      );
                      return;
                    }

                    final success = await controller.createServiceOrder(
                      serviceType: serviceType,
                      providerName: providerName,
                      price: price,
                    );

                    if (success) {
                      Get.offAllNamed(
                          '/booksuccess'); // Navigate to home after success
                    }
                  },
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
