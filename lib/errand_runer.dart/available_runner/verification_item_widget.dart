import 'package:flutter/material.dart';
import 'package:pikquick/errand_runer.dart/available_runner/runner_profile_hired.dart';

class VerificationItemWidget extends StatelessWidget {
  final String title;
  final String status;

  const VerificationItemWidget(this.title, this.status);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: _sectionContentStyle),
          (status == "verified")
              ? const Image(
                  image: AssetImage('assets/images/ci.png'),
                  width: 20,
                  height: 20,
                )
              : (status == "pending")
                  ? Icon(
                      Icons.pending_actions_rounded,
                      color: Colors.yellow,
                      shadows: List.filled(
                          4,
                          BoxShadow(
                              offset: Offset(1, 1),
                              spreadRadius: 1,
                              color: Colors.grey.withAlpha(80),
                              blurRadius: 10)),
                    )
                  : Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
        ],
      ),
    );
  }
}

const _sectionContentStyle = TextStyle(fontSize: 14, fontFamily: 'Outfit');
