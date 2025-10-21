import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/component/textfilled.dart';
import 'package:pikquick/features/profile/data/model/client_email.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart';
import 'package:pikquick/features/profile/presentation/profile_event.dart';
import 'package:pikquick/features/profile/presentation/profile_state.dart';

class EditMailPage extends StatelessWidget {
  const EditMailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ClientEditProfileSuccessemail) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email updated successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is ClientEditProfileErrorStateemail) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is ClientEditProfileLoadingemail;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Arrow
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios_new, size: 24),
                ),

                const SizedBox(height: 30),

                // Title
                const Text(
                  'Edit Email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'A verification code will be sent to this email.',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Outfit',
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 30),

                // Custom Text Field
                _buildTextField(
                  label: 'Email address',
                  controller: emailController,
                  onSuffixTap: () {},
                ),

                const Spacer(),

                // Update Button
                Center(
                  child: FancyContainer(
                    color: const Color(0xFF4A85E4),
                    borderRadius: BorderRadius.circular(10),
                    height: 50,
                    width: double.infinity,
                    child: InkWell(
                      onTap: isLoading
                          ? null
                          : () {
                              final email = emailController.text.trim();

                              // Basic email validation
                              if (email.isEmpty ||
                                  !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(email)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter a valid email'),
                                  ),
                                );
                                return;
                              }

                              // Dispatch the event to update email
                              final model =
                                  ClientEditProfileEmailModel(email: email);
                              context.read<ProfileBloc>().add(
                                    SubmitClientProfileemailEvent(model),
                                  );
                            },
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
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
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onSuffixTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Outfit",
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        TextFormFieldWithCustomStyles(
          controller: controller,
          label: label,
          hintText: 'Enter your $label',
          fillColor: Colors.transparent,
          labelColor: Colors.black,
          textColor: Colors.black,
          keyboardType: TextInputType.emailAddress,
          onSuffixTap: onSuffixTap,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
