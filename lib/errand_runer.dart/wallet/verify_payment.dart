import 'dart:async';
import 'package:flutter/material.dart';

import 'package:pikquick/component/fancy_container.dart';

class VerifyPayment extends StatefulWidget {
  final String email;

  const VerifyPayment({super.key, required this.email});

  @override
  State<VerifyPayment> createState() => _VerifyPaymentState();
}

class _VerifyPaymentState extends State<VerifyPayment> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  bool isVerifying = false;
  bool isResending = false;
  int resendTimer = 60;
  Timer? _resendCountdown;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendCountdown?.cancel();
    _resendCountdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer > 0) {
        setState(() {
          resendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
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

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isVerifying = false;
    });

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

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isResending = false;
      });
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
              type == 'success'
                  ? Image.asset(
                      'assets/images/con.png',
                      height: 80,
                    )
                  : Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 80,
                    ),
              const SizedBox(height: 16),
              Text(
                type == 'success' ? 'Payment method added' : title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                type == 'success'
                    ? 'You can now withdraw to your payment method'
                    : message,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (type == 'success') {
                    Navigator.pop(context); // or go to payment methods screen
                  }
                },
                child:
                    Text(type == 'success' ? 'Back to methods' : 'Try Again'),
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
    _resendCountdown?.cancel();
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
              child: GestureDetector(
                onTap: isVerifying ? null : _verifyCode,
                child: FancyContainer(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  height: 50,
                  width: 342,
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
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
