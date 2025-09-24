import 'package:pikquick/features/profile/domain/entities/runner_details_model.dart'
    show RunnersAllDetailsEntity, Location;

class RunnersAllDetailsModel extends RunnersAllDetailsEntity {
  const RunnersAllDetailsModel({
    super.id,
    super.userId,
    super.userName,
    super.userEmail,
    super.userPhone,
    super.bio,
    super.transportMode,
    super.isAvailable,
    super.verificationStatus,
    super.street,
    super.city,
    super.state,
    super.country,
    super.latitude,
    super.longitude,
    super.location,
    super.specializedTasks,
    super.languages,
    super.trustScore,
    super.averageRating,
    super.totalTasksCompleted,
    super.statistics,
    super.verificationSubmittedAt,
    super.verificationCompletedAt,
    super.profilePictureUrl,
    super.createdAt,
    super.updatedAt,
    super.distance,
  });

  factory RunnersAllDetailsModel.fromJson(Map<String, dynamic> json) {
    return RunnersAllDetailsModel(
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
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      location: json['location'] != null
          ? Location(
              x: json['location']['x']?.toString(),
              y: json['location']['y']?.toString(),
            )
          : null,
      specializedTasks: (json['specialized_tasks'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      languages:
          (json['languages'] as List?)?.map((e) => e.toString()).toList(),
      trustScore: json['trust_score'],
      averageRating: json['average_rating'] != null
          ? double.tryParse(json['average_rating'].toString())
          : null,
      totalTasksCompleted: json['total_tasks_completed'],
      statistics: json['statistics'],
      verificationSubmittedAt: json['verification_submitted_at'],
      verificationCompletedAt: json['verification_completed_at'],
      profilePictureUrl: json['profile_picture_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      distance: json['distance'] != null
          ? double.tryParse(json['distance'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'user_phone': userPhone,
      'bio': bio,
      'transport_mode': transportMode,
      'is_available': isAvailable,
      'verification_status': verificationStatus,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'location': location != null
          ? {
              'x': location?.x,
              'y': location?.y,
            }
          : null,
      'specialized_tasks': specializedTasks,
      'languages': languages,
      'trust_score': trustScore,
      'average_rating': averageRating,
      'total_tasks_completed': totalTasksCompleted,
      'statistics': statistics,
      'verification_submitted_at': verificationSubmittedAt,
      'verification_completed_at': verificationCompletedAt,
      'profile_picture_url': profilePictureUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'distance': distance,
    };
  }
}
