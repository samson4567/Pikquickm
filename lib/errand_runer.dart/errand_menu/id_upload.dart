import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/errand_runer.dart/errand_menu/document_varification.dart';
import 'package:pikquick/errand_runer.dart/errand_menu/lincence_verificatio.dart';
import 'package:pikquick/features/authentication/domain/entities/kyc_request_entity.dart';
import 'package:pikquick/router/router_config.dart';

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
                idVerificationKycRequestEntity ??= KycRequestEntity();
                idVerificationKycRequestEntity!.documentName = "ID Card";
                // userModelG;
                context.push(MyAppRouteConstant.documentVerificationCamera);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => const LicenceVerification()
                //         ));
              },
            ),
            const SizedBox(height: 16),
            _buildVerificationItem(
              context,
              imagePath: 'assets/icons/camera.png',
              title: "Driving License",
              // "Self Verification",
              onTap: () {
                // Navigate to Selfie Verification screen
                idVerificationKycRequestEntity ??= KycRequestEntity();
                idVerificationKycRequestEntity!.documentName =
                    "Driving License";
                context.push(MyAppRouteConstant.documentVerificationCamera);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => const SelfieVerificationPage()));
              },
            ),
            const SizedBox(height: 16),
            _buildVerificationItem(
              context,
              imagePath: 'assets/icons/location.png',
              title: "International Passport",
              onTap: () {
                // Navigate to Address Verification screen
                idVerificationKycRequestEntity ??= KycRequestEntity();
                idVerificationKycRequestEntity!.documentName =
                    "International Passport";
                context.push(MyAppRouteConstant.documentVerificationCamera);
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
