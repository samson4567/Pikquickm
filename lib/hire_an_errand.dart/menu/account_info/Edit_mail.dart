import 'package:flutter/material.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/component/textfilled.dart';

class Editmail extends StatelessWidget {
  const Editmail({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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

            // Subtext
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'Outfit',
              ),
            ),

            const SizedBox(height: 20),

            // Custom Text Field
            _buildTextField(
              label: 'Your Email',
              controller: nameController,

              onSuffixTap: () {}, // No action needed for name field
            ),
            const Text(
              'A verification code will be sent to this mail',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                fontFamily: 'Outfit',
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            Center(
              child: FancyContainer(
                color: const Color(0xFF4A85E4),
                borderRadius: BorderRadius.circular(10),
                height: 50,
                width: 342,
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
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        TextFormFieldWithCustomStyles(
          controller: controller,
          label: label,
          hintText: 'Enter your $label',
          fillColor: Colors.white,
          labelColor: const Color(0xFF98A2B3),
          textColor: const Color(0xFF98A2B3),
          onSuffixTap: onSuffixTap,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
