import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.role,
    required super.status,
    required super.isActive,
    super.createdAt,
    super.updatedAt,
    required super.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      isActive: (json['is_active'] == 1) ? true : false,
      createdAt: DateTime.tryParse(json['created_at'] ?? ""),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ""),
      imageUrl: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'status': status,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static UserEntity toEntity(UserModel model) => UserEntity(
        id: model.id,
        fullName: model.fullName,
        email: model.email,
        phone: model.phone,
        role: model.role,
        status: model.status,
        isActive: model.isActive,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        imageUrl: model.imageUrl,
      );

  factory UserModel.createFromLogin(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      isActive: json['is_active'] == 1,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      imageUrl: null,
    );
  }
  factory UserModel.fromEntity(UserEntity userEntity) {
    return UserModel(
      id: userEntity.id,
      fullName: userEntity.fullName ?? '',
      email: userEntity.email ?? '',
      phone: userEntity.phone,
      role: userEntity.role,
      status: userEntity.status,
      isActive: userEntity.isActive,
      createdAt: userEntity.createdAt,
      updatedAt: userEntity.updatedAt,
      imageUrl: userEntity.imageUrl,
    );
  }
}
