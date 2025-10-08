import 'package:flutter/material.dart';
import 'package:pikquick/hire_an_errand.dart/dashboard/message_chat.dart';
import 'package:pikquick/hire_an_errand.dart/menu/help_support/share_feed.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

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
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios_new, size: 24),
            ),

            const SizedBox(height: 30),

            // Title
            const Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Outfit',
              ),
            ),

            const SizedBox(height: 30),

            // Subtitle
            const Text(
              'Need help? We are here for you',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Outfit',
              ),
            ),

            const SizedBox(height: 30),

            // Chat Support
            _buildSupportTile(
              iconPath: 'assets/icons/mess.png',
              label: 'Chat Support',
              showArrow: true,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MessagePage()));
              },
            ),

            // Email Description
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 5),
              child: Text(
                'Reach out to us via email details',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Outfit',
                ),
              ),
            ),

            // Email (No trailing arrow)
            _buildSupportTile(
              iconPath: 'assets/icons/mail.png',
              label: 'email@email.com',
              showArrow: false,
              onTap: () {},
            ),

            // Phone Description
            const Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                'Reach out to us via phone details',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Outfit',
                ),
              ),
            ),

            _buildSupportTile(
              iconPath: 'assets/icons/2.png',
              label: '+234800000000',
              showArrow: false,
              onTap: () {},
            ),

            const Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                '  call our customer support for immediate',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Outfit',
                ),
              ),
            ),

            // Share Feedback
            _buildSupportTile(
              iconPath: 'assets/icons/feed.png',
              label: 'Share Feedback',
              showArrow: true,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ShareFeed()));
              },
            ),

            // Visit FAQs
            _buildSupportTile(
              iconPath: 'assets/icons/visit.png',
              label: 'Visit FAQs',
              showArrow: true,
              onTap: () {
                // Navigate to FAQ page
                print('Visit FAQs tapped');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportTile({
    required String iconPath,
    required String label,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Image.asset(iconPath, width: 24, height: 24),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Outfit',
            ),
          ),
          trailing:
              showArrow ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
          onTap: onTap,
        ),
      ],
    );
  }
}


//74297681-96fd-431f-8ef9-424339edb573