import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final RxString id;
  final RxString name;
  final RxString phone;
  final RxString email;
  final RxString imagePath;
  final RxString role; // Menambahkan field role

  Profile({
    String? id,
    required String name,
    required String phone,
    required String email,
    String? imagePath,
    String? role,
  })  : id = RxString(id ?? ''),
        name = RxString(name.trim()),
        phone = RxString(phone.trim()),
        email = RxString(email.trim()),
        imagePath = RxString(imagePath ?? ''),
        role = RxString(role ?? 'user'); // Default role adalah 'user'

  Map<String, dynamic> toJson() => {
        'id': id.value,
        'name': name.value,
        'phone': phone.value,
        'email': email.value,
        'imagePath': imagePath.value,
        'role': role.value,
      };

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Profile(
      id: doc.id,
      name: data['name']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      imagePath: data['imagePath']?.toString() ?? '',
      role: data['role']?.toString() ?? 'user',
    );
  }

  factory Profile.empty() => Profile(
        name: '',
        phone: '',
        email: '',
      );
}
