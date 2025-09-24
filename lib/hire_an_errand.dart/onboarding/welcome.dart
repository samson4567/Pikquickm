import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart' hide FancyContainer;
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/router/router_config.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 50, right: 50),
        child: Column(
          children: [
            Image.asset(
              'assets/images/welcome.png',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome Back!,",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'Outfit'),
            ),
            const SizedBox(height: 8),
            Text(
              userModelG?.fullName ?? "",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const SizedBox(height: 40),
            FancyContainer(
              onTap: () {
                context.pushNamed(MyAppRouteConstant.dashboard);
              },
              borderRadius: BorderRadius.circular(10),
              height: 50,
              width: 342,
              color: const Color(0xFF4378CD),
              child: const Center(
                child: Text(
                  'Go to dashboard',
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
            const SizedBox(height: 40), // Add spacing below button
          ],
        ),
      ),
    );
  }
}
