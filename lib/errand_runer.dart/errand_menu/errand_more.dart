import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/errand_runer.dart/errand_menu/document_varification.dart';
import 'package:pikquick/errand_runer.dart/profile/create_profile.dart';
import 'package:pikquick/errand_runer.dart/profile/profile_empty.dart';
import 'package:pikquick/errand_runer.dart/serviced_categories.dart';
import 'package:pikquick/hire_an_errand.dart/menu/account_info/account_info.dart';
import 'package:pikquick/hire_an_errand.dart/menu/account_settings/Account_settings.dart';
import 'package:pikquick/hire_an_errand.dart/menu/account_settings/safety.dart';
import 'package:pikquick/hire_an_errand.dart/menu/help_support/help_support.dart';
import 'package:pikquick/hire_an_errand.dart/onboarding/login.dart';
import 'package:pikquick/router/router_config.dart';

class ErrandAccountPage extends StatelessWidget {
  const ErrandAccountPage({super.key});

  void _showSwitchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: 342,
          height: 208,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                // Close button
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon & Title
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/Content.png',
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 35,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Perform switch account logic here
                            },
                            child: const Text(
                              'Yes, Switch',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settings = [
      {
        'title': 'Account info',
        'icon': 'users.png',
        'onTap': () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AccountInfo()));
        },
      },
      {
        'title': 'Verification',
        'icon': 'settings.png',
        'onTap': () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const DocumentVarification()));
        },
      },
      {
        'title': 'Serviced Categories',
        'icon': 'settings.png',
        'onTap': () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => SavedCategoriesScreen()));
        },
      },
      {
        'title': 'Account Settings',
        'icon': 'settings.png',
        'onTap': () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AccountSettings()));
        },
      },
      {
        'title': 'Help/Support',
        'icon': 'help.png',
        'onTap': () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const HelpSupportPage()));
        },
      },
      {
        'title': 'Safety',
        'icon': 'safety.png',
        'onTap': () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => SafetyScreen()));
        },
      },
      {
        'title': 'Edit Profile',
        'icon': 'safety.png',
        'onTap': () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => EditProfileSetup()));
        },
      },
      {
        'title': 'Create Profile',
        'icon': 'safety.png',
        'onTap': () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => CreateProfile()));
        },
      },
      {
        'title': 'Terms and Conditions',
        'icon': 'terms.png',
        'onTap': () {},
      },
      {
        'title': 'About Us',
        'icon': 'ix.png',
        'onTap': () {},
      },
      {
        'title': 'Log out',
        'icon': 'logout.png',
        'onTap': () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoginPage()));
        },
      },
    ];

    return Scaffold(
      body: ListView.builder(
        itemCount: settings.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context
                          .pushReplacement(MyAppRouteConstant.dashBoardScreen);
                    },
                    child: const Icon(Icons.arrow_back_ios_new, size: 24),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Your account',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(thickness: 1),
                ],
              ),
            );
          } else {
            final setting = settings[index - 1];
            return Column(
              children: [
                ListTile(
                  leading: Image.asset(
                    'assets/icons/${setting['icon']}',
                    width: 30,
                    height: 30,
                  ),
                  title: Text(setting['title']),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: setting['onTap'],
                ),
                const SizedBox(height: 10),
              ],
            );
          }
        },
      ),
    );
  }
}
