import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String? x;
  final String? y;

  const Location({this.x, this.y});

  @override
  List<Object?> get props => [x, y];
}

class RunnersAllDetailsEntity extends Equatable {
  final String? id;
  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? userPhone;
  final String? bio;
  final String? transportMode;
  final bool? isAvailable;
  final String? verificationStatus;
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? latitude;
  final String? longitude;
  final Location? location;
  final List<String>? specializedTasks;
  final List<String>? languages;
  final dynamic trustScore;
  final double? averageRating;
  final int? totalTasksCompleted;
  final dynamic statistics;
  final String? verificationSubmittedAt;
  final String? verificationCompletedAt;
  final String? profilePictureUrl;
  final String? createdAt;
  final String? updatedAt;
  final double? distance;

  const RunnersAllDetailsEntity({
    this.id,
    this.userId,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.bio,
    this.transportMode,
    this.isAvailable,
    this.verificationStatus,
    this.street,
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.location,
    this.specializedTasks,
    this.languages,
    this.trustScore,
    this.averageRating,
    this.totalTasksCompleted,
    this.statistics,
    this.verificationSubmittedAt,
    this.verificationCompletedAt,
    this.profilePictureUrl,
    this.createdAt,
    this.updatedAt,
    this.distance,
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
        statistics,
        verificationSubmittedAt,
        verificationCompletedAt,
        profilePictureUrl,
        createdAt,
        updatedAt,
        distance,
      ];
}
