/// Contact 정보 모델
/// Firestore collection('contact').doc('MfbG8A8QTzkVCx8qSz92')에서 가져옴
class Contact {
  final String local;
  final String city;
  final String phone;
  final String instagram;

  Contact({
    required this.local,
    required this.city,
    required this.phone,
    required this.instagram,
  });

  /// Firestore에서 데이터 가져오기
  factory Contact.fromJson(Map<String, dynamic> map) {
    return Contact(
      local: map['local'] ?? '',
      city: map['city'] ?? '',
      phone: map['phone'] ?? '',
      instagram: map['instagram'] ?? '',
    );
  }

  /// Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toJson() {
    return {
      'local': local,
      'city': city,
      'phone': phone,
      'instagram': instagram,
    };
  }

  /// 복사 생성자 (불변성 유지)
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

  @override
  String toString() {
    return 'Contact(local: $local, city: $city, phone: $phone, instagram: $instagram)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Contact &&
        other.local == local &&
        other.city == city &&
        other.phone == phone &&
        other.instagram == instagram;
  }

  @override
  int get hashCode {
    return local.hashCode ^
    city.hashCode ^
    phone.hashCode ^
    instagram.hashCode;
  }
}