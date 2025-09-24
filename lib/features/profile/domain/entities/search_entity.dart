import 'package:equatable/equatable.dart';

class SearchRunnerEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String bio;
  final String transportMode;
  final bool isAvailable;
  final String verificationStatus;
  final String street;
  final String? city;
  final String? state;
  final String country;
  final double latitude;
  final double longitude;
  final List<String>? specializedTasks;
  final List<String>? languages;
  final double? trustScore;
  final double? averageRating;
  final int? totalTasksCompleted;
  final String? profilePictureUrl;
  final DateTime? verificationSubmittedAt;
  final DateTime? verificationCompletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SearchRunnerEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.bio,
    required this.transportMode,
    required this.isAvailable,
    required this.verificationStatus,
    required this.street,
    this.city,
    this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.specializedTasks,
    this.languages,
    this.trustScore,
    this.averageRating,
    this.totalTasksCompleted,
    this.profilePictureUrl,
    this.verificationSubmittedAt,
    this.verificationCompletedAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, userId, userName];
}

class SearchRunnerListEntity extends Equatable {
  final List<SearchRunnerEntity> runners;
  final int total;
  final int page;
  final int limit;
  final bool hasMore;

  const SearchRunnerListEntity({
    required this.runners,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [runners, total, page, limit, hasMore];
}
