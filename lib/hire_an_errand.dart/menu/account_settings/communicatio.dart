import 'package:flutter/material.dart';
import 'package:pikquick/component/fancy_container.dart';

class Communication extends StatefulWidget {
  const Communication({super.key});

  @override
  State<Communication> createState() => _CommunicationState();
}

class _CommunicationState extends State<Communication> {
  String _selectedPreference = 'Call & chat';

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
              'Communication',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Contact Preferences',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Outfit',
              ),
            ),
            const Text(
              'Choose how you want Errand Runner to reach you',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 20),
            _buildSettingTile(
              iconPath: 'assets/icons/hugeicons_call.png',
              title: 'Call & chat',
            ),
            _buildDivider(),
            _buildSettingTile(
              iconPath: 'assets/icons/hugeicons_call.png',
              title: 'Call',
            ),
            _buildDivider(),
            _buildSettingTile(
              iconPath: 'assets/icons/Vector-9.png',
              title: 'Chat',
            ),
            const Spacer(),
            FancyContainer(
              onTap: () {
                // Handle login functionality here
              },
              borderRadius: BorderRadius.circular(10),
              height: 50,
              width: double.infinity,
              color: const Color(0xFF4378CD),
              child: const Center(
                child: Text(
                  'Update',
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
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required String iconPath,
    required String title,
  }) {
    final bool isSelected = _selectedPreference == title;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: Image.asset(iconPath, width: 28, height: 28),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? Colors.black : Colors.grey,
      ),
      onTap: () {
        setState(() {
          _selectedPreference = title;
        });
      },
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.white12, height: 0);
  }
}
