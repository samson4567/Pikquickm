import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/core/db/app_preference_service.dart';
import 'package:pikquick/core/security/secure_key.dart';
import 'package:pikquick/features/authentication/data/models/refrresh_toke_model.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(String phoneNumber) async {
  // 1. Clean the number (remove spaces, hyphens, etc.) for better compatibility
  final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

  // 2. Create the Uri with the 'tel' scheme
  final Uri phoneLaunchUri = Uri(
    scheme: 'tel',
    path: cleanedNumber,
  );

  // 3. Check if the device can launch the URL
  if (await canLaunchUrl(phoneLaunchUri)) {
    // 4. Launch the phone dialer
    await launchUrl(phoneLaunchUri);
  } else {
    throw 'Could not launch $phoneLaunchUri';
  }
}

Future<void> refreshAccessToken(BuildContext context) async {
  final appPref = AppPreferenceService();
  final refreshToken = appPref.getValue<String>(SecureKey.refreshTokenKey);

  if (refreshToken != null && refreshToken.isNotEmpty) {
    context.read<AuthBloc>().add(
          RefreshTokenEvent(
            model: RefreshTokenModel(refreshToken: refreshToken),
          ),
        );
  }
}
