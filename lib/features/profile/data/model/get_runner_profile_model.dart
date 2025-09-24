import 'package:pikquick/features/profile/domain/entities/getrunner_entity.dart'
    show GetRunnerProfileEntity, LocationEntity;

class GetRunnerProfileModel extends GetRunnerProfileEntity {
  const GetRunnerProfileModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userEmail,
    required super.userPhone,
    required super.bio,
    required super.transportMode,
    required super.isAvailable,
    required super.verificationStatus,
    required super.street,
    required super.city,
    required super.state,
    required super.country,
    required super.latitude,
    required super.longitude,
    required super.location,
    required super.specializedTasks,
    required super.languages,
    required super.trustScore,
    super.averageRating,
    required super.totalTasksCompleted,
    super.verificationSubmittedAt,
    super.verificationCompletedAt,
    super.profilePictureUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory GetRunnerProfileModel.fromJson(Map<String, dynamic> json) {
    return GetRunnerProfileModel(
      id: json['id'],
      userId: json['user_id'],
      userName: json['user_name'],
      userEmail: json['user_email'],
      userPhone: json['user_phone'],
      bio: json['bio'],
      transportMode: json['transport_mode'],
      isAvailable: json['is_available'] == 1,
      verificationStatus: json['verification_status'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      location: LocationEntity(
        x: json['location']['x'],
        y: json['location']['y'],
      ),
      specializedTasks: List<String>.from(json['specialized_tasks'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      trustScore: json['trust_score'],
      averageRating: json['average_rating'] != null
          ? double.tryParse(json['average_rating'].toString())
          : null,
      totalTasksCompleted: json['total_tasks_completed'],
      verificationSubmittedAt: json['verification_submitted_at'] != null
          ? DateTime.tryParse(json['verification_submitted_at'])
          : null,
      verificationCompletedAt: json['verification_completed_at'] != null
          ? DateTime.tryParse(json['verification_completed_at'])
          : null,
      profilePictureUrl: json['profile_picture_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
