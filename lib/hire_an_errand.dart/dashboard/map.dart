import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikquick/component/textfilled.dart';
import 'package:pikquick/router/router_config.dart';

class ProfessionalMapScreen extends StatefulWidget {
  const ProfessionalMapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfessionalMapScreenState createState() => _ProfessionalMapScreenState();
}

final TextEditingController pickLocationController = TextEditingController();

class _ProfessionalMapScreenState extends State<ProfessionalMapScreen> {
  GoogleMapController? _controller;
  LatLng _center =
      LatLng(37.7749, -122.4194); // Initial location (San Francisco)

  void _onCameraMove(CameraPosition position) {
    _center = position.target;
  }

  void _onConfirm() {
    context.pushNamed(MyAppRouteConstant.tasklocation);
    print("Location confirmed: ${_center.latitude}, ${_center.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Icon(Icons.arrow_back_ios),
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _center, zoom: 15),
            onCameraMove: _onCameraMove,
            onMapCreated: (controller) => _controller = controller,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),

          /// Center Pin
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Icon(Icons.location_on, size: 60, color: Colors.redAccent),
            ),
          ),

          /// Top Info
          Positioned(
            top: 400,
            left: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/ogo.png'),
              ],
            ),
          ),

          /// Bottom Modal
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 20, 70),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Text("Set Your Location",
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                      )),
                  const SizedBox(height: 10),
                  Text("Drag the map to move the pin",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      )),
                  const SizedBox(height: 10),
                  TextFormFieldWithCustomStyles(
                    controller: pickLocationController,
                    label: "Enter pickup location",
                    hintText: "Enter your email",
                    fillColor: Colors.white,
                    labelColor: const Color(0xFF98A2B3),
                    hintColor: const Color(0xFF98A2B3),
                    textColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 56),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text("Confirm Location",
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
