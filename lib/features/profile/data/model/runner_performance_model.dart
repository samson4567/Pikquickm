import 'package:pikquick/features/profile/domain/entities/runner_performance_entiy.dart';

class RunnerPerformanceModel extends RunnerPerformanceEntity {
  const RunnerPerformanceModel({
    required super.totalTasksCompleted,
    required super.averageRating,
    required super.topServices,
    required super.recentReviews,
    required super.totalEarnings,
    required super.completionRate,
    required super.onTimeDeliveryRate,
    required super.cancellationRate,
  });

  factory RunnerPerformanceModel.fromJson(Map<String, dynamic> json) {
    final stats = json['statistics'] ?? {};
    return RunnerPerformanceModel(
      totalTasksCompleted: json['total_tasks_completed'] ?? 0,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      topServices: List<String>.from(json['top_services'] ?? []),
      recentReviews: List<String>.from(json['recent_reviews'] ?? []),
      totalEarnings: (stats['total_earnings'] ?? 0).toDouble(),
      completionRate: (stats['completion_rate'] ?? 0).toDouble(),
      onTimeDeliveryRate: (stats['on_time_delivery_rate'] ?? 0).toDouble(),
      cancellationRate: (stats['cancellation_rate'] ?? 0).toDouble(),
    );
  }
}
