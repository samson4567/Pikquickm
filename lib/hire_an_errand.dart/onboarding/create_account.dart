import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/component/extraction.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/component/textfilled.dart';
import 'package:pikquick/features/authentication/data/models/new_user_request_model.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:pikquick/router/router_config.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isChecked = false;
  Color _buttonColor = const Color(0xFF98A2B3);

  String? _selectedRole;
  // ignore: unused_field
  final List<String> _roles = ['client'];

  @override
  void initState() {
    super.initState();
    _selectedRole = 'client'; // Preselect
    _fullNameController.addListener(_validateFields);
    _emailController.addListener(_validateFields);
    _phoneController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
    _confirmPasswordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidPassword(String password) {
    final regex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');
    return regex.hasMatch(password);
  }

  void _validateFields() {
    final isValid = _fullNameController.text.isNotEmpty &&
        _selectedRole != null &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text &&
        _isChecked &&
        _isValidPassword(_passwordController.text);

    setState(() {
      _buttonColor =
          isValid ? const Color(0xFF4378CD) : const Color(0xFF98A2B3);
    });
  }

  void _handleCreateAccount() {
    final isValid = _fullNameController.text.isNotEmpty &&
        _selectedRole != null &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text &&
        _isChecked &&
        _isValidPassword(_passwordController.text);

    if (isValid) {
      final newUserRequest = NewUserRequestModel(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        role: _selectedRole!,
      );

      context.read<AuthBloc>().add(
            NewUserSignUpEvent(newUserRequest: newUserRequest),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields correctly.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is NewUserSignUpSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.go(MyAppRouteConstant.verifyEmail,
                  extra: _emailController.text);
            } else if (state is NewUserSignUpErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.05, vertical: h * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () =>
                        context.go(MyAppRouteConstant.accountSelection),
                    child: Icon(Icons.arrow_back_ios_new,
                        size: w * 0.07, color: Colors.black),
                  ),
                  SizedBox(height: h * 0.015),
                  Text(
                    'Create account',
                    style: TextStyle(
                      fontSize: w * 0.06,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  Text(
                    'Enter your details below to create your Pikquick account.',
                    style: TextStyle(
                      fontSize: w * 0.035,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Outfit',
                      color: const Color(0xFF98A2B3),
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  _buildInputField(
                      "Full Name", _fullNameController, "e.g., John Doe"),
                  _buildInputField("Email", _emailController,
                      "e.g., johndoe@email.com", TextInputType.emailAddress),
                  _buildPhoneNumberField(),
                  _buildPasswordField(
                    "Password",
                    _passwordController,
                    _obscurePassword,
                    () => setState(() => _obscurePassword = !_obscurePassword),
                    helperText:
                        "Must contain at least 8 characters, with uppercase, lowercase, number, and special symbol.",
                  ),
                  _buildPasswordField(
                    "Confirm Password",
                    _confirmPasswordController,
                    _obscureConfirmPassword,
                    () => setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword),
                    helperText: "Re-enter your password for confirmation.",
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value ?? false;
                            _validateFields();
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          "By signing up, you agree to our Terms of Service.",
                          style: TextStyle(
                            fontFamily: "Outfit",
                            fontSize: w * 0.03,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.015),
                  Center(
                    child: FancyContainer(
                      onTap: state is! NewUserSignUpLoadingState
                          ? _handleCreateAccount
                          : null,
                      borderRadius: BorderRadius.circular(10),
                      height: h * 0.06,
                      width: w * 0.9,
                      color: _buttonColor,
                      child: Center(
                        child: state is NewUserSignUpLoadingState
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Create new account',
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                            fontFamily: "Outfit", fontSize: w * 0.035),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go(MyAppRouteConstant.login);
                        },
                        child: TextButton(
                          onPressed: () =>
                              context.push(MyAppRouteConstant.login),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontFamily: "Outfit",
                              fontSize: w * 0.035,
                              color: const Color(0xFF4378CD),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.02),
                  const Helpterms(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, String hint,
      [TextInputType? keyboardType]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label *",
            style: const TextStyle(fontFamily: "Outfit", color: Colors.black)),
        const SizedBox(height: 5),
        TextFormFieldWithCustomStyles(
          controller: controller,
          label: label,
          hintText: hint,
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

  Widget _buildPhoneNumberField() {
    return _buildInputField(
      "Phone Number",
      _phoneController,
      "e.g., +2348012345678",
      TextInputType.phone,
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool obscureText, VoidCallback onSuffixTap,
      {String? helperText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label *",
            style: const TextStyle(fontFamily: "Outfit", color: Colors.black)),
        const SizedBox(height: 5),
        TextFormFieldWithCustomStyles(
          controller: controller,
          label: label,
          hintText: 'Enter your $label',
          fillColor: Colors.white,
          labelColor: const Color(0xFF98A2B3),
          textColor: const Color(0xFF98A2B3),
          obscureText: obscureText,
          suffixImagePath: 'assets/icons/eyes.png',
          onSuffixTap: onSuffixTap,
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: const TextStyle(
                fontSize: 10, color: Color(0xFF98A2B3), fontFamily: "Outfit"),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}
