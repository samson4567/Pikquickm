import 'package:flutter/material.dart';
import 'package:pikquick/errand_runer.dart/errand_menu/document_varification.dart';
import 'package:pikquick/errand_runer.dart/errand_menu/lincence_verificatio.dart';

class IDVerification extends StatefulWidget {
  const IDVerification({super.key});

  @override
  State<IDVerification> createState() => _IDVerificationState();
}

class _IDVerificationState extends State<IDVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Document Verification")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/images/upload.png'),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Upload Proof of Your \nIdentity ',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Verifying your identity helps you build trust\nand unlock high paying tasks.',
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            _buildVerificationItem(
              context,
              imagePath: 'assets/icons/id.png',
              title: "ID Card",
              onTap: () {
                // Navigate to ID Verification screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LicenceVerification()));
              },
            ),
            const SizedBox(height: 16),
            _buildVerificationItem(
              context,
              imagePath: 'assets/icons/camera.png',
              title: "Self Verification",
              onTap: () {
                // Navigate to Selfie Verification screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SelfieVerificationPage()));
              },
            ),
            const SizedBox(height: 16),
            _buildVerificationItem(
              context,
              imagePath: 'assets/icons/location.png',
              title: "Address Verification",
              onTap: () {
                // Navigate to Address Verification screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddressVerificationPage()));
              },
            ),
            SizedBox(
              height: 10,
            ),
            Center(child: Text('Why this Needed ?'))
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationItem(
    BuildContext context, {
    required String imagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, width: 40, height: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
