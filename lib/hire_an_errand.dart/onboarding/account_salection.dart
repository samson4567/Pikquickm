import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/router/router_config.dart';

class AccountSelection extends StatelessWidget {
  const AccountSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                context.pop(MyAppRouteConstant.login);
              },
              child: const Icon(Icons.arrow_back_ios, size: 28),
            ),
            const SizedBox(height: 20),
            const Text(
              'How would you like to',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Outfit',
              ),
            ),
            const Text(
              'use PikQuick?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Hire an errand runner
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.go(MyAppRouteConstant.accountCreation);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/hire1.png', // Replace with actual asset path
                            height: 80,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Hire an errand runner',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Spacing between options

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.go(MyAppRouteConstant.runnerAccountCreation);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/hire2.png', // Replace with actual asset path
                            height: 80,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Become an errand runner',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
