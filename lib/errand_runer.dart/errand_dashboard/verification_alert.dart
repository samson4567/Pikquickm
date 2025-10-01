import 'package:flutter/material.dart';

import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_text.dart';

class VerificationAlert extends StatelessWidget {
  final Function()? onVerifyIdentity;
  final Function()? onClose;

  const VerificationAlert({
    super.key,
    this.onVerifyIdentity,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // The main container for the modal content
    return FancyContainer2(
      // Typically modals would be wrapped in a container with specific height/width
      // constraints, but here we let the content size the FancyContainer.
      width: MediaQuery.of(context).size.width,
      radius: 20, // Rounded corners for the modal
      backgroundColor: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Keep the modal size to its content
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Close Button
          Align(
            alignment: Alignment.topRight,
            child: FancyContainer2(
              action: onClose,
              isAsync: false,
              child: Icon(
                Icons.close,
                size: 24,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Icon Container (The orange warning icon box)
          FancyContainer2(
            width: 80,
            height: 80,
            radius: 16,
            backgroundColor:
                const Color(0xFFFFC107).withOpacity(0.8), // Yellow/Orange color
            child: const Center(
              child: Icon(
                Icons.warning_amber_rounded, // Using a similar warning icon
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Title
          FancyText(
            'Verify Identity',
            size: 24,
            weight: FontWeight.w800,
            textColor: Colors.black,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle/Message
          FancyText(
            'You must complete your verification before you can get hired for task.',
            size: 14,
            textColor: Colors.grey.shade600,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Action Button
          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    // The main blue button
    return FancyContainer2(
      action: onVerifyIdentity,
      isAsync: true, // Assuming verification process might be async
      width: double.infinity,
      height: 56,
      radius: 12,
      backgroundColor: const Color(0xFF4285F4), // A standard blue color
      child: FancyText(
        'Verify Identity',
        size: 16,
        weight: FontWeight.bold,
        textColor: Colors.white,
        textAlign: TextAlign.center,
      ),
    );
  }
}
