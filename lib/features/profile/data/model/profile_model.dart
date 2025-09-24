import 'package:pikquick/features/profile/domain/entities/profile_entity.dart';

class ProfileEditModel extends ProfileEntity {
  const ProfileEditModel({
    required super.bio,
    required super.transportMode,
    required super.specializedTasks,
    required super.languages,
    required super.latitude,
    required super.longitude,
    required super.country,
    required super.state,
    required super.city,
    required super.street,
  });

  factory ProfileEditModel.fromJson(Map<String, dynamic> json) {
    return ProfileEditModel(
      bio: json['bio'] ?? '',
      transportMode: json['transportMode'] ?? '',
      specializedTasks: List<String>.from(json['specializedTasks'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      street: json['street'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'transportMode': transportMode,
      'specializedTasks': specializedTasks,
      'languages': languages,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'state': state,
      'city': city,
      'street': street,
    };
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      bio: bio,
      transportMode: transportMode,
      specializedTasks: specializedTasks,
      languages: languages,
      latitude: latitude,
      longitude: longitude,
      country: country,
      state: state,
      city: city,
      street: street,
    );
  }
}
