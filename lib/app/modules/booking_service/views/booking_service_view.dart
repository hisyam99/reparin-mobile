import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:reparin_mobile/app/modules/booking_service/views/AddressSearchView.dart';
import 'package:reparin_mobile/app/modules/connection/controllers/connection_controller.dart';
import 'package:video_player/video_player.dart';
import '../controllers/booking_service_controller.dart';
import 'package:url_launcher/url_launcher.dart';


class ServiceBookingView extends GetView<ServiceBookingController> {
  final String serviceType;
  final String providerName;
  final double price;
  final double longitude;
  final double latitude;
  final String address;

  const ServiceBookingView({
    super.key,
    required this.serviceType,
    required this.providerName,
    required this.price,
    required this.longitude,
    required this.latitude,
    required this.address,
  });

  void openMap(double latitude, double longitude) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not open the map.';
    }
  }

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
        // if (controller.isLoading.value) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        // Add offline mode indicator
        return Stack(
          children: [
            Column(
              children: [
                // Show offline mode banner
                if (!Get.find<ConnectionController>().isConnected.value)
                  Container(
                    color: Colors.orange[100],
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: const [
                        Icon(Icons.cloud_off, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Offline Mode - Your booking will be saved locally and synced when online',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                _buildPendingOrdersIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Media Preview Section
              _buildMediaPreview(),
              const SizedBox(height: 16),

              // Open Map Button
              ElevatedButton.icon(
                onPressed: () => openMap(latitude, longitude),
                icon: const Icon(Icons.map),
                label: const Text('Open in Maps'),
              ),
              const SizedBox(height: 16),

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
                      _buildDetailRow('Address:', address),
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

              // Description TextField
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

              // Address TextField
              // Address TextField with Use Current Location Button
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Address',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller:
                            Get.find<ServiceBookingController>().addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Enter Address Manually',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => Get.find<ServiceBookingController>()
                                .useCurrentLocation(),
                            icon: const Icon(Icons.location_on),
                            label: const Text('Use Current Location'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () => Get.to(() => AddressSearchView(
                                  onAddressSelected: (selectedAddress) {
                                    Get.find<ServiceBookingController>()
                                        .addressController
                                        .text = selectedAddress;
                                    Get.back();
                                  },
                                )),
                            icon: const Icon(Icons.search),
                            label: const Text('Search Address'),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                    // Validate if the address field is empty
                    if (Get.find<ServiceBookingController>()
                        .addressController
                        .text
                        .isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please enter a service address',
                        snackPosition: SnackPosition.TOP,
                      );
                      return;
                    }

                    // Proceed with creating the service order
                    final success = await controller.createServiceOrder(
                      serviceType: serviceType,
                      providerName: providerName,
                      price: price,
                    );

                    if (success) {
                      Get.offAllNamed('/booksuccess');
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
              ),
            ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMediaPreview() {
    return Center(
      child: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: controller.imageFile.value != null ||
                controller.videoFile.value != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: controller.imageFile.value != null
                    ? Stack(
                        children: [
                          SizedBox.expand(
                            child: Image.file(
                              controller.imageFile.value!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.0),
                                    Colors.black.withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              onPressed: () {
                                controller.imageFile.value = null;
                                controller.update();
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ValueListenableBuilder<VideoPlayerValue>(
                        valueListenable:
                            controller.videoPlayerController.value!,
                        builder: (context, videoState, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox.expand(
                                child: AspectRatio(
                                  aspectRatio: videoState.aspectRatio,
                                  child: VideoPlayer(
                                      controller.videoPlayerController.value!),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    videoState.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (videoState.isPlaying) {
                                      controller.videoPlayerController.value!
                                          .pause();
                                    } else {
                                      controller.videoPlayerController.value!
                                          .play();
                                    }
                                  },
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  onPressed: () {
                                    controller.videoFile.value = null;
                                    controller.videoPlayerController.value
                                        ?.dispose();
                                    controller.videoPlayerController.value =
                                        null;
                                    controller.update();
                                  },
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add Photo/Video',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
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

Widget _buildPendingOrdersIndicator() {
  return Obx(() {
    final controller = Get.find<ServiceBookingController>();
    if (controller.pendingOrdersCount.value > 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.orange[100],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.pending_actions, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  '${controller.pendingOrdersCount.value} pending orders will sync when online',
                  style: const TextStyle(color: Colors.orange),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  });
}