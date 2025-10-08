import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/core/di/injector.dart';
import 'package:pikquick/features/authentication/data/models/usermodel.dart';
import 'package:pikquick/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:pikquick/router/router_config.dart';

class VerifyEmail extends StatefulWidget {
  final String email;
  final String otp;
  const VerifyEmail({super.key, required this.email, required this.otp});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<bool> _isObscured = List.generate(6, (index) => true);

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

  void _verifyCode() {
    String otp = _controllers.map((controller) => controller.text).join();

    if (otp.length < 6) {
      _showDialog(
        type: 'error',
        title: 'Invalid OTP',
        message: 'The OTP you entered is incorrect - kindly try again.',
      );
      return;
    }

    context
        .read<AuthBloc>()
        .add(VerifyNewSignUpEmailEvent(email: widget.email, otp: otp));
  }

  void _resendOtp() {
    if (resendTimer > 0 || isResending) return;

    setState(() {
      isResending = true;
      resendTimer = 60;
    });

    _startResendTimer();
    context
        .read<AuthBloc>()
        .add(ResendOtpEvent(email: widget.email, otp: widget.otp));
  }

  void _showDialog({
    required String type,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF9F9F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          content: SizedBox(
            width: 300,
            height: 295,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  type == 'success'
                      ? 'assets/images/con2.png'
                      : 'assets/images/con.png',
                  width: 70,
                  height: 70,
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (type == 'success') {
                        context.read<AuthBloc>().add(LoginEvent(
                              email: signUpProcessEmail,
                              password: signUpProcessPassword,
                            ));
                        context.pushNamed(MyAppRouteConstant.dashBoardScreen);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: type == 'success'
                          ? const Color(0xFF007BFF)
                          : Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      type == 'success' ? 'Continue' : 'Try Again',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
        if (state is LoginLoadingState) {
          setState(() => isVerifying = true);
        } else if (state is LoginSuccessState) {
          setState(() => isVerifying = false);
          getItInstance<AuthenticationRepositoryImpl>()
              .authenticationLocalDatasource;
          setState(() {
            isVerifying = true;
          });
        }
        if (state is LoginSuccessState) {
          setState(() {
            isVerifying = false;
          });
          context
              .read<AuthBloc>()
              .authenticationRepository
              .storeRemainLoggedinvalue(false);
          context
              .read<AuthBloc>()
              .authenticationRepository
              .cacheUserData(UserModel.fromEntity(state.user));

          if (state.user.role == 'client') {
            context.go(MyAppRouteConstant.dashboard);
          } else if (state.user.role == 'runner') {
            context.go(MyAppRouteConstant.dashBoardScreen);
          }
        } else if (state is VerifyNewSignUpEmailLoadingState) {
          setState(() => isVerifying = true);
        } else if (state is VerifyNewSignUpEmailSuccessState) {
          setState(() => isVerifying = false);
          _showDialog(
            type: 'success',
            title: 'Verified!',
            message: 'Your email has been successfully verified.',
          );
        } else if (state is VerifyNewSignUpEmailErrorState) {
          setState(() => isVerifying = false);
          _showDialog(
            type: 'error',
            title: 'Verification Failed',
            message: 'The code you entered is incorrect. Please try again.',
          );
        } else if (state is ResendOtpSuccessState) {
          setState(() => isResending = false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ResendOtpErrorState) {
          setState(() => isResending = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage),
            backgroundColor: Colors.red,
          ));
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            for (int i = 0; i < _isObscured.length; i++) {
              _isObscured[i] = true;
            }
          });
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => context.pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Confirm 6-Digit code',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0XFF434953),
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF98A2B3),
                      fontFamily: 'Outfit',
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'A 6-digit code was sent to '),
                      TextSpan(
                        text: widget.email,
                        style: const TextStyle(
                          color: Color(0xFF4285F4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: '\nEnter the code to continue'),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                /// OTP fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: SizedBox(
                          height: 64,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            obscureText: _isObscured[index],
                            obscuringCharacter: '●',
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
                                fontSize: 18, color: Colors.black),
                            onTap: () {
                              setState(() => _isObscured[index] = false);
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                              Future.delayed(const Duration(milliseconds: 600),
                                  () {
                                if (mounted &&
                                    _controllers[index].text.isNotEmpty) {
                                  setState(() => _isObscured[index] = true);
                                }
                              });
                            },
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
                      style: TextStyle(
                        color: Color(0xFF070D17),
                        fontSize: 16,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    GestureDetector(
                      onTap: _resendOtp,
                      child: Text(
                        resendTimer > 0
                            ? 'Resend in $resendTimer s'
                            : 'Resend code',
                        style: const TextStyle(
                          color: Color(0XFF4A85E4),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                /// Confirm button with smaller loader
                Center(
                  child: FancyContainer(
                    onTap:
                        _buttonColor == const Color(0xFF4378CD) && !isVerifying
                            ? _verifyCode
                            : null,
                    borderRadius: BorderRadius.circular(10),
                    height: 50,
                    width: 342,
                    color: _buttonColor,
                    child: isVerifying
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
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
      ),
    );
  }
}
