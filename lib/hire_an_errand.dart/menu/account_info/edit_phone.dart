import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pikquick/component/fancy_container.dart';

class EditPhone extends StatelessWidget {
  const EditPhone({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    return Scaffold(
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

            const Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'Outfit',
              ),
            ),

            const SizedBox(height: 20),

            IntlPhoneField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: Color(0xFF98A2B3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xFF4A85E4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              initialCountryCode: 'NG',
              onChanged: (phone) {},
            ),

            const Text(
              'A verification code will be sent to this number',
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
}
