import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikquick/prmp_map_widgets/place_bottom_sheet.dart';
import 'package:pikquick/prmp_map_widgets/prmp_map.dart';
import 'package:pikquick/prmp_map_widgets/prmp_map_cubit.dart';
import 'package:pikquick/prmp_map_widgets/prmp_map_state.dart';
import 'package:pikquick/prmp_map_widgets/top_right_home_widgets.dart';

class GooglePlaceMapScreen extends StatefulWidget {
  const GooglePlaceMapScreen({super.key});

  @override
  State createState() => GooglePlaceMapScreenState();
}

class GooglePlaceMapScreenState extends State<GooglePlaceMapScreen> {
  final mapTypeNotifier = ValueNotifier<MapType>(MapType.normal);
  final _bottomSheetNotifier = ValueNotifier(false);

  late final PrmpMapCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PrmpMapCubit>();
  }

  @override
  void dispose() {
    _bottomSheetNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseHeight = 250.0;

    return Scaffold(
        bottomSheet: PlaceBottomSheet(),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 100),
          child: SizedBox(
            height: 56,
            width: 56,
            child: BlocBuilder<PrmpMapCubit, PrmpMapState>(
              builder: (context, mapState) {
                final going = mapState.goingToCurrenPosition;

                return SizedBox(
                  height: 56,
                  width: 56,
                  child: IconButton(
                    onPressed: going ? null : _cubit.goToCurrentLocation,
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                    color: Colors.blueAccent,
                    icon: going
                        ? CircularProgressIndicator.adaptive(
                            // padding: EdgeInsets.all(20),
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blueAccent,
                            ),
                          )
                        : Icon(
                            Icons.my_location_outlined,
                            color: Colors.blueAccent,
                          ),
                  ),
                );
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            PrmpMap(mapTypeNotifier),
            TopRightHomeWidgets(mapTypeNotifier),
            Positioned(
              top: 48,
              left: 24,
              child: SizedBox(
                height: 40,
                width: 40,
                child: Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: Navigator.of(context).pop,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      icon: Icon(Icons.arrow_back),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
