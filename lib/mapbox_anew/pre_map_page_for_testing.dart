import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/router/router_config.dart';

class PreMapPageForTesting extends StatefulWidget {
  const PreMapPageForTesting({super.key});

  @override
  State<PreMapPageForTesting> createState() => _PreMapPageForTestingState();
}

class _PreMapPageForTestingState extends State<PreMapPageForTesting> {
  MapBoxPlace? selectedMapBoxPlace;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FancyContainer(
            height: 40,
            action: () async {
              selectedMapBoxPlace = await context.push<MapBoxPlace>(
                      MyAppRouteConstant.mapBoxFullMapWidget) ??
                  selectedMapBoxPlace;
              if (selectedMapBoxPlace == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "no Location selected",
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Location selected",
                    ),
                  ),
                );
              }
            },
            child: Text((selectedMapBoxPlace == null)
                ? "select a location"
                : "${selectedMapBoxPlace!.placeName}"),
          ),
        ),
      ),
    );
  }
}
