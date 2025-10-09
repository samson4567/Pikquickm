import 'package:equatable/equatable.dart';

abstract class GetReviewEntity extends Equatable {
  final String? id;
  final String? runnerId;
  final String? runnerName;
  final String? clientId;
  final String? clientName;
  final String? taskId;
  final int? rating;
  final String? review;
  final String? createdAt;
  final String? updatedAt;

  const GetReviewEntity({
    this.id,
    this.runnerId,
    this.runnerName,
    this.clientId,
    this.clientName,
    this.taskId,
    this.rating,
    this.review,
    this.createdAt,
    this.updatedAt,
  });
}
