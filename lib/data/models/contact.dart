import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore contract: fixed document `contact/MfbG8A8QTzkVCx8qSz92`.
class Contact {
  final String local;
  final String city;
  final String phone;
  final String instagram;

  const Contact({
    required this.local,
    required this.city,
    required this.phone,
    required this.instagram,
  });

  factory Contact.fromJson(Map<String, dynamic> map) {
    return Contact(
      local: map['local'] ?? '',
      city: map['city'] ?? '',
      phone: map['phone'] ?? '',
      instagram: map['instagram'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'local': local,
      'city': city,
      'phone': phone,
      'instagram': instagram,
    };
  }

  Contact copyWith({
    String? local,
    String? city,
    String? phone,
    String? instagram,
  }) {
    return Contact(
      local: local ?? this.local,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      instagram: instagram ?? this.instagram,
    );
  }
}

/// Firestore contract: `contacts` collection — inbound contact-form
/// submissions, admin-only.
class ContactMessage {
  final String id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String status;

  const ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.status,
  });

  factory ContactMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ContactMessage(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      subject: data['subject'] ?? '',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
      status: data['status'] ?? 'pending',
    );
  }
}
