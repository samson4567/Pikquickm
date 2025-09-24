class ClientReviewEntity {
  final String? runnerId;
  final String? clientId;
  final String? taskId;
  final int? rating;
  final String? review;

  const ClientReviewEntity({
    this.runnerId,
    this.clientId,
    this.taskId,
    this.rating,
    this.review,
  });
}
