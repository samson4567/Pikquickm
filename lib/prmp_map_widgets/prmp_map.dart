import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pikquick/prmp_map_widgets/prmp_map_cubit.dart';
import 'package:pikquick/prmp_map_widgets/prmp_map_state.dart';

class PrmpMap extends StatefulWidget {
  const PrmpMap(this.mapTypeNotifier, {super.key});

  final ValueNotifier<MapType> mapTypeNotifier;

  @override
  State<PrmpMap> createState() => _PrmpMapState();
}

class _PrmpMapState extends State<PrmpMap> {
  late final PrmpMapCubit _cubit;
  Future<CameraPosition>? _initialCameraFuture;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PrmpMapCubit>()..requestLocationPermission(context);
  }

  @override
  Widget build(BuildContext context) {
    final loader = Center(
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );

    return BlocBuilder<PrmpMapCubit, PrmpMapState>(
      builder: (context, state) {
        print(state.permission);
        switch (state.permission) {
          case LocationPermission.whileInUse:
          case LocationPermission.always:
            _initialCameraFuture ??= _cubit.getCurrentCameraPosition();

            return FutureBuilder(
              future: _initialCameraFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ValueListenableBuilder(
                    valueListenable: widget.mapTypeNotifier,
                    builder: (context, mapType, _) {
                      return GoogleMap(
                        mapType: mapType,
                        initialCameraPosition: snapshot.data!,
                        onMapCreated: _cubit.onMapCreated,
                        onTap: _cubit.onTap,
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        mapToolbarEnabled: false,
                        onCameraMove: _cubit.onCameraMove,
                        onCameraMoveStarted: _cubit.onCameraMoveStarted,
                        markers: state.markers,
                      );
                    },
                  );
                } else {
                  return loader;
                }
              },
            );
          default:
            return loader;
        }
      },
    );
  }
}
