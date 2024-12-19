// booking_data_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingData {
  final String id;
  final String serviceType;
  final String providerName;
  final double price;
  final String status;
  final String description;
  final String address;
  final DateTime orderDate;

  BookingData({
    required this.id,
    required this.serviceType,
    required this.providerName,
    required this.price,
    required this.status,
    required this.description,
    required this.address,
    required this.orderDate,
  });

  factory BookingData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Handle different date formats
    DateTime parseDate(dynamic dateData) {
      if (dateData is Timestamp) {
        return dateData.toDate();
      } else if (dateData is String) {
        return DateTime.parse(dateData);
      } else {
        return DateTime.now(); // Fallback to current date
      }
    }

    return BookingData(
      id: doc.id,
      serviceType: data['serviceType'] ?? '',
      providerName: data['providerName'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      orderDate: parseDate(data['orderDate']),
    );
  }
}
