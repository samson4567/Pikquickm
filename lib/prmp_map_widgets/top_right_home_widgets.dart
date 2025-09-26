import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikquick/prmp_map_widgets/prmp_map_cubit.dart';
import 'package:pikquick/prmp_map_widgets/prmp_map_state.dart';

class TopRightHomeWidgets extends StatelessWidget {
  const TopRightHomeWidgets(this.mapTypeNotifier, {super.key});

  final ValueNotifier<MapType> mapTypeNotifier;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: BlocBuilder<PrmpMapCubit, PrmpMapState>(
        builder: (context, mapState) {
          return Column(
            // spacing: 14,
            children: [
              ValueListenableBuilder(
                valueListenable: mapTypeNotifier,
                builder: (context, mapType, _) {
                  return PopupMenuButton<MapType>(
                    initialValue: mapType,
                    padding: EdgeInsets.zero,
                    menuPadding: EdgeInsets.zero,
                    icon: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(MapType.none.icon, color: Colors.black),
                    ),
                    onSelected: (mapType) => mapTypeNotifier.value = mapType,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: MapType.normal,
                        child: Row(
                          children: [
                            Icon(
                              MapType.normal.icon,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text("Normal"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: MapType.satellite,
                        child: Row(
                          children: [
                            Icon(
                              MapType.satellite.icon,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text("Satellite"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: MapType.terrain,
                        child: Row(
                          children: [
                            Icon(
                              MapType.terrain.icon,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text("Terrain"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: MapType.hybrid,
                        child: Row(
                          children: [
                            Icon(
                              MapType.hybrid.icon,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text("Hybrid"),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: IconButton(
                  onPressed: context.read<PrmpMapCubit>().resetCompass,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                  icon: Transform.rotate(
                    angle: -mapState.bearing * (pi / 180),
                    child: Icon(
                      Icons.compass_calibration_rounded,
                      color: mapState.bearing.abs() < 5
                          ? Colors.blueAccent
                          : Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

extension MapTypeExt on MapType {
  IconData get icon => switch (this) {
        MapType.normal => Icons.map_outlined,
        MapType.satellite => Icons.satellite_alt_outlined,
        MapType.terrain => Icons.terrain_outlined,
        MapType.hybrid => Icons.layers_outlined,
        MapType.none => Icons.map_outlined,
      };
}
