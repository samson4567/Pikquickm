import 'package:equatable/equatable.dart';

class GetRunnerProfileEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String bio;
  final String transportMode;
  final bool isAvailable;
  final String verificationStatus;
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String latitude;
  final String longitude;
  final LocationEntity location;
  final List<String> specializedTasks;
  final List<String> languages;
  final String trustScore;
  final double? averageRating;
  final int totalTasksCompleted;
  final DateTime? verificationSubmittedAt;
  final DateTime? verificationCompletedAt;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GetRunnerProfileEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.bio,
    required this.transportMode,
    required this.isAvailable,
    required this.verificationStatus,
    this.street,
    this.city,
    this.state,
    this.country,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.specializedTasks,
    required this.languages,
    required this.trustScore,
    this.averageRating,
    required this.totalTasksCompleted,
    this.verificationSubmittedAt,
    this.verificationCompletedAt,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userEmail,
        userPhone,
        bio,
        transportMode,
        isAvailable,
        verificationStatus,
        street,
        city,
        state,
        country,
        latitude,
        longitude,
        location,
        specializedTasks,
        languages,
        trustScore,
        averageRating,
        totalTasksCompleted,
        verificationSubmittedAt,
        verificationCompletedAt,
        profilePictureUrl,
        createdAt,
        updatedAt,
      ];
}

class LocationEntity extends Equatable {
  final String x;
  final String y;

  const LocationEntity({
    required this.x,
    required this.y,
  });

  @override
  List<Object> get props => [x, y];
}
