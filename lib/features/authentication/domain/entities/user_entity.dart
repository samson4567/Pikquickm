class UserEntity {
  final String id;
  final String? fullName;
  final String? email;
  final String phone;
  final String role;
  final String status;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}
