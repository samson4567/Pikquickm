import 'package:pikquick/features/authentication/domain/entities/task_categores_entity.dart';

class CustomCategoryTaskModel extends CustomCategoryTaskEntity {
  const CustomCategoryTaskModel({
    super.id,
    super.name,
    super.description,
    super.categoryImage,
    super.createdAt,
    super.updatedAt,
  });

  factory CustomCategoryTaskModel.fromJson(Map<String, dynamic> json) {
    return CustomCategoryTaskModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      categoryImage: json['category_image'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category_image': categoryImage,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory CustomCategoryTaskModel.fromCustomCategoryTaskEntity(
    CustomCategoryTaskEntity entity,
  ) {
    return CustomCategoryTaskModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      categoryImage: entity.categoryImage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
