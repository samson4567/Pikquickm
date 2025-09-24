import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/component/extraction.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/router/router_config.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 250),
        child: Column(
          children: [
            Image.asset(
              'assets/icons/logo.png',
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'Quick errands\njust tap away',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: FancyContainer(
                onTap: () {
                  context.go(MyAppRouteConstant.accountSelection);
                },
                borderRadius: BorderRadius.circular(10),
                height: 50,
                width: 342,
                color: const Color(0xFF4378CD),
                child: const Center(
                  child: Text(
                    'Create new account',
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
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Outfit',
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                GestureDetector(
                  onTap: () {
                    context.push(MyAppRouteConstant.login);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Outfit',
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'or continue with ',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Outfit',
                color: Color(0xFF98A2B3),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FancyContainer(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(),
              height: 50,
              width: 342,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/google.png',
                      height: 24,
                      width: 24,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Outfit',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Help | Terms Section
            const Helpterms(),
          ],
        ),
      ),
    );
  }
}
