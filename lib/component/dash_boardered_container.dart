import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/screen_test/test_site.dart';

class DashBorderedContainer extends StatefulWidget {
  final double? cornerRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final Widget? child;

  const DashBorderedContainer(
      {super.key,
      this.cornerRadius,
      this.borderColor,
      this.backgroundColor,
      this.child});

  @override
  State<DashBorderedContainer> createState() => _DashBorderedContainerState();
}

class _DashBorderedContainerState extends State<DashBorderedContainer> {
  @override
  Widget build(BuildContext context) {
    return FancyContainer2(
      nulledAlign: true,
      radius: widget.cornerRadius,
      backgroundColor: widget.backgroundColor,
      child: DottedBorder(
          borderType: BorderType.RRect,
          color: widget.borderColor ?? Colors.black,
          radius: Radius.circular(widget.cornerRadius ?? 10),
          child: widget.child ?? SizedBox()),
    );
  }
}
