import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikquick/features/task/data/model/taskcreation_model.dart';

class PrmpMapState extends Equatable {
  factory PrmpMapState.initial() => PrmpMapState(
        markers: {},
        places: {},
      );

  const PrmpMapState({
    required this.markers,
    required this.places,
    this.permission,
    this.notifiedAboutPermission = false,
    this.goingToCurrenPosition = false,
    this.cameraPosition,
    this.latLng,
    this.address,
  });

  final Set<Object> places;
  final Set<Marker> markers;
  final bool notifiedAboutPermission;
  final LocationPermission? permission;
  final bool goingToCurrenPosition;
  final CameraPosition? cameraPosition;
  final LatLng? latLng;
  final AddressModel? address;

  PrmpMapState copyWith({
    Set<Marker>? markers,
    Set<Object>? places,
    bool? notifiedAboutPermission,
    bool? goingToCurrenPosition,
    LocationPermission? permission,
    CameraPosition? cameraPosition,
    LatLng? latLng,
    bool clearAddress = false,
    AddressModel? address,
  }) {
    return PrmpMapState(
      markers: markers ?? this.markers,
      places: places ?? this.places,
      notifiedAboutPermission:
          notifiedAboutPermission ?? this.notifiedAboutPermission,
      goingToCurrenPosition:
          goingToCurrenPosition ?? this.goingToCurrenPosition,
      permission: permission ?? this.permission,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      latLng: latLng ?? this.latLng,
      address: clearAddress ? address : address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [
        markers,
        places,
        notifiedAboutPermission,
        permission,
        goingToCurrenPosition,
        cameraPosition,
        latLng,
        address,
      ];

  double get bearing => cameraPosition?.bearing ?? 0;
}

extension PositionExt on Position {
  LatLng get latLng => LatLng(latitude, longitude);
}
