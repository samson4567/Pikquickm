import 'package:flutter/material.dart';
import 'package:pikquick/errand_runer.dart/errand_menu/id_upload.dart';

class DocumentVarification extends StatefulWidget {
  const DocumentVarification({super.key});

  @override
  State<DocumentVarification> createState() => _DocumentVarificationState();
}

class _DocumentVarificationState extends State<DocumentVarification> {
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
                'Boost Your Credibility & \nEarn More',
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
              title: "ID Verification",
              description:
                  "Upload a Government ID\nAccept IDs: NIN, Driver’s Licence",
              onTap: () {
                // Navigate to ID Verification screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const IDVerification()));
              },
            ),
            const SizedBox(height: 16),
            _buildVerificationItem(
              context,
              imagePath: 'assets/icons/camera.png',
              title: "Self Verification",
              description:
                  "Take a selfie for identity confirmation\nEnsure good lighting, match your ID",
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
              description:
                  "Upload utility bill or bank statement\nMust be recent (last 3 months)",
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
    required String description,
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
                Text(description,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}

class SelfieVerificationPage extends StatelessWidget {
  const SelfieVerificationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Self Verification')),
      body: const Center(child: Text('Selfie Upload Form Here')),
    );
  }
}

class AddressVerificationPage extends StatelessWidget {
  const AddressVerificationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Address Verification')),
      body: const Center(child: Text('Address Upload Form Here')),
    );
  }
}
