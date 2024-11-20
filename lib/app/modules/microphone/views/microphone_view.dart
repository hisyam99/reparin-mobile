import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/microphone_controller.dart';

class MicrophoneView extends GetView<MicrophoneController> {
  const MicrophoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech to Text"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Clear All'),
                  content: const Text(
                      'Are you sure you want to clear all saved texts?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.clearAllSavedTexts();
                        Get.back();
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Current Speech Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Current Speech",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                          controller.currentText.value,
                          style: const TextStyle(fontSize: 16),
                        )),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => ElevatedButton.icon(
                              onPressed: controller.isListening.value
                                  ? controller.stopListening
                                  : controller.startListening,
                              icon: Icon(controller.isListening.value
                                  ? Icons.stop
                                  : Icons.mic),
                              label: Text(controller.isListening.value
                                  ? "Stop"
                                  : "Start"),
                            )),
                        ElevatedButton.icon(
                          onPressed: controller.saveCurrentText,
                          icon: const Icon(Icons.save),
                          label: const Text("Save"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Saved Texts List
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Saved Texts",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Obx(() => ListView.builder(
                              itemCount: controller.savedTexts.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  key: UniqueKey(),
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 16),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (_) {
                                    controller.deleteSavedText(index);
                                  },
                                  child: ListTile(
                                    title: Text(
                                      controller.savedTexts[index],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    trailing: const Icon(Icons.swipe_left),
                                  ),
                                );
                              },
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
