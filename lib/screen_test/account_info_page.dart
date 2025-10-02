import 'package:flutter/material.dart';
// import 'fancy_text.dart'; // Assuming fancy_text.dart is in the same directory
// import 'fancy_container.dart'; // Assuming fancy_container.dart is in the same directory
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_text.dart';
import 'package:pikquick/core/constants/svgs.dart';
import 'package:pikquick/features/authentication/domain/entities/kyc_request_entity.dart';
import 'package:pikquick/router/router_config.dart'; // For the icons

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  List<KycRequestEntity> listOfDoneKycRequestEntity = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              buildBackArrow(context),
              // IconButton(
              //   padding: EdgeInsets.zero,
              //   constraints: const BoxConstraints(),
              //   icon: const Icon(Icons.arrow_back_ios),
              //   onPressed: () {
              //     // TODO: Implement navigation back
              //   },
              // ),
              const SizedBox(height: 48),

              // Profile Picture Placeholder
              Center(
                child: Image.asset('assets/images/upload.png'),
              ),
              const SizedBox(height: 48),

              // Title
              FancyText(
                'Boost Your Credibility & Earn More',
                size: 32,
                weight: FontWeight.w900,
                textColor: Colors.black,
              ),
              const SizedBox(height: 16),

              // Subtitle
              FancyText(
                'Verifying your identity helps build trust and unlocks high-paying tasks.',
                size: 16,
                textColor: Colors.grey.shade600,
              ),
              const SizedBox(height: 40),

              // Verification List Items
              _buildVerificationItem(
                context,
                icon: Icons.credit_card_outlined, // Using a similar icon
                title: 'ID Verification',
                subtitle: 'Upload a Government-issued ID',
                details: 'Accepted IDs: NIN, Driver\'s License, Passport',
                action: () {
                  idVerificationKycRequestEntity ??= KycRequestEntity();
                  idVerificationKycRequestEntity!.documentTypeId =
                      "49d70b98-9d37-11f0-b251-00163cbf7aa3";
                  context.push(
                      MyAppRouteConstant.idVerificationDocumentTypeScreen);
                },
                isDone: (idVerificationKycRequestEntity == null),
              ),
              _buildVerificationItem(
                context,
                icon: Icons.camera_alt_outlined,
                title: 'Selfie Verification',
                subtitle: 'Take a live selfie for identity confirmation',
                details: 'Ensure good lighting & match your ID photo',
                action: () {
                  selfieVerificationKycRequestEntity ??= KycRequestEntity();
                  selfieVerificationKycRequestEntity!.documentTypeId =
                      "43c2d2a3-9d37-11f0-b251-00163cbf7aa3";
                  selfieVerificationKycRequestEntity!.documentName =
                      "Live Selfie";

                  context.push(MyAppRouteConstant.selfieVerificationPage);
                },
                // action: () MyAppRouteConstant.selfieVerificationPage,
                isDone: (selfieVerificationKycRequestEntity == null),
              ),
              _buildVerificationItem(
                context,
                icon: Icons.location_on_outlined,
                title: 'Address Verification',
                subtitle: 'Upload a utility bill or bank statement',
                details: 'Must be recent (last 3 months)',
                action: () {
                  addressVerificationKycRequestEntity ??= KycRequestEntity();
                  addressVerificationKycRequestEntity!.documentTypeId =
                      "2ac69be0-9d37-11f0-b251-00163cbf7aa3";
                  addressVerificationKycRequestEntity!.documentName =
                      "Proof of Address";

                  context.push(MyAppRouteConstant.addressDocumentUploadScreen);
                },
                // action: () => print('Go to Address Verification'),
                isDone: (addressVerificationKycRequestEntity == null),
              ),
              const SizedBox(height: 40),

              // Bottom Link
              Center(
                child: FancyText(
                  'Why is this needed?',
                  textColor: Colors.black,
                  weight: FontWeight.w600,
                  action: () => print('Show "Why is this needed?" info'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String details,
    required Function() action,
    required bool isDone,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: FancyContainer2(
        action: action,
        isAsync:
            false, // Assuming the action is a simple navigation/local function
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  FancyText(
                    title,
                    size: 18,
                    weight: FontWeight.bold,
                    textColor: Colors.black,
                  ),
                  const SizedBox(height: 4),
                  // Subtitle (Bold text in the UI)
                  FancyText(
                    subtitle,
                    size: 14,
                    weight: FontWeight.bold,
                    textColor: Colors.black,
                  ),
                  // Details (Regular text in the UI)
                  FancyText(
                    details,
                    size: 14,
                    textColor: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
            isDone
                ? const Icon(Icons.arrow_forward_ios,
                    size: 18, color: Colors.black)
                : const Icon(Icons.check, size: 18, color: Colors.green),
          ],
        ),
      ),
    );
  }
}

// NOTE: To run this, you would wrap it in a MaterialApp like so:
/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AccountInfoScreen(),
    );
  }
}
*/