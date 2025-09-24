import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/router/router_config.dart';

class RequestPayout extends StatefulWidget {
  const RequestPayout({super.key});

  @override
  State<RequestPayout> createState() => _RequestPayoutState();
}

class _RequestPayoutState extends State<RequestPayout> {
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
            " RequestPayout ",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Withdrable Balance",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Outfit',
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "N90,000",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Outfit',
                    color: Colors.blue),
              ),
            ],
          ),
          const Text(
            "How Much do you want to withdraw to your wallet?",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Outfit',
            ),
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
                    keyboardType: TextInputType.number,
                    initialValue: fareAmount.toStringAsFixed(2),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onChanged: (value) {
                      setState(() {
                        fareAmount = double.tryParse(value) ?? fareAmount;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setState(() => fareAmount =
                      (fareAmount - 100).clamp(0, double.infinity)),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => fareAmount += 100),
                ),
                Image.asset(
                  'assets/images/100.png',
                  width: 100,
                  height: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Enter an amount Between N100 to 50,0000",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Outfit',
                color: Colors.grey[400]),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Row(
              children: [
                Text(
                  "Saved Payout Account",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Outfit',
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: FancyContainer(
              color: const Color(0XFF4A85E4),
              onTap: () {
                context.go(MyAppRouteConstant.paymetmethod);
              },
              borderRadius: BorderRadius.circular(10),
              height: 50,
              width: 342,
              child: const Center(
                child: Text(
                  'Add Payout Method',
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
