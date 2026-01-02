class Contact{
  final String local;
  final String city;
  final String phone;
  final String instagram;

  Contact({
    required this.local,
    required this.city,
    required this.phone,
    required this.instagram
  });

  factory Contact.fromJson(Map<String, dynamic> map) {
    return Contact(
        local: map['local'],
        city: map['city'],
        phone: map['phone'],
        instagram: map['instagram']
    );
  }
}