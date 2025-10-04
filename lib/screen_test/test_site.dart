import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_text.dart';
import 'package:pikquick/core/constants/svgs.dart';
import 'package:pikquick/component/dash_boardered_container.dart';
import 'package:pikquick/screen_test/selfie_verification_page.dart';

class TestSite extends StatefulWidget {
  const TestSite({super.key});

  @override
  State<TestSite> createState() => _TestSiteState();
}

class _TestSiteState extends State<TestSite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:
              // newMethod(),
              SizedBox()),
    );
  }

  DashBorderedContainer newMethod() {
    return DashBorderedContainer(
      borderColor: Colors.red,
      // cornerRadius: ,
      backgroundColor: Colors.amber.withAlpha(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FancyContainer2(
          // backgroundColor: Colors.amber,
          nulledAlign: true,
          child: Text(
            'Rectangular Border',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
