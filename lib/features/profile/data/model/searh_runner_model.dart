import 'package:pikquick/features/profile/domain/entities/search_entity.dart'
    show SearchRunnerEntity, SearchRunnerListEntity;

class SearchRunnerModel extends SearchRunnerEntity {
  const SearchRunnerModel({
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
    super.city,
    super.state,
    required super.country,
    required super.latitude,
    required super.longitude,
    super.specializedTasks,
    super.languages,
    super.trustScore,
    super.averageRating,
    super.totalTasksCompleted,
    super.profilePictureUrl,
    super.verificationSubmittedAt,
    super.verificationCompletedAt,
    super.createdAt,
    super.updatedAt,
  });

  factory SearchRunnerModel.fromJson(Map<String, dynamic> json) {
    return SearchRunnerModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userEmail: json['user_email'] ?? '',
      userPhone: json['user_phone'] ?? '',
      bio: json['bio'] ?? '',
      transportMode: json['transport_mode'] ?? '',
      isAvailable: json['is_available'] == 1,
      verificationStatus: json['verification_status'] ?? '',
      street: json['street'] ?? '',
      city: json['city'],
      state: json['state'],
      country: json['country'] ?? '',
      latitude: double.tryParse(json['latitude'] ?? '0.0') ?? 0.0,
      longitude: double.tryParse(json['longitude'] ?? '0.0') ?? 0.0,
      specializedTasks: (json['specialized_tasks'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      languages:
          (json['languages'] as List?)?.map((e) => e.toString()).toList(),
      trustScore: json['trust_score'] != null
          ? double.tryParse(json['trust_score'].toString())
          : null,
      averageRating: json['average_rating'] != null
          ? double.tryParse(json['average_rating'].toString())
          : null,
      totalTasksCompleted: json['total_tasks_completed'] ?? 0,
      profilePictureUrl: json['profile_picture_url'],
      verificationSubmittedAt: json['verification_submitted_at'] != null
          ? DateTime.tryParse(json['verification_submitted_at'])
          : null,
      verificationCompletedAt: json['verification_completed_at'] != null
          ? DateTime.tryParse(json['verification_completed_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

class SearchRunnerListModel extends SearchRunnerListEntity {
  const SearchRunnerListModel({
    required super.runners,
    required super.total,
    required super.page,
    required super.limit,
    required super.hasMore,
  });

  factory SearchRunnerListModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data']['data'] as List;
    final meta = json['data']['meta'];

    return SearchRunnerListModel(
      runners: dataList.map((e) => SearchRunnerModel.fromJson(e)).toList(),
      total: meta['total'] ?? 0,
      page: meta['page'] ?? 1,
      limit: meta['limit'] ?? 10,
      hasMore: meta['hasMore'] ?? false,
    );
  }
}
