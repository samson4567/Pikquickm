import 'package:equatable/equatable.dart';

class CustomCategoryTaskEntity extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? categoryImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CustomCategoryTaskEntity({
    this.id,
    this.name,
    this.description,
    this.categoryImage,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        categoryImage,
        createdAt,
        updatedAt,
      ];
}
