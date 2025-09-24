import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/router/router_config.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_state.dart';

class VerifyResetOtp extends StatefulWidget {
  final String email;

  const VerifyResetOtp({super.key, required this.email});

  @override
  State<VerifyResetOtp> createState() => _VerifyResetOtpState();
}

class _VerifyResetOtpState extends State<VerifyResetOtp> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Color _buttonColor = const Color(0xFF98A2B3);
  bool isVerifying = false;
  bool isResending = false;
  int resendTimer = 60;
  String enteredOtp = '';

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _addListeners();
  }

  void _addListeners() {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(() => _updateButtonColor());
    }
  }

  void _updateButtonColor() {
    bool allFilled =
        _controllers.every((controller) => controller.text.isNotEmpty);
    setState(() {
      _buttonColor =
          allFilled ? const Color(0xFF4378CD) : const Color(0xFF98A2B3);
    });
  }

  void _startResendTimer() {
    if (resendTimer > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            resendTimer--;
          });
          _startResendTimer();
        }
      });
    }
  }

  void _verifyCode() {
    final otp = _controllers.map((e) => e.text).join();
    enteredOtp = otp;

    if (otp.length < 6) {
      _showDialog(
        type: 'error',
        title: 'Invalid OTP',
        message: 'The OTP you entered is incorrect - kindly try again.',
      );
      return;
    }

    setState(() {
      isVerifying = true;
    });

    context.read<AuthBloc>().add(
          VerifyResetOTPEvent(email: widget.email, otp: otp),
        );
  }

  void _resendOtp() async {
    if (resendTimer > 0 || isResending) return;

    setState(() {
      isResending = true;
      resendTimer = 60;
    });

    _startResendTimer();

    context.read<AuthBloc>().add(ResendOtpEvent(email: widget.email));
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isResending = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP resent successfully")),
    );
  }

  void _showDialog({
    required String type,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                type == 'success' ? Icons.check_circle : Icons.error,
                color: type == 'success' ? Colors.green : Colors.red,
                size: 80,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (type == 'success') {
                    context.goNamed(
                      MyAppRouteConstant.ressetPassword,
                      extra: {
                        'email': widget.email,
                        'token': enteredOtp,
                      },
                    );
                  }
                },
                child: Text(type == 'success' ? 'Continue' : 'Try Again'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        setState(() {
          isVerifying = false;
        });

        if (state is VerifyResetOTPSuccessState) {
          _showDialog(
            type: 'success',
            title: 'Verified!',
            message: state.message,
          );
        } else if (state is VerifyResetOTPErrorState) {
          _showDialog(
            type: 'error',
            title: 'Error',
            message: state.errorMessage,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Confirm 6-digit code',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A 6-digit code was sent to ${widget.email}\nEnter the code to continue',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SizedBox(
                      width: 50,
                      height: 64,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9F9F9),
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    "Didn't get a code? ",
                    style: TextStyle(color: Color(0xFF98A2B3), fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: _resendOtp,
                    child: Text(
                      resendTimer > 0
                          ? 'Resend in $resendTimer s'
                          : 'Resend code',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: FancyContainer(
                  onTap: _buttonColor == const Color(0xFF4378CD)
                      ? _verifyCode
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  height: 50,
                  width: 342,
                  color: _buttonColor,
                  child: isVerifying
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Center(
                          child: Text(
                            'Confirm code',
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
