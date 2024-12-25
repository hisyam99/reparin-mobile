// File 1: /lib/app/modules/home/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../webview/controllers/webview_controller.dart';
import '../../webview/views/webview_reparin.dart';
import '../controllers/home_controller.dart';
import 'package:reparin_mobile/app/modules/navbar/views/navbar_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
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
                  fontSize: 12, // Mengurangi ukuran teks
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
                              fontSize: 14, // Mengurangi ukuran teks
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
                              fontSize: 14, // Mengurangi ukuran teks
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Categories', () {
                      Get.toNamed('/category');
                    }),
                    _buildCategories(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Popular Services', () {
                      Get.toNamed('/popular-service');
                    }),
                    _buildPopularServices(),
                    const SizedBox(height: 24),
                  ],
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
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: controller.services.length,
          itemBuilder: (context, index) {
            var service = controller.services[index];
            return _buildServiceCard(service);
          },
        );
      }),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/popular-service');
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
                child: Image.asset(
                  service['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              service['price'],
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              service['provider'],
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              service['address'],
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
