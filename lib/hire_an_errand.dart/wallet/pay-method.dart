import 'package:flutter/material.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/hire_an_errand.dart/wallet/add-card.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  double fareAmount = 1500.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 20),
          const Text(
            "Payment Method",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Image.asset('assets/icons/card.png'),
              const SizedBox(width: 13),
              const Text(
                "Bank Transfer",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCardScreen(),
                ),
              );
            },
            child: Row(
              children: [
                Image.asset('assets/icons/bank.png', width: 24, height: 24),
                const SizedBox(width: 13),
                const Text(
                  "Credit or debit card",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Outfit',
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Center(
            child: FancyContainer(
              color: const Color(0XFF4A85E4),
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              height: 50,
              width: 342,
              child: const Center(
                child: Text(
                  'Payment method',
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
    ));
  }
}
