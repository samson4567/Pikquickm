import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/hire_an_errand.dart/dashboard/message_chat.dart';
import 'package:pikquick/router/router_config.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails({super.key});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  int activeStep = 1;
  final List<String> stepTitles = [
    'Task Assigned',
    'Pickup Complete',
    'En Route',
    'Task Completed',
  ];

  void _showPhoneNumberDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "+1 234 567 8901",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          final Uri phoneUri =
                              Uri(scheme: 'tel', path: '+12345678901');
                          if (await canLaunchUrl(phoneUri)) {
                            await launchUrl(phoneUri);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Could not launch phone app')),
                            );
                          }
                        },
                        child: const Text(
                          "Call",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToMessagePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MessagePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Task Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: (userModelG?.imageUrl != null)
                      ? NetworkImage(userModelG!.imageUrl!)
                      : AssetImage('assets/images/circle.png'),
                ),
                SizedBox(width: 10),
                Text(
                  "Micheal T",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Outfit',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Text(
                  "ETA: Jan 15, 2025 - 30:16 PM | ",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200),
                ),
                Text(
                  "by car",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200),
                ),
                SizedBox(width: 10),
                Icon(Icons.car_crash_outlined, color: Colors.black, size: 16),
              ],
            ),
            const SizedBox(height: 20),
            messageMethod(),
            const SizedBox(height: 10),
            const Divider(),
            const Text(
              "In Progress",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.green,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Grocery Shopping at \nYaba Market",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "₦3500",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Outfit',
              ),
            ),
            const Row(
              children: [
                Text(
                  "Grocery Shopping still in progress | Jan 25, 2025",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 9,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Outfit',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Task Details",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Pick Up Address",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                fontFamily: 'Outfit',
              ),
            ),
            const Text(
              "Shoprite, Lekki Lagos",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Drop-off Location",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                fontFamily: 'Outfit',
              ),
            ),
            const Text(
              "12 Banana Island, Ikorodu",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Additional Note",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                fontFamily: 'Outfit',
              ),
            ),
            const Text(
              "Handle fragile items with care",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Task ID",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                fontFamily: 'Outfit',
              ),
            ),
            const Text(
              "#PQR-984308",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Status Updates",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < stepTitles.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 15,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i <= activeStep
                                    ? Colors.red
                                    : Colors.grey[300],
                              ),
                              child: i <= activeStep
                                  ? const Icon(Icons.check,
                                      size: 14, color: Colors.white)
                                  : null,
                            ),
                            if (i < stepTitles.length - 1)
                              Container(
                                width: 1,
                                height: 20,
                                color: i < activeStep
                                    ? Colors.blue
                                    : Colors.grey[300],
                              ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            stepTitles[i],
                            style: TextStyle(
                              fontSize: 9,
                              fontFamily: 'Outfit',
                              fontWeight: i == activeStep
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: i <= activeStep
                                  ? Colors.black
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            FancyContainer(
              onTap: () {
                context.go(MyAppRouteConstant.runner);
              },
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue),
              height: 50,
              width: 342,
              child: const Center(
                child: Text(
                  'View current location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Outfit',
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row messageMethod() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: _showPhoneNumberDialog,
          child: Row(
            children: [
              Image.asset(
                'assets/images/call.png',
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              const Text(
                "Call",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        const Text(
          "|",
          style:
              TextStyle(fontSize: 17, fontFamily: 'Outfit', color: Colors.grey),
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/message.png',
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _navigateToMessagePage,
              child: const Text(
                "Message",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
