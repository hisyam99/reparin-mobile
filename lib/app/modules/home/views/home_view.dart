import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/service_model.dart';
import '../../webview/controllers/webview_controller.dart';
import '../../webview/views/webview_reparin.dart';
import '../controllers/home_controller.dart';
import 'package:reparin_mobile/app/modules/navbar/views/navbar_view.dart';
import 'package:reparin_mobile/app/data/services/authentication/controllers/authentication_controller.dart';
import '../../service/controllers/service_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final AuthenticationController authController =
        Get.find<AuthenticationController>();
    final ServiceController serviceController = Get.find<ServiceController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0093B7),
        title: GestureDetector(
          onTap: () async {
            await controller.getCurrentLocation();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Obx(() {
                      if (controller.loading.value) {
                        return const SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            controller.addressDetails.value,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.newspaper_outlined),
            onPressed: () {
              Get.to(
                () => const HelpWebViewReparin(),
                binding: BindingsBuilder(() {
                  Get.put(ArticleDetailController());
                }),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Get.toNamed('/notification');
            },
          ),
          // Menampilkan menu khusus admin jika role adalah 'admin'
          Obx(() {
            if (authController.userRole.value == 'admin') {
              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'add_service') {
                    Get.toNamed('/admin-dashboard/add-service');
                  } else if (value == 'dashboard') {
                    Get.toNamed('/admin-dashboard');
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'dashboard',
                    child: Text('Admin Dashboard'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'add_service',
                    child: Text('Add Service'),
                  ),
                ],
                icon: const Icon(Icons.admin_panel_settings),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 24,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF0093B7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  controller.filterServicesByLocation(value);
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    Get.toNamed('/search-results', arguments: {
                      'query': value,
                      'services': controller.filteredServices
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Find nearby services . . .',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await serviceController.fetchServices();
                  controller.filteredServices.value =
                      serviceController.services;
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Categories', () {
                        Get.toNamed('/category');
                      }),
                      _buildCategories(),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Popular Services', () {
                        Get.toNamed('/service');
                      }),
                      _buildPopularServices(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              'See All',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategoryCard('Laptop', Icons.laptop_mac),
          _buildCategoryCard('Handphone', Icons.phone_android),
          _buildCategoryCard('Tablet', Icons.tablet_mac),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFE5F6FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 40,
            color: const Color(0xFF0093B7),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPopularServices() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        if (controller.filteredServices.isEmpty) {
          return const Center(
            child: Text('No services available'),
          );
        }
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: controller.filteredServices.length,
          itemBuilder: (context, index) {
            var service = controller.filteredServices[index];
            return _buildServiceCard(service);
          },
        );
      }),
    );
  }

  Widget _buildServiceCard(Service service) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/popular-service', arguments: service);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE5F6FA),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: service.image.isNotEmpty
                    ? Image.network(
                        service.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/default_repair.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/default_repair.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '\$${service.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              service.provider,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              service.address,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.blueGrey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
