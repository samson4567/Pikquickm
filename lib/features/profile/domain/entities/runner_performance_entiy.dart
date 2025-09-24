import 'package:equatable/equatable.dart';

class RunnerPerformanceEntity extends Equatable {
  final int totalTasksCompleted;
  final double averageRating;
  final List<String> topServices;
  final List<String> recentReviews;
  final double totalEarnings;
  final double completionRate;
  final double onTimeDeliveryRate;
  final double cancellationRate;

  const RunnerPerformanceEntity({
    required this.totalTasksCompleted,
    required this.averageRating,
    required this.topServices,
    required this.recentReviews,
    required this.totalEarnings,
    required this.completionRate,
    required this.onTimeDeliveryRate,
    required this.cancellationRate,
  });

  @override
  List<Object?> get props => [
        totalTasksCompleted,
        averageRating,
        topServices,
        recentReviews,
        totalEarnings,
        completionRate,
        onTimeDeliveryRate,
        cancellationRate,
      ];
}
