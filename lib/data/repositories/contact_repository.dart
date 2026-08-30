import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact.dart';

class ContactRepository {
  ContactRepository(this._firestore);

  final FirebaseFirestore _firestore;

  /// Fixed document id carried over from the legacy schema.
  static const String contactDocId = 'MfbG8A8QTzkVCx8qSz92';

  Future<Contact?> fetchContactInfo() async {
    final doc = await _firestore.collection('contact').doc(contactDocId).get();
    if (!doc.exists) return null;
    return Contact.fromJson(doc.data()!);
  }

  Future<void> updateContactInfo(Contact contact) {
    return _firestore
        .collection('contact')
        .doc(contactDocId)
        .update(contact.toJson());
  }

  Future<void> submitMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) {
    return _firestore.collection('contacts').add({
      'name': name.trim(),
      'email': email.trim(),
      'subject': subject.trim(),
      'message': message.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'status': 'pending',
    });
  }

  Stream<List<ContactMessage>> watchMessages() {
    return _firestore
        .collection('contacts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((s) => s.docs.map(ContactMessage.fromFirestore).toList());
  }

  Future<void> markAsRead(String messageId) {
    return _firestore.collection('contacts').doc(messageId).update({
      'isRead': true,
      'readAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateStatus(String messageId, String status) {
    return _firestore.collection('contacts').doc(messageId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
