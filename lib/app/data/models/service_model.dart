import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String id;
  final String title;
  final String provider;
  final double price;
  final String image;
  final double longitude;
  final double latitude;
  final String address;

  Service({
    required this.id,
    required this.title,
    required this.provider,
    required this.price,
    required this.image,
    required this.longitude,
    required this.latitude,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'provider': provider,
        'price': price,
        'image': image,
        'longitude': longitude,
        'latitude': latitude,
        'address': address,
      };

  factory Service.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Service(
      id: doc.id,
      title: data['title'] ?? '',
      provider: data['provider'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      image: data['image'] ?? '',
      longitude: (data['longitude'] ?? 0).toDouble(),
      latitude: (data['latitude'] ?? 0).toDouble(),
      address: data['address'] ?? '',
    );
  }
}
