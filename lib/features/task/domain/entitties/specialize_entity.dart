import 'package:equatable/equatable.dart';

class SavedCategoriesEntity extends Equatable {
  final List<String> specializedTasks;

  const SavedCategoriesEntity({required this.specializedTasks});

  @override
  List<Object?> get props => [specializedTasks];
}
