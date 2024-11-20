import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reparin_mobile/app/modules/navbar/views/navbar_view.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import the package
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
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: imagePath.isNotEmpty &&
                        Uri.tryParse(imagePath)?.hasAbsolutePath == true
                    ? CachedNetworkImage(
                        imageUrl: imagePath,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/default_avatar.png',
                          fit: BoxFit.cover,
                        ),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Image.asset(
                        'assets/default_avatar.png',
                        fit: BoxFit.cover,
                      ),
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
                    title: 'Manage Address',
                    icon: Icons.location_on,
                    onTap: () {
                      // Navigate to manage address
                    },
                  ),
                  _buildProfileOption(
                    context,
                    title: 'Payment Methods',
                    icon: Icons.payment,
                    onTap: () {
                      // Navigate to payment methods
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
                    title: 'My Wallet',
                    icon: Icons.account_balance_wallet,
                    onTap: () {
                      // Navigate to wallet
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
                    title: 'Privacy Policy',
                    icon: Icons.privacy_tip,
                    onTap: () {
                      // Navigate to privacy policy
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