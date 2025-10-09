import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
   final String phone;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.phone,
  });

  // แปลงจาก Firestore → Employee object
  factory Employee.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Employee(
      id: doc.id,
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['email'] ?? '',
      gender: data['gender'] ?? '',
      phone: data['phone'] ?? '',
    );
  }

  // แปลงกลับเป็น Map ก่อนส่งขึ้น Firestore
  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'gender': gender,
      'phone': phone,
    };
  }
}
