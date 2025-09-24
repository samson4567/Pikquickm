import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/component/textfilled.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_state.dart';

class RessetPassword extends StatefulWidget {
  final String email;
  final String token;

  const RessetPassword({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<RessetPassword> createState() => _RessetPasswordState();
}

class _RessetPasswordState extends State<RessetPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  bool isPasswordVisible = false;

  void _handlePasswordChange() {
    final newPassword = newPasswordController.text.trim();

    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a new password")),
      );
      return;
    }

    context.read<AuthBloc>().add(
          RessetPasswordEvent(
            email: widget.email,
            token: widget.token,
            newPassword: newPassword,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ResetPassowordSuccessState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Success"),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        } else if (state is ResetPassowordErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios_new, size: 24),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Reset Password",
                  style: TextStyle(
                    fontFamily: "Outfit",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
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
                const Spacer(),
                Center(
                  child: FancyContainer(
                    onTap: _handlePasswordChange,
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
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
