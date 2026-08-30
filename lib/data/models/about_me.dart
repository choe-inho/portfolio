/// Firestore contract: `about/me` document. Kept identical to the legacy
/// model so no data migration is needed.
class AboutMe {
  final String name;
  final DateTime birthDay;
  final String produce;
  final String profileImage;
  final String strength;

  const AboutMe({
    required this.name,
    required this.birthDay,
    required this.produce,
    required this.profileImage,
    required this.strength,
  });

  factory AboutMe.fromJson(Map<String, dynamic> map) {
    return AboutMe(
      name: map['name'] ?? '',
      birthDay: map['birthDay']?.toDate() ?? DateTime.now(),
      produce: map['produce'] ?? '',
      profileImage: map['profileImage'] ?? '',
      strength: map['strength'] ?? '',
    );
  }
}
