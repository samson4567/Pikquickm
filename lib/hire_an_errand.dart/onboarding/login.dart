import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart' as av;
import 'package:pikquick/component/extraction.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/component/textfilled.dart';
import 'package:pikquick/core/di/injector.dart';
import 'package:pikquick/features/authentication/data/models/usermodel.dart';
import 'package:pikquick/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart';
import 'package:pikquick/features/profile/presentation/profile_event.dart';
import 'package:pikquick/router/router_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      emailController.text =
          //
          // "keder.runner1@gmaiil.com";
          'sam.client1@gmail.com';
      passwordController.text = 'Password@123';
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
        if (state is LoginSuccessState) {
          // ignore: unused_local_variable
          // if()
          context
              .read<AuthBloc>()
              .authenticationRepository
              .storeRemainLoggedinvalue(rememberMe);
          context
              .read<AuthBloc>()
              .authenticationRepository
              .cacheUserData(UserModel.fromEntity(state.user));

          final taskId = av.taskId?.taskId ?? '';
          if (state.user.role == 'client') {
            context.go(
              MyAppRouteConstant.dashboard,
              extra: {
                'taskId': '39a9e988-1a3c-414e-9f1c-84c8ada685c3',
                'bidId': '8fb5eba5-6764-4493-bf5f-046998010bf1'
              },
            );
            return;
          }

          if (state.user.role == 'runner') {
            context.go(MyAppRouteConstant.dashBoardScreen);
            return;
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),

                  // Welcome Text
                  GestureDetector(
                    onTap: () {
                      context.go(MyAppRouteConstant.splashScreen);
                    },
                    child: const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    "Enter your details below to login \nto your Pik quick account.",
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey, fontFamily: 'Outfit'),
                  ),
                  const SizedBox(height: 40),

                  // Email Label
                  const Text(
                    "Email",
                    style: TextStyle(fontFamily: "Outfit", color: Colors.black),
                  ),
                  const SizedBox(height: 6),

                  // Email Field
                  TextFormFieldWithCustomStyles(
                    controller: emailController,
                    label: "Email",
                    hintText: "Enter your email",
                    fillColor: Colors.white,
                    labelColor: const Color(0xFF98A2B3),
                    hintColor: const Color(0xFF98A2B3),
                    textColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password Label
                  const Text(
                    "Password",
                    style: TextStyle(fontFamily: "Outfit", color: Colors.black),
                  ),
                  const SizedBox(height: 6),

                  // Password Field
                  TextFormFieldWithCustomStyles(
                    controller: passwordController,
                    label: "Password",
                    hintText: "Enter your password",
                    fillColor: Colors.white,
                    labelColor: const Color(0xFF98A2B3),
                    textColor: Colors.black,
                    obscureText: !isPasswordVisible,
                    suffixImagePath: isPasswordVisible
                        ? 'assets/icons/eyes.png'
                        : 'assets/icons/eyes.png',
                    onSuffixTap: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Forgot Password
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child:
                  // ),
                  const SizedBox(height: 30),

// remember me
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Remember me",
                        style: TextStyle(color: Colors.blue),
                      ),
                      Checkbox(
                        value: rememberMe,
                        // fillColor: WidgetStatePropertyAll(Colors.blue),
                        // checkColor: Colors.blue,
                        activeColor: Colors.blue,
                        // c
                        onChanged: (value) {
                          rememberMe = value ?? rememberMe;
                          setState(() {});
                        },
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          context.push(MyAppRouteConstant.forgetPassword);
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  // Login Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return Center(
                        child: FancyContainer(
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<AuthBloc>().add(LoginEvent(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ));
                            }
                          },
                          borderRadius: BorderRadius.circular(10),
                          height: 50,
                          width: double.infinity,
                          color: const Color(0xFF4378CD),
                          child: state is LoginLoadingState
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    'Login',
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
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Sign-up Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          context.go(
                            MyAppRouteConstant.accountSelection,
                          ); // Make sure you have this route
                        },
                        child: const Text(
                          "Create account",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Helpterms(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool rememberMe = false;
}
