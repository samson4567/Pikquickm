import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart' as av;
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/features/task/data/model/taskcreation_model.dart';
import 'package:pikquick/features/task/domain/entitties/taskcreation_entity.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:pikquick/router/router_config.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  double fareAmount = 0.00;
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();
  bool hasTwoAddress = false;

  Future<dynamic> _showMap() async {
    return await context.pushNamed(MyAppRouteConstant.mapBoxFullMapWidget);
  }

  @override
  void initState() {
    super.initState();

    // Initialize task model if null
    av.taskModelbeingCreated ??= TaskModel.empty();
    av.taskModelbeingCreated?.paymentMethod = "wallet";

    // Set hasTwoAddress BEFORE using it in conditional logic
    hasTwoAddress =
        av.twoAddressedTaskCategory.contains(av.taskModelbeingCreated?.name) ??
            false;

    // Initialize controllers with existing address data if available
    if (av.taskModelbeingCreated?.pickupAddress != null) {
      pickupController.text =
          av.taskModelbeingCreated!.pickupAddress!.addressLine1 ?? '';
    }

    if (hasTwoAddress && av.taskModelbeingCreated?.dropoffAddress != null) {
      dropoffController.text =
          av.taskModelbeingCreated!.dropoffAddress!.addressLine2 ?? '';
    }

    // Setup listeners
    pickupController.addListener(() {
      if (av.taskModelbeingCreated != null) {
        av.taskModelbeingCreated!.pickupAddress = AddressModel(
          addressLine1: pickupController.text,
          addressLine2: "",
          city: "",
          state: "",
          postalCode: "",
          country: "",
          countryCode: "",
          latitude: 0,
          longitude: 0,
          isDefault: false,
          label: '',
          description: '',
        );
      }
    });

    dropoffController.addListener(() {
      if (hasTwoAddress && av.taskModelbeingCreated != null) {
        av.taskModelbeingCreated!.dropoffAddress = AddressModel(
          addressLine1: dropoffController.text,
          addressLine2: "",
          city: "",
          state: "",
          postalCode: "",
          country: "",
          countryCode: "",
          latitude: 0,
          longitude: 0,
          isDefault: false,
          label: '',
          description: '',
        );
      }
    });
  }

  AddressModel? _parseAddress(dynamic result) {
    try {
      if (result == null) return null;

      // Handle AddressModel directly
      if (result is AddressModel) return result;

      // Handle Map conversion
      if (result is Map) {
        final Map<String, dynamic> map = result.cast<String, dynamic>();
        try {
          return AddressModel.fromJson(map);
        } catch (e) {
          debugPrint('Error converting map to AddressModel: $e');
          return null;
        }
      }

      // Handle AddressEntity conversion
      if (result is AddressEntity) {
        return AddressModel(
          addressLine1: result.addressLine1 ?? '',
          addressLine2: result.addressLine2 ?? '',
          city: result.city ?? '',
          state: result.state ?? '',
          postalCode: result.postalCode ?? '',
          country: result.country ?? '',
          countryCode: result.countryCode,
          latitude: result.latitude ?? 0,
          longitude: result.longitude ?? 0,
          isDefault: result.isDefault ?? false,
          label: result.label ?? '',
          description: '',
        );
      }

      // Handle String (just the address text)
      if (result is String) {
        return AddressModel(
          addressLine1: result,
          addressLine2: '',
          city: '',
          state: '',
          postalCode: '',
          country: '',
          countryCode: null,
          latitude: 0,
          longitude: 0,
          isDefault: false,
          label: '',
          description: '',
        );
      }

      debugPrint('Map route returned unexpected type: ${result.runtimeType}');
      return null;
    } catch (e, st) {
      debugPrint('Error parsing address from map route: $e\n$st');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskCreationSuccessState) {
          av.taskModelbeingCreated =
              TaskModel.fromTaskEntity(state.resultantTaskModel);
          context.go(MyAppRouteConstant.runner);
        } else if (state is TaskCreationErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      av.taskModelbeingCreated?.name ?? "Task",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                Text(
                  av.taskModelbeingCreated?.description ?? "",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 25),

                // pickup field & map button
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLocationField(
                      title:
                          !hasTwoAddress ? 'Task Location' : 'Pickup Location',
                      hint: !hasTwoAddress
                          ? 'Enter address'
                          : 'Enter pickup address',
                      imagePath: 'assets/icons/ic1.png',
                      controller: pickupController,
                    ),
                    Row(
                      children: [
                        Image.asset('assets/icons/hugeicons_location-04.png'),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () async {
                            print("dsjsabdsjadas-observation-started");
                            final dynamic result = await _showMap();
                            print("dsjsabdsjadas-observation-_showMap-ended");
                            print(
                                "dsjsabdsjadas-observation-result_is>>$result");
                            final AddressModel? selected =
                                _parseAddress(result);
                            print(
                                "dsjsabdsjadas-observation-result_is>>$selected");

                            if (selected != null && mounted) {
                              setState(() {
                                pickupController.text = selected.addressLine1!;
                                av.taskModelbeingCreated ??= TaskModel.empty();
                                av.taskModelbeingCreated!.pickupAddress =
                                    selected;
                              });
                              debugPrint(
                                  'Selected pickup address: ${selected.toJson()}');
                            } else {
                              debugPrint('No address selected (pickup).');
                            }
                          },
                          child: const Text(
                            'Choose map',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4378CD),
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // dropoff field if required
                if (hasTwoAddress)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildLocationField(
                        title: 'Drop-off Location',
                        hint: 'Enter delivery address',
                        imagePath: 'assets/icons/ic1.png',
                        controller: dropoffController,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Image.asset('assets/icons/hugeicons_location-04.png'),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () async {
                              final dynamic result = await _showMap();
                              final AddressModel? selected =
                                  _parseAddress(result);

                              if (selected != null && mounted) {
                                setState(() {
                                  dropoffController.text =
                                      selected.addressLine2!;
                                  av.taskModelbeingCreated ??=
                                      TaskModel.empty();
                                  av.taskModelbeingCreated!.dropoffAddress =
                                      selected;
                                });
                                debugPrint(
                                    'Selected dropoff address: ${selected.toJson()}');
                              } else {
                                debugPrint('No address selected (dropoff).');
                              }
                            },
                            child: const Text(
                              'Choose map',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4378CD),
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                const SizedBox(height: 30),

                // fare selector
                const Text('Offer Your Fare',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                const SizedBox(height: 15),
                _buildFareSelector(),

                const SizedBox(height: 40),
                const Text('Payment Method',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                const SizedBox(height: 15),
                _buildPaymentOption('App Wallet', true, 'assets/icons/ic1.png'),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: FancyContainer(
                    color: const Color(0xFF4378CD),
                    onTap: () {
                      if (av.taskModelbeingCreated != null && _validateForm()) {
                        print(
                            "ajsbdajkdbskjbdsadabda-av.taskModelbeingCreated-${av.taskModelbeingCreated}");
                        AddressModel;
                        context.read<TaskBloc>().add(TaskCreationEvent(
                            taskModel: av.taskModelbeingCreated!));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please fill in required fields')),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    height: 50,
                    width: 342,
                    child: const Center(
                      child: Text(
                        'View available runner ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit',
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _validateForm() {
    if (pickupController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter pickup address')),
      );
      return false;
    }

    if (hasTwoAddress && dropoffController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter dropoff address')),
      );
      return false;
    }

    if (fareAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid fare amount')),
      );
      return false;
    }

    return true;
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
              fontWeight: FontWeight.bold,
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

  Widget _buildFareSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/100.png', width: 24),
          const SizedBox(width: 10),
          const Text('₦', style: TextStyle(fontSize: 18)),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: fareAmount.toStringAsFixed(2),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              onChanged: (value) {
                setState(() {
                  fareAmount = double.tryParse(value) ?? fareAmount;
                  av.taskModelbeingCreated?.budget = fareAmount.toDouble();
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => setState(() {
              fareAmount = (fareAmount - 100).clamp(0, double.infinity);
              av.taskModelbeingCreated?.budget = fareAmount.toDouble();
            }),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() {
              fareAmount += 100;
              av.taskModelbeingCreated?.budget = fareAmount.toDouble();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String text, bool selected, String assetPath) {
    return Row(
      children: [
        Image.asset(
          assetPath,
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Outfit'),
        ),
        const Spacer(),
      ],
    );
  }
}

  // _setSelectedPickupMapBoxPlace();
                          // selectedMapBoxPlace



 // latitude:
                            //     selectedPickupMapBoxPlace?.center?.first ?? 0,
                            // longitude:
                            //     selectedPickupMapBoxPlace?.center?.last ?? 0,

  // _setSelectedMapBoxPlace() async {
  //   selectedMapBoxPlace = await _showMap() ?? selectedMapBoxPlace;
  // }

  // _setSelectedDropOffMapBoxPlace() async {
  //   selectedDropOffMapBoxPlace = await _showMap() ?? selectedDropOffMapBoxPlace;
  // }

  // _setSelectedPickupMapBoxPlace() async {
  //   selectedPickupMapBoxPlace = await _showMap() ?? selectedPickupMapBoxPlace;
  // }

  // Future<MapBoxPlace?> _showMap() async {
  //   return await context
  //       .push<MapBoxPlace>(MyAppRouteConstant.mapBoxFullMapWidget);
  // }



   // addressLine1:
                            //     selectedPickupMapBoxPlace?.placeName ?? "",

                             // context
                    //   .read<TaskBloc>()
                    //   .add(InviteRunnerToTaskEvent(runnerId: profileModel));
                    // context.go(MyAppRouteConstant.runner);
                                                // context.pushReplacement(MyAppRouteConstant.map);
                                                 // _setSelectedDropOffMapBoxPlace();
                            // selectedMapBoxPlace