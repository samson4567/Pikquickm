import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:pikquick/app_variable.dart';

class MapBoxFullMapWidget extends StatefulWidget {
  const MapBoxFullMapWidget({super.key});

  @override
  State createState() => MapBoxFullMapWidgetState();
}

class MapBoxFullMapWidgetState extends State<MapBoxFullMapWidget> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    // this.mapboxMap?.cameraForCoordinatesCameraOptions([Point(coordinates: Position(7, 4))], CameraOptions(), box)
    // this.mapboxMap?.cameraOptions
    // this.mapboxMap.;
  }

  Offset? currentLocation;
  MapBoxPlace? selectedMapBoxPlace;
  bool searchingLatLngAddress = false;
  late double screenHeight;
  late double screenWidth;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        screenWidth = MediaQuery.sizeOf(context).width;
        screenHeight = MediaQuery.sizeOf(context).height;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
        // backgroundColor: Colors.red,
        body:
            //
            //     SizedBox(
            //   child: Text("data"),
            // )

            Stack(
      children: [
        MapWidget(
          cameraOptions: CameraOptions(zoom: 10),
          key: ValueKey("mapWidget"),
          onMapCreated: _onMapCreated,
          onTapListener: (context) async {
            currentLocation =
                Offset(context.touchPosition.x, context.touchPosition.y);
            searchingLatLngAddress = true;
            setState(() {});
            await setSelectedMapBoxPlace(
                context.point.coordinates.lat.toDouble(),
                context.point.coordinates.lng.toDouble());
            searchingLatLngAddress = false;
            setState(() {});
          },
        ),
        if (currentLocation != null)
          Align(
              alignment: _getMarkerAlignment(),
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: screenWidth * .1,
              )),
        Align(
          alignment: Alignment.bottomCenter,
          child: FancyContainer(
            rawBorderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            height: MediaQuery.sizeOf(context).height * .3,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  searchingLatLngAddress
                      ? CircularProgressIndicator.adaptive()
                      : Text((selectedMapBoxPlace == null)
                          ? "No address found"
                          : "${selectedMapBoxPlace?.placeName}"),
                  FancyContainer(
                    height: 40,
                    action: () {
                      context.pop(selectedMapBoxPlace);
                    },
                    backgroundColor: Colors.blue,
                    child: Text("Confirm Location"),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  setSelectedMapBoxPlace(
    double lat,
    double lng,
  ) async {
    // selectedMapBoxPlace =
    // await MapboxGeocodingHandler().getAddressFromLatlng(lat, lng);
  }

  Alignment _getMarkerAlignment() {
    return Alignment(
        (2 *
                (((currentLocation!.dx - ((screenWidth * .1) / 2))) /
                    (screenWidth))) -
            1,
        (2 * ((currentLocation!.dy - (screenWidth * .1)) / (screenHeight))) -
            1);
  }
}
