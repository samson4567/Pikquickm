import 'package:flutter/material.dart';
import 'package:pikquick/app_variable.dart' as app_var;
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/hire_an_errand.dart/menu/account_info/Edit_mail.dart';
import 'package:pikquick/hire_an_errand.dart/menu/account_info/edit_phone.dart';
import 'package:pikquick/hire_an_errand.dart/menu/account_info/name_update.dart';

class AccountInfo extends StatelessWidget {
  const AccountInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Arrow
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_ios_new, size: 24),
            ),

            const SizedBox(height: 50),

            // Page Title
            const Text(
              'Account Info',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // Profile Picture with Edit Icon
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: (userModelG?.imageUrl != null)
                      ? NetworkImage(userModelG!.imageUrl!)
                      : AssetImage('assets/images/circle.png'),
                  // child:   ,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Image.asset(
                      'assets/icons/ediit.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Basic info',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            // Name
            _infoRow(
              title: 'Name',
              value: app_var.userModelG?.fullName ?? 'Not set',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditNamePage()),
                );
              },
            ),

            const SizedBox(height: 20),

            _infoRow(
              title: 'Phone Number',
              value: app_var.userModelG?.phone ?? 'Not set',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditPhone()),
                );
              },
            ),

            const SizedBox(height: 20),

            _infoRow(
              title: 'Email',
              value: app_var.userModelG?.email ?? 'Not set',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Editmail()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Title and Value
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),

          // Right arrow icon
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
