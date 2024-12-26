import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reparin_mobile/app/modules/navbar/views/navbar_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/profile_controller.dart';
import '../../../data/services/authentication/controllers/authentication_controller.dart';

class ProfileViews extends GetView<ProfileController> {
  const ProfileViews({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationController authController =
        Get.find<AuthenticationController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        final imagePath = controller.profile.value.imagePath.value;
        final name = controller.profile.value.name.value;
        return Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture with CachedNetworkImage
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imagePath.isNotEmpty
                            ? CachedNetworkImageProvider(imagePath)
                            : const AssetImage('assets/default_avatar.png')
                                as ImageProvider,
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
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text('Choose from Gallery'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        controller.updateProfileImage();
                                      },
                                    ),
                                    if (imagePath.isNotEmpty)
                                      ListTile(
                                        leading: const Icon(Icons.delete,
                                            color: Colors.red),
                                        title: const Text('Remove Photo',
                                            style:
                                                TextStyle(color: Colors.red)),
                                        onTap: () {
                                          Navigator.pop(context);
                                          controller.deleteProfileImage();
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
            const SizedBox(height: 10),
            // Display Name
            name.isEmpty
                ? const SizedBox(
                    height: 20,
                    width: 150,
                    child: Center(
                      child: LinearProgressIndicator(),
                    ),
                  )
                : Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            const SizedBox(height: 5),
            // Display Email
            Text(
              controller.profile.value.email.value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            // Profile Options List
            Expanded(
              child: ListView(
                children: [
                  _buildProfileOption(
                    context,
                    title: 'Your Profile',
                    icon: Icons.person,
                    onTap: () {
                      Get.toNamed('/profile/edit');
                    },
                  ),
                  _buildProfileOption(
                    context,
                    title: 'My Bookings',
                    icon: Icons.calendar_today,
                    onTap: () {
                      Get.toNamed('/bookupcoming');
                    },
                  ),
                  _buildProfileOption(
                    context,
                    title: 'Settings',
                    icon: Icons.settings,
                    onTap: () {
                      Get.toNamed('/settings');
                    },
                  ),
                  _buildProfileOption(
                    context,
                    title: 'Help Center',
                    icon: Icons.help_outline,
                    onTap: () {
                      Get.toNamed('/help_center_faq');
                    },
                  ),
                  _buildProfileOption(
                    context,
                    title: 'Sign Out',
                    icon: Icons.logout,
                    onTap: () {
                      authController.logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget _buildProfileOption(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
