import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/service_provider_controller.dart';

class ServiceProviderView extends GetView<ServiceProviderController> {
  const ServiceProviderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Service Provider'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProviderInfo(),
            _buildStats(),
            _buildTabBar(),
            _buildServiceList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildProviderInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(controller.providerImage),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.providerName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  controller.providerSpecialty,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue, size: 16),
                    Text(controller.providerLocation),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(Icons.person, '${controller.customerCount}+', 'Customer'),
          _buildStatItem(Icons.work, '${controller.yearsExperience}+', 'Years Exp.'),
          _buildStatItem(Icons.star, controller.rating.toString(), 'Ratings'),
          _buildStatItem(Icons.rate_review, controller.reviewCount.toString(), 'Reviews'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildTabBar() {
    return Obx(() => TabBar(
      controller: controller.tabController,
      tabs: controller.tabs.map((String tab) => Tab(text: tab)).toList(),
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.blue,
    ));
  }

  Widget _buildServiceList() {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.services.length,
      itemBuilder: (context, index) {
        final service = controller.services[index];
        return ListTile(
          leading: Image.network(service.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
          title: Text(service.name),
          subtitle: Text('\$${service.price.toStringAsFixed(2)}'),
          trailing: const Icon(Icons.bookmark_border),
        );
      },
    ));
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Location'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Bookmarks'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}