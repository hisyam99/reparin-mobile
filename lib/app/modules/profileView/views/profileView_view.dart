import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../controllers/profileView_controller.dart';

class ProfileViewView extends GetView<ProfileViewController> {
  const ProfileViewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.profile.value.name.value.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          controller.nameController.text = controller.profile.value.name.value;
          controller.phoneController.text =
              controller.profile.value.phone.value;
          controller.emailController.text =
              controller.profile.value.email.value;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with back button
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Get.back(),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Your Profile',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Profile Picture with loading state
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: controller.profile.value.imagePath
                                          .value.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(controller
                                              .profile.value.imagePath.value),
                                          fit: BoxFit.cover,
                                        )
                                      : const DecorationImage(
                                          image: AssetImage(
                                              'assets/default_avatar.png'),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey[200],
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SafeArea(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.photo_library),
                                                  title: const Text(
                                                      'Choose from Gallery'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    controller
                                                        .updateProfileImage();
                                                  },
                                                ),
                                                if (controller.profile.value
                                                    .imagePath.value.isNotEmpty)
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red),
                                                    title: const Text(
                                                        'Remove Photo',
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      controller
                                                          .deleteProfileImage();
                                                    },
                                                  ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Name Field
                        const Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.nameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your name',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) {
                            controller.profile.update((val) {
                              if (val != null) val.name.value = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        // Phone Number Field
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.phoneController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your phone number',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) {
                            controller.profile.update((val) {
                              if (val != null) val.phone.value = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        // Email Field
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.emailController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          readOnly:
                              true, // Email shouldn't be editable as it's tied to Firebase Auth
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Update Button
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final success = await controller.updateProfile();
                          if (success) {
                            Get.snackbar(
                              'Success',
                              'Profile updated successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.withOpacity(0.1),
                              colorText: Colors.green,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0083B3),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Update'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
