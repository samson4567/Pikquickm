import 'package:pikquick/features/profile/domain/entities/create_profile_entity.dart';

class ProfileModel extends CreateProfileEntity {
  const ProfileModel({
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

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      bio: json['bio'],
      transportMode: json['transport_mode'],
      specializedTasks: List<String>.from(json['specialized_tasks']),
      languages: List<String>.from(json['languages']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      street: json['street'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'transport_mode': transportMode,
      'specialized_tasks': specializedTasks,
      'languages': languages,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'state': state,
      'city': city,
      'street': street,
    };
  }
}
