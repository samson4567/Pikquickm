import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/router/router_config.dart';

class Setbudget extends StatefulWidget {
  const Setbudget({super.key, required this.data});
  final Map data;

  @override
  State<Setbudget> createState() => _SetbudgetState();
}

class _SetbudgetState extends State<Setbudget> {
  final TextEditingController setbugetController = TextEditingController();
  double fareAmount = 1500.0;
  @override
  initState() {
    super.initState();
    taskModelbeingCreated?.paymentMethod = "wallet";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  onPressed: () {
                    // print('**********${setbugetController.text.trim()}');
                    context.go(MyAppRouteConstant.taskreview, extra: {
                      'specialInstructions': widget.data['specialInstructions'],
                      'additionalNote': widget.data['additionalNote'],
                      'taskType': widget.data['taskType'],
                      'pickupLocation': widget.data['pickupLocation'],
                      'drop-off': widget.data['drop-off'],
                      'longtitude': widget.data['longtitude'],
                      'latitude': widget.data['latitude'],
                      'Setbudget': setbugetController.text.trim()
                    });
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Set your budget ",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  fontFamily: 'Oufit'),
            ),
            const SizedBox(height: 20),
            const Text(
              "Budget amount",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  fontFamily: 'Oufit'),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Text('₦', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: TextFormField(
                      controller: setbugetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onChanged: (value) {
                        setState(() {
                          fareAmount = double.tryParse(value) ?? fareAmount;
                          taskModelbeingCreated?.budget = fareAmount.toInt();
                        });
                        // taskModelbeingCreated?.budget = fareAmount.toInt();
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => setState(() {
                      fareAmount = (fareAmount - 100).clamp(0, double.infinity);
                      taskModelbeingCreated?.budget = fareAmount.toInt();
                    }),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() {
                      fareAmount += 100;
                      taskModelbeingCreated?.budget = fareAmount.toInt();
                    }),
                  ),
                  Image.asset(
                    'assets/images/100.png',
                    width: 24,
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text('Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                )),
            const SizedBox(height: 15),
            _buildPaymentOption('App Wallet', true, 'assets/icons/ic1.png'),
            const SizedBox(height: 30),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildPaymentOption(String text, bool selected, String assetPath) {
  return Row(
    children: [
      Image.asset(
        assetPath,
        width: 24,
        height: 24,
      ),
      const SizedBox(width: 10),
      Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Outfit'),
      ),
      const Spacer(),
    ],
  );
}
