import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Helpterms extends StatelessWidget {
  const Helpterms({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Help',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Outfit',
            color: Colors.black,
          ),
        ),
        SizedBox(width: 16),
        Text(
          '|',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Outfit',
            color: Color(0xFF98A2B3),
          ),
        ),
        SizedBox(width: 16), // Spacing
        Text(
          'Terms',
          style: TextStyle(
              fontSize: 14, fontFamily: 'Outfit', color: Colors.black),
        ),
      ],
    );
  }
}
