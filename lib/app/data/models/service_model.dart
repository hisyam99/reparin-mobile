// File 5: /lib/app/data/models/service_model.dart
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
  final bool isBookmarked;

  Service({
    required this.id,
    required this.title,
    required this.provider,
    required this.price,
    required this.image,
    required this.longitude,
    required this.latitude,
    required this.address,
    this.isBookmarked = false,
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
        'isBookmarked': isBookmarked,
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
      isBookmarked: data['isBookmarked'] ?? false,
    );
  }

  // Add the copyWith method
  Service copyWith({
    String? id,
    String? title,
    String? provider,
    double? price,
    String? image,
    double? longitude,
    double? latitude,
    String? address,
    bool? isBookmarked,
  }) {
    return Service(
      id: id ?? this.id,
      title: title ?? this.title,
      provider: provider ?? this.provider,
      price: price ?? this.price,
      image: image ?? this.image,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      address: address ?? this.address,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}