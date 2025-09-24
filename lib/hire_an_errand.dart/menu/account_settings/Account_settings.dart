import 'package:flutter/material.dart';
import 'package:pikquick/hire_an_errand.dart/menu/account_settings/communicatio.dart';
import 'package:pikquick/hire_an_errand.dart/menu/account_settings/security.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios_new, size: 24),
            ),
            const SizedBox(height: 30),
            const Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 20),
            _buildSettingTile(
              iconPath: 'assets/images/com.png',
              title: 'Communication',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Communication()));
              },
            ),
            _buildDivider(),
            _buildSettingTile(
              iconPath: 'assets/images/secu.png',
              title: 'Security',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Security()));
              },
            ),
            _buildDivider(),
            _buildSettingTile(
              iconPath: 'assets/images/lock.png',
              title: 'Privacy',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Security()));
              },
            ),
            const Spacer(),
            const Center(
              child: Text(
                'Delete Account',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Outfit',
                    color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      leading: Image.asset(
        iconPath,
        width: 28,
        height: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.white12, height: 0);
  }
}
