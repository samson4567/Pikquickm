import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String bio;
  final String transportMode;
  final List<String> specializedTasks;
  final List<String> languages;
  final double latitude;
  final double longitude;
  final String country;
  final String state;
  final String city;
  final String street;

  const ProfileEntity({
    required this.bio,
    required this.transportMode,
    required this.specializedTasks,
    required this.languages,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.state,
    required this.city,
    required this.street,
  });

  @override
  List<Object?> get props => [
        bio,
        transportMode,
        specializedTasks,
        languages,
        latitude,
        longitude,
        country,
        state,
        city,
        street,
      ];
}
