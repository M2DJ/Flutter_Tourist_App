class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? profileImage;
  final String? city;
  final String? phone;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.profileImage,
    this.city,
    this.phone,
  });

  Map<String, dynamic> toMap() {
    // Create a map with all fields, handling nulls appropriately
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profileImage': profileImage,
      'city': city,
      'phone': phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    try {
      return UserModel(
        uid: map['uid']?.toString() ?? '',
        email: map['email']?.toString() ?? '',
        name: map['name']?.toString(),
        profileImage: map['profileImage']?.toString(),
        city: map['city']?.toString(),
        phone: map['phone']?.toString(),
      );
    } catch (e) {
      print('Error creating UserModel from map: $e');
      // Return a minimal valid model in case of errors
      return UserModel(
        uid: map['uid']?.toString() ?? 'unknown',
        email: map['email']?.toString() ?? 'unknown',
      );
    }
  }
}
