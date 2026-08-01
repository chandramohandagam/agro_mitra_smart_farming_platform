enum UserRole {
  farmer,
  dealer,
  company,
  admin;

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'farmer':
        return UserRole.farmer;
      case 'dealer':
        return UserRole.dealer;
      case 'company':
        return UserRole.company;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.farmer;
    }
  }

  String get name => toString().split('.').last;
}

class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final UserRole role;
  final String? location;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final List<String> tags;

  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    required this.role,
    this.location,
    this.profileImageUrl,
    this.createdAt,
    this.tags = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'],
      role: UserRole.fromString(json['role'] ?? 'farmer'),
      location: json['location'],
      profileImageUrl: json['profile_image_url'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'role': role.name,
      'location': location,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt?.toIso8601String(),
      'tags': tags,
    };
  }
}
