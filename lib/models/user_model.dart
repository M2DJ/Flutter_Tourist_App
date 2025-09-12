class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? profileImage;
  final String? city;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.profileImage,
    this.city,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profileImage': profileImage,
      'city': city,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      profileImage: map['profileImage'],
      city: map['city'],
    );
  }
}
