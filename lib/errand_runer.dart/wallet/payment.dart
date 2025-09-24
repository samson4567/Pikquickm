import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/component/textfilled.dart';
import 'package:pikquick/router/router_config.dart';

class AddPaymentMethodPage extends StatefulWidget {
  const AddPaymentMethodPage({super.key});

  @override
  State<AddPaymentMethodPage> createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _role = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isChecked = false;
  Color _buttonColor = const Color(0xFF98A2B3);

  void _validateFields() {
    setState(() {
      if (_fullNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text &&
          _isChecked) {
        _buttonColor = const Color(0xFF4378CD);
      } else {
        _buttonColor = const Color(0xFF98A2B3);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_validateFields);
    _role.addListener(_validateFields);
    _emailController.addListener(_validateFields);
    _phoneController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
    _confirmPasswordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _role.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 60, right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios_new, size: 28),
            ),
            const SizedBox(height: 20),
            const Text(
              'AddPaymentMethod',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Outfit',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
              'The account will be set as default payout \nmethod',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 13),
            _buildInputField("Bank Name", _fullNameController),
            _buildInputField("Account Number ", _role),
            _buildInputField("Account Holder Name ", _emailController,
                TextInputType.emailAddress),
            Center(
              child: FancyContainer(
                onTap: () {
                  context.push(MyAppRouteConstant.verifyPayment);
                },
                borderRadius: BorderRadius.circular(10),
                height: 50,
                width: 342,
                color: _buttonColor,
                child: const Center(
                  child: Text(
                    'Save & Continue',
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

  Widget _buildInputField(String label, TextEditingController controller,
      [TextInputType? keyboardType]) {
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
          keyboardType: keyboardType ?? TextInputType.text,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
