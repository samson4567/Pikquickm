import 'package:pikquick/features/profile/domain/entities/get_reviews%20_entites.dart';

class GetReviewModel extends GetReviewEntity {
  const GetReviewModel({
    super.id,
    super.runnerId,
    super.runnerName,
    super.clientId,
    super.clientName,
    super.taskId,
    super.rating,
    super.review,
    super.createdAt,
    super.updatedAt,
  });

  factory GetReviewModel.fromJson(Map<String, dynamic> json) {
    return GetReviewModel(
      id: json['id'] as String?,
      runnerId: json['runner_id'] as String?,
      runnerName: json['runner_name'] as String?,
      clientId: json['client_id'] as String?,
      clientName: json['client_name'] as String?,
      taskId: json['task_id'] as String?,
      rating: json['rating'] is int
          ? json['rating']
          : int.tryParse(json['rating']?.toString() ?? ''),
      review: json['review'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'runner_id': runnerId,
      'runner_name': runnerName,
      'client_id': clientId,
      'client_name': clientName,
      'task_id': taskId,
      'rating': rating,
      'review': review,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory GetReviewModel.fromEntity(GetReviewEntity entity) {
    return GetReviewModel(
      id: entity.id,
      runnerId: entity.runnerId,
      runnerName: entity.runnerName,
      clientId: entity.clientId,
      clientName: entity.clientName,
      taskId: entity.taskId,
      rating: entity.rating,
      review: entity.review,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
