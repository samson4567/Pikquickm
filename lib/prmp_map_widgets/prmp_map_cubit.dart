import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_apis/directions.dart' as ds;
import 'package:geolocator/geolocator.dart';
import 'package:pikquick/core/di/injector.dart';
import 'package:pikquick/features/task/data/model/taskcreation_model.dart';
import 'package:pikquick/prmp_map_widgets/prmp_map_state.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class PrmpMapCubit extends Cubit<PrmpMapState> {
  PrmpMapCubit() : super(PrmpMapState.initial());

  void clear() => PrmpMapState.initial();

  static const googleApiKey = 'AIzaSyC-ixkbiZOCNEjRmUEQF0N7wFLOBQgCs_8';

  Future<void> requestLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don’t continue
      permission = LocationPermission.deniedForever;
    } else {
      // Check current permission
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    }

    emit(state.copyWith(permission: permission));

    if (!state.notifiedAboutPermission) {
      emit(state.copyWith(notifiedAboutPermission: true));
      _showMessage(permission);
    }
  }

  void _showMessage(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
      // context?.showErrorToast(
      //   'Location permission is required. Please allow it to continue.',
      // );
      case LocationPermission.deniedForever:
      // context?.showErrorToast(
      //   'Location permission is permanently denied. Enable it in App Settings to continue.',
      // );
      case LocationPermission.unableToDetermine:
      // context?.showErrorToast(
      //   'Unable to determine location permission. Please check your device settings.',
      // );
      case LocationPermission.whileInUse:
      // context?.showSuccessToast(
      //   'Permission granted (while app is in use).\nTo be tracked in the background, please enable "Always Allow" location permission in App Settings.',
      // );
      case LocationPermission.always:
      // context?.showSuccessToast(
      //   'Permission granted (background tracking enabled).',
      // );
    }
  }

  late GoogleMapController _controller;

  void onMapCreated(GoogleMapController controller) => _controller = controller;

  GoogleMapController get controller => _controller;

  StreamSubscription<Position>? _positionSubscription;

  Stream<Position> getLiveLocation() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // update every 5 meters
      ),
    );
  }

  Future<Position> getCurrentPostion() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
        forceLocationManager: false,
        intervalDuration: const Duration(seconds: 10),
      ),
    );
  }

  Future<LatLng> getCurrentLatLng() async {
    final position = await getCurrentPostion();
    return LatLng(position.latitude, position.longitude);
  }

  Future<CameraPosition> getCurrentCameraPosition() async {
    return CameraPosition(target: await getCurrentLatLng(), zoom: 14.4746);
  }

  Future<void> goToCurrentLocation() async {
    emit(state.copyWith(
      goingToCurrenPosition: true,
      clearAddress: true,
      places: {},
    ));
    final position = await getCurrentCameraPosition();
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(position),
      // duration: Duration(milliseconds: 500),
    );
    emit(state.copyWith(goingToCurrenPosition: false));
    await _addMarker(position.target);
  }

  void onCameraMove(CameraPosition position) {
    emit(state.copyWith(cameraPosition: position));
  }

  void onCameraMoveStarted() {}

  String toDMS(double value, {bool isLat = false}) {
    final degrees = value.truncate();
    final minutesFull = (value - degrees).abs() * 60;
    final minutes = minutesFull.truncate();
    final seconds = ((minutesFull - minutes) * 60).toStringAsFixed(2);

    final hemisphere =
        isLat ? (value >= 0 ? "N" : "S") : (value >= 0 ? "E" : "W");

    return "$degrees° $minutes' $seconds\" $hemisphere";
  }

  final _directions = ds.GoogleMapsDirections(apiKey: 'API_KEY');

  Future<void> _addMarker(LatLng latLng, [String? description]) async {
    String snippet = description ??
        "Lat: ${toDMS(latLng.latitude, isLat: true)}"
            ','
            "Lng: ${toDMS(latLng.longitude)}";

    final marker = Marker(
      markerId: MarkerId('me'),
      position: latLng,
      icon: await Icon(
        Icons.location_on_outlined,
        size: 40,
        color: Colors.red,
      ).toBitmapDescriptor(),
      infoWindow: InfoWindow(
        title: 'Location selected',
        snippet: snippet,
      ),
      onTap: () {
        debugPrint("Marker tapped!");
      },
    );
    emit(state.copyWith(markers: {marker}, latLng: latLng));

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 15),
    );
  }

  Future<void> onTap(LatLng latLng, [String? description]) async {
    emit(state.copyWith(places: {}));
    final address = await reverseGeocode(latLng);

    if (address != null) {
      emit(state.copyWith(address: address));

      _addMarker(latLng, address.fullAddress);
    }
  }

  void resetCompass() {
    if (state.cameraPosition != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: state.cameraPosition!.target, // keep same center
            zoom: state.cameraPosition!.zoom, // keep same zoom
            tilt: state.cameraPosition!.tilt, // keep same tilt
            bearing: 0, // reset bearing
          ),
        ),
      );
    }
  }

  Future<AddressModel?> reverseGeocode(LatLng latLng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$googleApiKey',
    );

    final response = await getItInstance<Dio>().getUri(url);
    final data = response.data;

    if (data['status'] == 'OK' && data['results'].isNotEmpty) {
      final result = data['results'][0];
      final components = result['address_components'] as List;

      String? getComponent(String type) {
        try {
          return components.firstWhere(
              (c) => (c['types'] as List).contains(type))['long_name'];
        } catch (_) {
          return null;
        }
      }

      final address = AddressModel(
        addressLine1: getComponent("street_number") != null
            ? "${getComponent("street_number")} ${getComponent("route") ?? ''}"
                .trim()
            : (getComponent("route") ?? result['formatted_address']),
        addressLine2: null,
        city: getComponent("locality") ?? getComponent("sublocality") ?? "",
        state: getComponent("administrative_area_level_1") ?? "",
        postalCode: getComponent("postal_code") ?? "",
        country: getComponent("country") ?? "",
        countryCode: components.firstWhere(
            (c) => (c['types'] as List).contains("country"),
            orElse: () => {'short_name': ''})['short_name'],
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        isDefault: false,
        label: null,
      );

      return address;
    } else {
      print("Reverse geocoding failed: ${data['status']}");
      return null;
    }
  }

  Future<AddressModel?> selectPlace(String placeId, String description) async {
    emit(state.copyWith(latLng: null));

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey');

    final response = await getItInstance<Dio>().getUri(url);
    final data = response.data;

    if (data['status'] == 'OK') {
      final result = data['result'];
      final location = result['geometry']['location'];
      final components = result['address_components'] as List;

      String? getComponent(String type) {
        try {
          return components.firstWhere(
              (c) => (c['types'] as List).contains(type))['long_name'];
        } catch (_) {
          return null;
        }
      }

      final address = AddressModel(
        addressLine1: result['name'] ?? description,
        addressLine2: null, // You can add support for this if available
        city: getComponent("locality") ?? getComponent("sublocality") ?? "",
        state: getComponent("administrative_area_level_1") ?? "",
        postalCode: getComponent("postal_code") ?? "",
        country: getComponent("country") ?? "",
        countryCode: null,
        // getComponent("country") ??
        //     "", // If you want short_name instead, change this
        latitude: location['lat'],
        longitude: location['lng'],
        description: description,
        isDefault: false,
        label: null,
      );

      emit(state.copyWith(address: address));

      _addMarker(LatLng(location['lat'], location['lng']), description);

      return address;
    } else {
      print('Place details failed: ${data['status']}');
      return null;
    }
  }

  // ---- Autocomplete API ----
  Future<void> autocompleteSearch(String input) async {
    if (input.isEmpty) {
      emit(state.copyWith(places: {}));
      return;
    }

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=geocode&key=$googleApiKey');

    final response = await getItInstance<Dio>().getUri(url);
    final data = response.data;

    if (data['status'] == 'OK') {
      emit(state.copyWith(places: Set.from(data['predictions'])));
    } else {
      print('Autocomplete failed: ${data['status']}');
    }
  }
}
