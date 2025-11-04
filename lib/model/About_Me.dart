class AboutMe{
  final String name; //이름
  final DateTime birthDay; //나이
  final String produce; //자기소개
  final String profileImage; //프로필 이미지
  final String strength; //강점

  AboutMe({
    required this.name,
    required this.birthDay,
    required this.produce,
    required this.profileImage,
    required this.strength
  });

  factory AboutMe.fromJson(Map<String, dynamic> map){
    return AboutMe(
        name: map['name'],
        birthDay: map['birthDay'].toDate(),
        produce: map['produce'],
        profileImage: map['profileImage'],
        strength: map['strength']
    );
  }
}