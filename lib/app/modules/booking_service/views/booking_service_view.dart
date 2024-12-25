// File 1: /lib/app/modules/booking_service/views/booking_service_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reparin_mobile/app/modules/address_search/views/address_search_view.dart';
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
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Book $serviceType',
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!Get.find<ConnectionController>().isConnected.value)
                      _buildOfflineBanner(),
                    const SizedBox(height: 8),
                    _buildPendingOrdersIndicator(),
                    const SizedBox(height: 16),
                    _buildMediaSection(context),
                    const SizedBox(height: 16),
                    _buildServiceDetailsSection(context),
                    const SizedBox(height: 16),
                    _buildUserDetailsSection(context),
                    const SizedBox(height: 16),
                    _buildDescriptionField(context),
                    const SizedBox(height: 16),
                    _buildAddressSection(context),
                    const SizedBox(height: 24),
                    _buildBookNowButton(),
                  ],
                ),
              ),
              if (controller.isLoading.value)
                const Positioned.fill(
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      color: Colors.orange[100],
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: const [
          Icon(Icons.cloud_off, color: Colors.orange),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Offline Mode - Your booking will be saved locally and synced when online',
              style: TextStyle(color: Colors.orange, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingOrdersIndicator() {
    return Obx(() {
      final controller = Get.find<ServiceBookingController>();
      if (controller.pendingOrdersCount.value > 0) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.pending_actions, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                '${controller.pendingOrdersCount.value} pending orders will sync when online',
                style: const TextStyle(color: Colors.orange, fontSize: 14),
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildMediaSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Media',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildMediaPreview(),
        const SizedBox(height: 16),
        _buildOpenMapButton(),
      ],
    );
  }

  Widget _buildMediaPreview() {
    return GestureDetector(
      onTap: () => controller.showMediaPicker(Get.context!),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: controller.imageFile.value != null ||
                controller.videoFile.value != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: controller.imageFile.value != null
                    ? _buildImagePreview()
                    : _buildVideoPreview(),
              )
            : _buildAddMediaPlaceholder(),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
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
    );
  }

  Widget _buildVideoPreview() {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller.videoPlayerController.value!,
      builder: (context, videoState, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: AspectRatio(
                aspectRatio: videoState.aspectRatio,
                child: VideoPlayer(controller.videoPlayerController.value!),
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
                  videoState.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (videoState.isPlaying) {
                    controller.videoPlayerController.value!.pause();
                  } else {
                    controller.videoPlayerController.value!.play();
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
                  controller.videoPlayerController.value?.dispose();
                  controller.videoPlayerController.value = null;
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
    );
  }

  Widget _buildAddMediaPlaceholder() {
    return Column(
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
    );
  }

  Widget _buildOpenMapButton() {
    return ElevatedButton.icon(
      onPressed: () => openMap(latitude, longitude),
      icon: const Icon(Icons.map, color: Colors.white),
      label: const Text('Open in Maps'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  Widget _buildServiceDetailsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Details',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildServiceDetailsCard(context),
      ],
    );
  }

  Widget _buildServiceDetailsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Service Type', serviceType),
            const SizedBox(height: 8),
            _buildDetailRow('Provider', providerName),
            const SizedBox(height: 8),
            _buildDetailRow('Price', '\$${price.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildDetailRow('Address', address),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Details',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildUserDetailsCard(context),
      ],
    );
  }

  Widget _buildUserDetailsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Name', controller.userProfile.value.name.value),
            const SizedBox(height: 8),
            _buildDetailRow('Phone', controller.userProfile.value.phone.value),
            const SizedBox(height: 8),
            _buildDetailRow('Email', controller.userProfile.value.email.value),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Please describe the issue you are facing...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Address',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller:
                      Get.find<ServiceBookingController>().addressController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Enter Address Manually',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Get.find<ServiceBookingController>()
                            .useCurrentLocation(),
                        icon:
                            const Icon(Icons.location_on, color: Colors.white),
                        label: const Text('Use Current Location'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Get.to(() => AddressSearchView(
                              onAddressSelected: (selectedAddress) {
                                Get.find<ServiceBookingController>()
                                    .addressController
                                    .text = selectedAddress;
                                Get.back();
                              },
                            )),
                        icon: const Icon(Icons.search, color: Colors.white),
                        label: const Text('Search Address'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookNowButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: () async {
          if (Get.find<ServiceBookingController>()
              .addressController
              .text
              .isEmpty) {
            Get.snackbar(
              'Error',
              'Please enter a service address',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }
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
    );
  }
}
