import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/router/router_config.dart';

class VerifyEmail extends StatefulWidget {
  final String email;

  const VerifyEmail({super.key, required this.email});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  Color _buttonColor = const Color(0xFF98A2B3);
  bool isVerifying = false;
  bool isResending = false;
  int resendTimer = 60;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _addListeners();
  }

  void _addListeners() {
    for (var controller in _controllers) {
      controller.addListener(_updateButtonColor);
    }
  }

  void _updateButtonColor() {
    bool allFieldsFilled =
        _controllers.every((controller) => controller.text.isNotEmpty);
    setState(() {
      _buttonColor =
          allFieldsFilled ? const Color(0xFF4378CD) : const Color(0xFF98A2B3);
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

  void _verifyCode() async {
    String enteredCode =
        _controllers.map((controller) => controller.text).join();

    if (enteredCode.length < 6) {
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

    // Simulate a fake API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isVerifying = false;
    });

    // Fake verification logic: accept if code == "123456"
    if (enteredCode == "123456") {
      _showDialog(
        type: 'success',
        title: 'Verified!',
        message: 'Your email has been successfully verified.',
      );
    } else {
      _showDialog(
        type: 'error',
        title: 'Verification Failed',
        message: 'The code you entered is incorrect. Please try again.',
      );
    }
  }

  void _resendOtp() {
    if (resendTimer > 0) return;

    setState(() {
      isResending = true;
      resendTimer = 60;
    });

    _startResendTimer();

    // Simulate sending new OTP
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isResending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A new OTP has been sent!')),
        );
      }
    });
  }

  void _showDialog({
    required String type,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) {
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
                    context.go(MyAppRouteConstant.welcome);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF9F9F9),
                      ),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
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
                          'Create new account',
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
    );
  }
}
