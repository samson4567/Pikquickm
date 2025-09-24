import 'package:pikquick/features/transaction/domain/entities/client_reviews_entity.dart';

class ClientReviewModel extends ClientReviewEntity {
  final String? runnerId;
  final String? clientId;
  final String? taskId;
  final int? rating; // <-- change to int
  final String? review;

  const ClientReviewModel({
    this.runnerId,
    this.clientId,
    this.taskId,
    this.rating,
    this.review,
  }) : super(
          runnerId: runnerId,
          clientId: clientId,
          taskId: taskId,
          rating: rating,
          review: review,
        );

  factory ClientReviewModel.fromJson(Map<String, dynamic> json) {
    return ClientReviewModel(
      runnerId: json['runner_id'] as String?,
      clientId: json['client_id'] as String?,
      taskId: json['task_id'] as String?,
      rating: json['rating'] as int?, // <-- fix cast
      review: json['review'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (runnerId != null) 'runner_id': runnerId,
      if (clientId != null) 'client_id': clientId,
      if (taskId != null) 'task_id': taskId,
      if (rating != null) 'rating': rating, // keep int
      if (review != null) 'review': review,
    };
  }

  factory ClientReviewModel.fromEntity(ClientReviewEntity entity) {
    return ClientReviewModel(
      runnerId: entity.runnerId,
      clientId: entity.clientId,
      taskId: entity.taskId,
      rating: entity.rating as int?, // <-- adjust entity too
      review: entity.review,
    );
  }
}
