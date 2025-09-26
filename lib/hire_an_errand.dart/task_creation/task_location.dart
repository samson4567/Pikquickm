import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/features/task/data/model/taskcreation_model.dart';
import 'package:pikquick/router/router_config.dart';

class Tasklocation extends StatefulWidget {
  const Tasklocation({super.key, required this.data});

  final Map data;

  @override
  State<Tasklocation> createState() => _TasklocationState();
}

class _TasklocationState extends State<Tasklocation> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();
  int locationCount = 0;

  Future<AddressModel?> _showMap() async {
    return await context.pushNamed(MyAppRouteConstant.mapBoxFullMapWidget);
  }

  @override
  initState() {
    super.initState();
    pickupController.addListener(
      () {
        taskModelbeingCreated!.pickupAddress = AddressModel(
          addressLine1: pickupController.text,
          city: "",
          state: "",
          postalCode: "",
          country: "",
          latitude: 0,
          longitude: 0,
          isDefault: false,
        );
      },
    );
    dropoffController.addListener(
      () {
        taskModelbeingCreated!.dropoffAddress = AddressModel(
          addressLine1: dropoffController.text,
          city: "",
          state: "",
          postalCode: "",
          country: "",
          latitude: 0,
          longitude: 0,
          isDefault: false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  onPressed: () {
                    context.go(MyAppRouteConstant.setBudget, extra: {
                      'specialInstructions': widget.data['specialInstructions'],
                      'additionalNote': widget.data['additionalNote'],
                      'taskType': widget.data['taskType'],
                      'pickupLocation': pickupController.text.trim(),
                      'drop-off': dropoffController.text.trim(),
                      'longtitude': 0,
                      'latitude': 0
                    });
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Specify task locations",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  fontFamily: 'Oufit'),
            ),
            const SizedBox(height: 20),
            Column(children: [
              _buildLocationField(
                title: 'Task location',
                hint: 'Enter  address',
                imagePath: 'assets/icons/ic1.png',
                controller: pickupController,
              ),
              Row(
                children: [
                  Image.asset('assets/icons/hugeicons_location-04.png'),
                  const SizedBox(width: 8),
                  TextButton(
                    // '${av.taskModelbeingCreated?.description}',
                    onPressed: () async {
                      print("dsjhksajdhjka");

                      final address = await _showMap();
                      taskModelbeingCreated ??= TaskModel.empty();
                      pickupController.text = address?.fullAddress ?? '';
                      taskModelbeingCreated!.pickupAddress = address;

                      print('From dropOff ${address?.toJson()}');
                    },
                    child: Text('Choose map',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4378CD),
                            fontFamily: 'Outfit')),
                  ),
                ],
              ),
            ]),
            if (locationCount == 2)
              SizedBox(
                height: 10,
              ),
            if (locationCount == 2)
              Column(children: [
                _buildLocationField(
                  title: 'Task location',
                  hint: 'Enter  address',
                  imagePath: 'assets/icons/ic1.png',
                  controller: dropoffController,
                ),
                Row(
                  children: [
                    Image.asset('assets/icons/hugeicons_location-04.png'),
                    const SizedBox(width: 8),
                    TextButton(
                      // '${av.taskModelbeingCreated?.description}',
                      onPressed: () async {
                        final address = await _showMap();
                        taskModelbeingCreated ??= TaskModel.empty();
                        dropoffController.text = address?.fullAddress ?? '';
                        taskModelbeingCreated!.dropoffAddress = address;

                        print('From dropOff2 ${address?.toJson()}');
                      },

                      child: const Text('Choose map',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4378CD),
                              fontFamily: 'Outfit')),
                    ),
                  ],
                ),
              ]),
            const SizedBox(
              height: 20,
            ),
            if (locationCount == 1)
              Row(
                children: [
                  Image.asset('assets/icons/hugeicons_location-04.png'),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      locationCount = 2;
                      setState(() {});
                      // context.push(MyAppRouteConstant.map);
                    },
                    child: const Text(
                      "Add another location",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          fontFamily: 'Oufit'),
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildLocationField({
  required String title,
  required String hint,
  required String imagePath,
  required TextEditingController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: const TextStyle(
            fontSize: 16,
          )),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(imagePath, width: 24),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ],
  );
}
