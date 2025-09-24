import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // <-- Added
import 'package:pikquick/app_variable.dart' as av;
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/component/textfilled.dart';
import 'package:pikquick/features/profile/data/model/profile_model.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart'; // <-- Added
import 'package:pikquick/features/profile/presentation/profile_event.dart'; // <-- Added
import 'package:pikquick/features/profile/presentation/profile_state.dart'; // <-- Added
// import 'package:pikquick/mapbox/confirm_location_map.dart';
// import 'package:pikquick/mapbox/location_model.dart';

class EditProfileSetup extends StatefulWidget {
  const EditProfileSetup({super.key});

  @override
  State<EditProfileSetup> createState() => _EditProfileSetupState();
}

class _EditProfileSetupState extends State<EditProfileSetup> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  final List<String> _modeTransport = [
    'walk',
    'bicycle',
    'motorcycle',
    'Vehicle',
  ];
  final List<String> _languageProficency = [
    'Yoruba',
    'English',
    'Igbo',
    'Hausa',
  ];

  // final Map<String, bool> _selectedDays = {};
  final Map<String, bool> _selectedTransportMode = {};
  final Map<String, bool> _selectLang = {};
  // LocationModel? selectedLocationModel;

  @override
  void initState() {
    super.initState();

    for (var transport in _modeTransport) {
      _selectedTransportMode[transport] = false;
    }
    for (var language in _languageProficency) {
      _selectLang[language] = false;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void _submitProfile() {
    final selectedModes = _selectedTransportMode.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final selectedLanguages = _selectLang.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // final latLng = selectedLocationModel?.latLng;

    final profileEditModel = ProfileEditModel(
      bio: _bioController.text,
      transportMode: selectedModes.isNotEmpty ? selectedModes.first : 'walk',
      specializedTasks: [], // Add if applicable
      languages: selectedLanguages,
      latitude: 0,
      //  latLng != null && latLng.length > 0 ? latLng[0] : 0.0,
      longitude: 0,
      //  latLng != null && latLng.length > 1 ? latLng[1] : 0.0,
      country: "",
      // selectedLocationModel?.country ?? '',
      state: "",
      // selectedLocationModel?.state ?? '',
      city: "",
      // selectedLocationModel?.city ?? '',
      street: "",
      // selectedLocationModel?.id ?? '',
    );

    // Dispatch to Bloc
    context.read<ProfileBloc>().add(
        ProfileSetupEvent(profileEditModel: profileEditModel)); // <-- Added
  }

  void showProfileUpdatedModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 50),
              const SizedBox(height: 16),
              const Text(
                "Profile Updated",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Your profile has been successfully updated!"),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child:
                    const Text("Okay", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, [
    TextInputType inputType = TextInputType.text,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontFamily: "Outfit", color: Colors.black)),
        const SizedBox(height: 10),
        TextFormFieldWithCustomStyles(
          controller: controller,
          label: label,
          hintText: 'Enter your $label',
          fillColor: Colors.white,
          labelColor: const Color(0xFF98A2B3),
          hintColor: const Color(0xFF98A2B3),
          textColor: const Color(0xFF98A2B3),
          keyboardType: inputType,
          maxLines: inputType == TextInputType.multiline ? 4 : 1,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      // <-- Added
      listener: (context, state) {
        if (state is ProfileLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          Navigator.of(context).pop(); // remove loading
        }

        if (state is ProfileSuccessState) {
          showProfileUpdatedModal();
        }

        if (state is ProfileErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${state.errorMessage}")),
          );
        }
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      child: const CircleAvatar(
                        radius: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Basic info',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildInputField("Full Name", _fullNameController),
                  _buildInputField(
                      "Email", _emailController, TextInputType.emailAddress),
                  _buildInputField(
                      "Phone Number", _phoneController, TextInputType.phone),
                  _buildInputField(
                      "Bio/About Me", _bioController, TextInputType.multiline),
                  const SizedBox(height: 20),
                  const Text('Availability & Working Hours',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit')),
                  const SizedBox(height: 10),
                  const Text("00:00 AM  |  00:00 PM",
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  const Text("Days Available",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Outfit")),
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  const Text('Location',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit')),
                  const SizedBox(height: 10),
                  av.FancyContainer(
                    action: () async {
                      // selectedLocationModel = await Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (context) => ConfirmLocationMap(
                      //           locationModel: av.dummyVendorLocationModel,
                      //         ),
                      //       ),
                      //     ) ??
                      //     selectedLocationModel;
                      // setState(() {});
                    },
                    backgroundColor: Colors.blue,
                    radius: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        // (selectedLocationModel != null)
                        //     ? "${selectedLocationModel?.fullAddress}"
                        //     :
                        "Select a location",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Transport Mode',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit')),
                  Column(
                    children: _modeTransport.map((transport) {
                      return Row(
                        children: [
                          Checkbox(
                            value: _selectedTransportMode[transport],
                            onChanged: (val) {
                              setState(() {
                                _selectedTransportMode[transport] =
                                    val ?? false;
                              });
                            },
                          ),
                          Text(transport,
                              style: const TextStyle(
                                  fontSize: 16, fontFamily: 'Outfit')),
                        ],
                      );
                    }).toList(),
                  ),
                  const Text('Language Proficiency',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit')),
                  Column(
                    children: _languageProficency.map((language) {
                      return Row(
                        children: [
                          Checkbox(
                            value: _selectLang[language],
                            onChanged: (val) {
                              setState(() {
                                _selectLang[language] = val ?? false;
                              });
                            },
                          ),
                          Text(language,
                              style: const TextStyle(
                                  fontSize: 16, fontFamily: 'Outfit')),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _submitProfile,
                    child: FancyContainer(
                      borderRadius: BorderRadius.circular(15),
                      height: 50,
                      width: double.infinity,
                      color: Colors.blue,
                      child: const Center(
                        child: Text('Update',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Column(
//                 children: _days.map((day) {
//                   return Row(
//                     children: [
//                       Checkbox(
//                         value: _selectedDays[day],
//                         onChanged: (val) {
//                           setState(() {
//                             _selectedDays[day] = val ?? false;
//                           });
//                         },
//                       ),
//                       Text(
//                         day,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontFamily: 'Outfit',
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),

//  for (var day in _days) {
//     _selectedDays[day] = false;
//   }

//  final selectedDays = _selectedDays.entries
//       .where((entry) => entry.value)
//       .map((entry) => entry.key)
//       .toList();
// File? _imageFile;

// final List<String> _days = [
//   'Monday',
//   'Tuesday',
//   'Wednesday',
//   'Thursday',
//   'Friday',
//   'Saturday'
// ];

// backgroundImage: _imageFile != null
//                         ? FileImage(_imageFile!)
//                         : const AssetImage('assets/images/circle.png')
//                             as ImageProvider,

// Widget _buildDropdown(String label, String? value, List<String> options,
//     ValueChanged<String?> onChanged) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(label,
//           style: const TextStyle(fontFamily: "Outfit", color: Colors.black)),
//       const SizedBox(height: 10),
//       DropdownButtonFormField<String>(
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         ),
//         value: value,
//         items: options
//             .map((option) => DropdownMenuItem(
//                   value: option,
//                   child: Text(option),
//                 ))
//             .toList(),
//         onChanged: onChanged,
//       ),
//       const SizedBox(height: 16),
//     ],
//   );
// }

// Future<void> _pickImage() async {
//   final pickedFile =
//       await ImagePicker().pickImage(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     setState(() {
//       _imageFile = File(pickedFile.path);
//     });
//   }
// }

// _buildDropdown(
//     "Country", _selectedCountry, ['Nigeria', 'Ghana', 'Kenya'],
//     (val) {
//   setState(() {
//     _selectedCountry = val;
//   });
// }),
// _buildDropdown(
//     "State", _selectedState, ['Lagos', 'Abuja', 'Kano'], (val) {
//   setState(() {
//     _selectedState = val;
//   });
// }),
// const SizedBox(height: 20),
// const Text(
//   'Areas You Can Cover',
//   style: TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.bold,
//     fontFamily: 'Outfit',
//   ),
// ),

// const SizedBox(height: 10),
// _buildDropdown("Enter task location", _selectedTaskLocation,
//     ['Lekki', 'Aja', 'Epe'], (val) {
//   setState(() {
//     _selectedTaskLocation = val;
//   });
// }),
