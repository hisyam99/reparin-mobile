import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/services/location_controller.dart';
import '../../microphone/controllers/microphone_controller.dart';
import '../../maps/controllers/maps_controller.dart'; // Import MapsController

class GetConnectView extends GetView<GetConnectController> {
  const GetConnectView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final MicrophoneController micController = Get.put(MicrophoneController());
    final MapsController mapsController = Get.put(MapsController());

    // Function to open Google Maps with the provided coordinates
    void openMap(double latitude, double longitude) async {
      final Uri url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not open the map.';
      }
    }

    // Function to perform the search based on the query
    void performSearch(String query) {
      if (query.isNotEmpty) {
        controller.searchAddress(query);
      }
    }

    // Function to use the current location for searching
    void useCurrentLocation() {
      mapsController.getCurrentLocation().then((_) {
        final position = mapsController.currentPosition.value;
        if (position != null) {
          final query = "${position.latitude},${position.longitude}";
          searchController.text = query;
          performSearch(query);
        }
      });
    }

    void onAddressSelected(String selectedAddress) {
      searchController.text = selectedAddress;
      performSearch(selectedAddress);
      Get.toNamed(
        '/selected-location',
        arguments: selectedAddress,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian Alamat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          // Google Maps button in the top-right corner
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              final position = mapsController.currentPosition.value;
              if (position != null) {
                openMap(position.latitude, position.longitude);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama lokasi...',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: () async {
                        micController.startListening();
                        micController.currentText.listen((text) {
                          searchController.text = text;
                          if (micController.isListening.isFalse &&
                              text.isNotEmpty) {
                            performSearch(text);
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => performSearch(searchController.text),
                    ),
                  ],
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: performSearch,
              textInputAction: TextInputAction.search,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: useCurrentLocation,
              child: const Text('Gunakan Lokasi Sekarang'),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (controller.addresses.isEmpty) {
              return const Center(
                child: Text('Tidak ada hasil pencarian.'),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.addresses.length,
                  itemBuilder: (context, index) {
                    final address = controller.addresses[index];
                    return ListTile(
                      title: Text(address.displayName),
                      subtitle: Text(
                        '${address.address.city ?? address.address.village ?? 'N/A'}, ${address.address.country}',
                      ),
                      onTap: () => onAddressSelected(address.displayName),
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
