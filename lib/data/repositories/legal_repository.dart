import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/legal_document.dart';

/// New in the rebuild: admin-authored Markdown for the privacy
/// policy / terms of service, stored in Firestore instead of an
/// external link.
class LegalRepository {
  LegalRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<LegalDocument?> fetch(String docId) async {
    final doc = await _firestore.collection('legal').doc(docId).get();
    final data = doc.data();
    if (data == null) return null;
    return LegalDocument.fromJson(docId, data);
  }

  Future<void> update(
    String docId, {
    required String title,
    required String content,
  }) {
    return _firestore.collection('legal').doc(docId).set({
      'title': title,
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
