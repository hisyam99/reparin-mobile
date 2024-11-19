import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/booking_data_model.dart';
import '../controllers/bookupcoming_controller.dart';

class MyBookingsView extends GetView<BookupcomingController> {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('My Bookings'),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: Obx(() => _buildContent()),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem('Upcoming', 0),
          _buildTabItem('Completed', 1),
          _buildTabItem('Cancelled', 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    return Obx(() {
      final isSelected = controller.currentTab.value == index;
      final count = index == 0
          ? controller.upcomingBookings.length
          : index == 1
              ? controller.completedBookings.length
              : controller.cancelledBookings.length;

      return GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (isSelected)
              Container(
                height: 2,
                width: 40,
                color: Colors.blue,
              ),
          ],
        ),
      );
    });
  }

  Widget _buildContent() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentBookings = controller.currentBookings;
    
    if (currentBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_busy, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No ${controller.currentTab.value == 0 ? 'upcoming' : controller.currentTab.value == 1 ? 'completed' : 'cancelled'} bookings',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: currentBookings.length,
      itemBuilder: (context, index) {
        final booking = currentBookings[index];
        return _buildBookingItem(booking);
      },
    );
  }

    Widget _buildBookingItem(BookingData booking) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.serviceType,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Provider: ${booking.providerName}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Price: \$${booking.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        'Date: ${_formatDate(booking.orderDate)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        booking.status.capitalize!,
                        style: TextStyle(
                          color: _getStatusColor(booking.status),
                        ),
                      ),
                    ),
                    if (booking.status == 'pending') ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () =>
                            controller.showCancellationDialog(booking.id),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ] else if (booking.status == 'cancelled') ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () =>
                            controller.showDeleteConfirmationDialog(booking.id),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delete, size: 16),
                            SizedBox(width: 4),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const Divider(),
            Text(
              'Address: ${booking.address}',
              style: const TextStyle(fontSize: 14),
            ),
            if (booking.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Description: ${booking.description}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}