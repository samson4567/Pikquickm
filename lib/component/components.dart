import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pikquick/core/constants/svgs.dart';

Widget buildEmptyNotificationList() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.string(empty_notification_image),
        Text(
          "No notifications found.",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          "You’ll see new updates about your activities here.",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
