import 'package:flutter/material.dart';
import 'package:pikquick/component/textfilled.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final cardNumberController = TextEditingController();
  final expDateController = TextEditingController();
  final cvvController = TextEditingController();
  final accountNameController = TextEditingController();

  void showCustomDialog({
    required bool isTopUp,
    required bool isSuccess,
  }) {
    String imageAsset =
        isSuccess ? 'assets/images/welcome.png' : 'assets/icons/pending.png';
    String title = isSuccess ? 'Success!' : 'Pending!';
    String message = isTopUp
        ? (isSuccess
            ? 'Top up successful – your new balance is ₦55,000'
            : 'Your transaction is being processed, pls check back later')
        : (isSuccess ? 'Card saved successfully' : 'Card could not be saved');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: 355,
          height: 295,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image.asset(
                  imageAsset,
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Outfit',
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF0F2F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                        color: Colors.black,
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

  Widget buildTextField(String title, TextFormFieldWithCustomStyles field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Outfit',
          ),
        ),
        const SizedBox(height: 8),
        field,
        const SizedBox(height: 15),
      ],
    );
  }

  bool validateForm() => _formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add card",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 20),
              buildTextField(
                "Card Number",
                TextFormFieldWithCustomStyles(
                  controller: cardNumberController,
                  label: "Card number",
                  hintText: "1234 5678 9012 3456",
                  textColor: Colors.black,
                  fillColor: Colors.white,
                  keyboardType: TextInputType.number,
                  labelColor: const Color(0xFF98A2B3),
                  borderColor: Colors.grey,
                  validator: (value) => value == null || value.length < 16
                      ? "Enter a valid card number"
                      : null,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      "Exp Date",
                      TextFormFieldWithCustomStyles(
                        controller: expDateController,
                        label: "MM/YY",
                        hintText: 'MM/YY',
                        labelColor: const Color(0xFF98A2B3),
                        textColor: Colors.black,
                        fillColor: Colors.transparent,
                        borderColor: Colors.grey,
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter Exp. Date"
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: buildTextField(
                      "CVV",
                      TextFormFieldWithCustomStyles(
                        controller: cvvController,
                        label: "123",
                        labelColor: const Color(0xFF98A2B3),
                        hintText: "123",
                        textColor: Colors.black,
                        fillColor: Colors.transparent,
                        keyboardType: TextInputType.number,
                        borderColor: Colors.grey,
                        obscureText: true,
                        validator: (value) => value == null || value.length < 3
                            ? "Enter valid CVV"
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              buildTextField(
                "Account Name",
                TextFormFieldWithCustomStyles(
                  controller: accountNameController,
                  label: "Account Name",
                  hintText: "John Doe",
                  labelColor: const Color(0xFF98A2B3),
                  textColor: Colors.black,
                  fillColor: Colors.transparent,
                  keyboardType: TextInputType.name,
                  borderColor: Colors.grey,
                  validator: (value) => value == null || value.isEmpty
                      ? "Enter account name"
                      : null,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (validateForm()) {
                    showCustomDialog(isTopUp: false, isSuccess: true);
                  } else {
                    showCustomDialog(isTopUp: false, isSuccess: false);
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (validateForm()) {
                      showCustomDialog(isTopUp: true, isSuccess: true);
                    } else {
                      showCustomDialog(isTopUp: true, isSuccess: false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Proceed to add money",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
