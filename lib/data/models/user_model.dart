class UserModel {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;

  UserModel({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'] ?? '',
      phoneNumber: json['phone_user'] ?? '',
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'phone_user': phoneNumber,
      'name': name,
      'email': email,
    };
  }
}

