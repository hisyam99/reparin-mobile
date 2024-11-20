import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Define jingle options
    final jingleOptions = {
      'Jingle 1': 'https://www.myinstants.com/media/sounds/ta-dah-notification.mp3',
      'Jingle 2': 'https://www.myinstants.com/media/sounds/yt1s_nijLeKo.mp3',
      'Jingle 3': 'https://www.myinstants.com/media/sounds/thick-of-it-villager.mp3',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Jingle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Obx(() => Column(
              children: [
                // Predefined jingle options
                ...jingleOptions.entries.map((entry) => 
                  RadioListTile(
                    title: Text(entry.key),
                    value: entry.value,
                    groupValue: controller.jingleUrl.value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateJingleUrl(value);
                      }
                    },
                  )
                ).toList(),
                
                // Custom URL option
                RadioListTile(
                  title: const Text('Custom URL'),
                  value: 'custom',
                  groupValue: controller.jingleUrl.value == '' ? 'custom' : '',
                  onChanged: (_) {
                    _showCustomUrlDialog(context);
                  },
                ),
              ],
            )),
            
            // Show current selected jingle
            Obx(() {
              final currentUrl = controller.jingleUrl.value;
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Current Jingle URL: $currentUrl'),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showCustomUrlDialog(BuildContext context) {
    final TextEditingController urlController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Custom Jingle URL'),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(
            hintText: 'Enter audio URL',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (urlController.text.isNotEmpty) {
                controller.updateJingleUrl(urlController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}