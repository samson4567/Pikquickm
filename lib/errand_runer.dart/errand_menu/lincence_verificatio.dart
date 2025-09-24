import 'package:flutter/material.dart';

class LicenceVerification extends StatefulWidget {
  const LicenceVerification({super.key});

  @override
  State<LicenceVerification> createState() => _LicenceVerificationState();
}

class _LicenceVerificationState extends State<LicenceVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070D17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070D17),
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('Licence Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildScanCard(
              icon: Icons.document_scanner_outlined,
              title: "Scan Driver's Licence",
              subtitle: "Scan the front of your licence for verification",
              onTap: () {
                // Navigate to Document Scanner Page
              },
            ),
            const SizedBox(height: 20),
            _buildScanCard(
              icon: Icons.face_retouching_natural,
              title: "Face Scan",
              subtitle: "Scan your face to match the document",
              onTap: () {
                // Navigate to Face Scan Page
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Submit both scans
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1EC89F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit for Verification',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101623),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Scan Now"),
          ),
        ],
      ),
    );
  }
}
