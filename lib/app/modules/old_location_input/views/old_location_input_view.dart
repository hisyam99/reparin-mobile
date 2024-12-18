import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/old_location_input_controller.dart';

class LocationInputView extends GetView<LocationInputController> {
  const LocationInputView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Enter Your Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search input field
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search for a location...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: controller.clearSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: controller.onSearchChanged,
            ),
            const SizedBox(height: 16),
            // Use current location button
            InkWell(
              onTap: () {
                controller.useCurrentLocation();
                controller.searchController.text = 'Current Location';
              },
              child: const Row(
                children: [
                  Icon(Icons.my_location, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Use my current location', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Search results
            Obx(() {
              if (controller.searchResults.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final location = controller.searchResults[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(location.name),
                        subtitle: Text(location.address),
                        onTap: () => controller.selectLocation(controller.searchResults[index]),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
