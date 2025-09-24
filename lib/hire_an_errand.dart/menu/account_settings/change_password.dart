import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/component/textfilled.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_state.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool isPasswordVisible = false;

  void _showSuccessModal(String title, String message) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/con2.png', height: 60, width: 100),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Color(0xFF4378CD),
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccessState) {
          _showSuccessModal(
            "Password Change",
            "You have successfully changed the password.",
          );
        } else if (state is ChangePasswordErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios_new, size: 24),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Change Password",
                  style: TextStyle(
                    fontFamily: "Outfit",
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Current password",
                  style: TextStyle(fontFamily: "Outfit", color: Colors.black),
                ),
                const SizedBox(height: 10),
                TextFormFieldWithCustomStyles(
                  controller: currentPasswordController,
                  label: "Current Password",
                  hintText: "Enter current password",
                  fillColor: Colors.white,
                  labelColor: const Color(0xFF98A2B3),
                  hintColor: const Color(0xFF98A2B3),
                  textColor: Colors.black,
                  obscureText: !isPasswordVisible,
                  suffixImagePath: 'assets/icons/eyes.png',
                  onSuffixTap: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "New password",
                  style: TextStyle(fontFamily: "Outfit", color: Colors.black),
                ),
                const SizedBox(height: 10),
                TextFormFieldWithCustomStyles(
                  controller: newPasswordController,
                  label: "New Password",
                  hintText: "Enter new password",
                  fillColor: Colors.white,
                  labelColor: const Color(0xFF98A2B3),
                  textColor: Colors.black,
                  obscureText: !isPasswordVisible,
                  suffixImagePath: 'assets/icons/eyes.png',
                  onSuffixTap: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 40),
                FancyContainer(
                  onTap: () {
                    final currentPassword =
                        currentPasswordController.text.trim();
                    final newPassword = newPasswordController.text.trim();

                    if (currentPassword.isNotEmpty && newPassword.isNotEmpty) {
                      context.read<AuthBloc>().add(
                            ChangePasswordEvent(
                              currentPassword: currentPassword,
                              newPassword: newPassword,
                            ),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  height: 50,
                  width: double.infinity,
                  color: const Color(0xFF4378CD),
                  child: const Center(
                    child: Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
