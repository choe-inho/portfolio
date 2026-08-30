/// Firestore contract: `legal` collection, doc ids `privacy` / `terms`.
/// New in the rebuild — previously there was no in-app policy page at all.
class LegalDocument {
  final String id;
  final String title;
  final String content; // Markdown
  final DateTime updatedAt;

  const LegalDocument({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  factory LegalDocument.fromJson(String id, Map<String, dynamic> map) {
    return LegalDocument(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      updatedAt: map['updatedAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'content': content};
  }
}

class LegalDocIds {
  LegalDocIds._();
  static const String privacy = 'privacy';
  static const String terms = 'terms';
}
