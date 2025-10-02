import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_text.dart';
import 'package:pikquick/core/constants/svgs.dart';
import 'package:pikquick/features/authentication/domain/entities/kyc_request_entity.dart';
import 'package:pikquick/router/router_config.dart';
// import 'fancy_text.dart'; // Assuming fancy_text.dart is in the same directory
// import 'fancy_container.dart'; // Assuming fancy_container.dart is in the same directory

class IdVerificationDocumentTypeScreen extends StatelessWidget {
  const IdVerificationDocumentTypeScreen({super.key});

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
              const SizedBox(height: 48),

              // Profile Picture Placeholder (Reused from previous screen)
              Center(
                child: Image.asset('assets/images/upload.png'),
              ),
              const SizedBox(height: 48),

              // Title
              FancyText(
                'Upload proof of your identity',
                size: 32,
                weight: FontWeight.w900,
                textColor: Colors.black,
              ),
              const SizedBox(height: 8),

              // Subtitle
              FancyText(
                'Please submit a document below',
                size: 16,
                textColor: Colors.grey.shade600,
              ),
              const SizedBox(height: 40),

              // Document Selection List Items
              _buildDocumentItem(
                context,
                icon: Icons.credit_card_outlined, // ID Card icon
                title: 'ID Card',
                action: () {
                  idVerificationKycRequestEntity ??= KycRequestEntity();
                  idVerificationKycRequestEntity!.documentName = "ID Card";
                  // userModelG;
                  context.push(MyAppRouteConstant.documentVerificationCamera);
                },
              ),
              _buildDocumentItem(
                context,
                icon: Icons
                    .location_on_outlined, // Location pin/map icon is used in the image
                title: 'Driving License',
                action: () {
                  idVerificationKycRequestEntity ??= KycRequestEntity();
                  idVerificationKycRequestEntity!.documentName =
                      "Driving License";
                  context.push(MyAppRouteConstant.documentVerificationCamera);
                },
                // action: () => print('Selected Driving License'),
              ),
              _buildDocumentItem(
                context,
                icon: Icons
                    .camera_alt_outlined, // Camera icon is used in the image
                title: 'International Passport',
                action: () {
                  idVerificationKycRequestEntity ??= KycRequestEntity();
                  idVerificationKycRequestEntity!.documentName =
                      "International Passport";
                  context.push(MyAppRouteConstant.documentVerificationCamera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Function() action,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      // FancyContainer acts as a tappable area for the list item
      child: FancyContainer2(
        action: action,
        isAsync: false, // Simple navigation/local function
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: FancyText(
                title,
                size: 18,
                weight: FontWeight.w500,
                textColor: Colors.black,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
