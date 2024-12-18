import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/location_controller.dart';

class AddressSearchView extends StatelessWidget {
  final Function(String) onAddressSelected;

  AddressSearchView({super.key, required this.onAddressSelected});
   final GetConnectController controller = Get.put(GetConnectController());

  @override
  Widget build(BuildContext context) {
    final GetConnectController controller = Get.find<GetConnectController>();
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Address'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Enter address',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    final query = searchController.text.trim();
                    if (query.isNotEmpty) {
                      await controller.searchAddress(query);
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.addresses.isEmpty) {
                return const Center(child: Text('No addresses found.'));
              }
              return ListView.builder(
                itemCount: controller.addresses.length,
                itemBuilder: (context, index) {
                  final address = controller.addresses[index];
                  return ListTile(
                    title: Text(address.displayName),
                    onTap: () {
                      onAddressSelected(address.displayName);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
