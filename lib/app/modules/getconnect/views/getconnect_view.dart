import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/getconnect_controller.dart';
import '../../microphone/controllers/microphone_controller.dart';

class GetConnectView extends GetView<GetConnectController> {
  const GetConnectView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final MicrophoneController micController = Get.put(MicrophoneController());

    void performSearch(String query) {
      if (query.isNotEmpty) {
        controller.searchAddress(query);
      }
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
