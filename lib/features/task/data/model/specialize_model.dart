import 'package:pikquick/features/task/domain/entitties/specialize_entity.dart';

class SavedCategoriesModel extends SavedCategoriesEntity {
  const SavedCategoriesModel({required super.specializedTasks});

  factory SavedCategoriesModel.fromJson(Map<String, dynamic> json) {
    return SavedCategoriesModel(
      specializedTasks: List<String>.from(json['specialized_tasks'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specialized_tasks': specializedTasks,
    };
  }
}
