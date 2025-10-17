import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pikquick/app_variable.dart' as app_var;
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_text.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart';
import 'package:pikquick/features/profile/presentation/profile_event.dart';
import 'package:pikquick/features/profile/presentation/profile_state.dart';
import 'package:pikquick/hire_an_errand.dart/menu/account_info/Edit_mail.dart';
import 'package:pikquick/hire_an_errand.dart/menu/account_info/edit_phone.dart';
import 'package:pikquick/hire_an_errand.dart/menu/account_info/name_update.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  // Widget _buildBrowseFileButton(BuildContext context) {
  //   // The button has a light background and a rounded shape
  //   return FancyContainer2(
  //     action: () async {
  //       await _showImagePickerOptions();

  //       // addressVerificationKycRequestEntity!.file = _selectedImage;

  //       // addressDocumentUploadScreen
  // context.read<AuthBloc>().add(
  //       UploadkycDocumentEvent(
  //           kycRequestEntity: addressVerificationKycRequestEntity!),
  //     );
  //       print('Browse File button pressed');
  //     },
  //     isAsync: false,
  //     backgroundColor: Colors.grey.shade100,
  //     radius: 8,
  //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
  //     child: FancyText(
  //       'Browse File',
  //       size: 16,
  //       weight: FontWeight.w600,
  //       textColor: Colors.black,
  //     ),
  //   );
  // }

  @override
  initState() {
    super.initState();
    _picker = ImagePicker();
  }

  Future<void> _showImagePickerOptions() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Select Profile Picture',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () async {
                      await _pickImageFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                  _buildImageOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () async {
                      await _pickImageFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future _pickImageFromCamera() async {
    print("dksnakdlasdkajsnd");
    try {
      final XFile? image = await _picker?.pickImage(
        source: ImageSource.camera,
        // maxWidth: 800,
        // maxHeight: 800,
        imageQuality: 80,
      );

      print("dksnakdlasdkajsnd-XFile_image_is>${image}");
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture captured successfully!'),
            backgroundColor: Color(0xFF6C5CE7),
          ),
        );
      }
      print("dksnakdlasdkajsnd-success");
    } catch (e) {
      print("dksnakdlasdkajsnd-error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing image: ${e.toString()}')),
      );
    }
  }

  File? _selectedImage;
  Future _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker?.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        // imageData = await image.readAsBytes();
        setState(() {
          _selectedImage = File(image.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture selected successfully!'),
            backgroundColor: Color(0xFF6C5CE7),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: ${e.toString()}')),
      );
    }
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFF6C5CE7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, size: 30, color: Color(0xFF6C5CE7)),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  ImagePicker? _picker;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 20),
        child:
            BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
          if (state is UploadProfilePictureErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
          if (state is UploadProfilePictureSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        }, builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Arrow
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.arrow_back_ios_new, size: 24),
              ),

              const SizedBox(height: 50),

              // Page Title
              const Text(
                'Account Info',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // Profile Picture with Edit Icon
              Stack(
                children: [
                  (_selectedImage != null)
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(_selectedImage!)
                          //  (userModelG?.imageUrl != null)
                          //     ? NetworkImage(userModelG!.imageUrl!)
                          //     : AssetImage('assets/images/circle.png'),
                          // child:   ,
                          )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: (userModelG?.imageUrl != null)
                              ? NetworkImage(userModelG!.imageUrl!)
                              : AssetImage('assets/images/circle.png'),
                          // child:   ,
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        print("bsjbkdasdkasjbdsb");
                        _showImagePickerOptions();
                        if (_selectedImage != null) {
                          context.read<ProfileBloc>().add(
                                UploadProfilePictureEvent(
                                    file: _selectedImage!),
                              );
                        }
                      },
                      child: Container(
                          // padding: const EdgeInsets.all(4),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.edit_rounded,
                            size: 20,
                          )
                          // Image.asset(
                          //   'assets/icons/ediit.png',
                          //   width: double.infinity,
                          //   height: double.infinity,
                          // ),
                          ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                'Basic info',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              // Name
              _infoRow(
                title: 'Name',
                value: app_var.userModelG?.fullName ?? 'Not set',
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => const EditNamePage()),
                  // );
                },
              ),

              const SizedBox(height: 20),

              _infoRow(
                title: 'Phone Number',
                value: app_var.userModelG?.phone ?? 'Not set',
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => const EditPhone()),
                  // );
                },
              ),

              const SizedBox(height: 20),

              _infoRow(
                title: 'Email',
                value: app_var.userModelG?.email ?? 'Not set',
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => const EditMailPage()),
                  // );
                },
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _infoRow({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Title and Value
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),

          // Right arrow icon
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
