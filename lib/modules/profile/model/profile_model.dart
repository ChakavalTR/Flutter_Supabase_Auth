class ProfileModel {
  final String id;
  final String email;
  final String fullName;
  final String phone;
  final String role;
  final String address;
  final String avatarUrl;

  ProfileModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.address,
    required this.avatarUrl,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      fullName: map['full_name'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      address: map['address'] ?? '',
      avatarUrl: map['avatar_url'] ?? '',
    );
  }
}
