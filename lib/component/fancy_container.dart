import 'package:flutter/material.dart';

class FancyContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final BoxShadow? boxShadow;
  final Gradient? gradient;
  final AlignmentGeometry? alignment;
  final GestureTapCallback? onTap;

  const FancyContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.width,
    this.height,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.gradient,
    this.alignment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: padding,
        margin: margin,
        width: width,
        height: height,
        alignment: alignment,
        decoration: BoxDecoration(
          color: gradient == null ? color : null,
          borderRadius: borderRadius,
          border: border,
          boxShadow: boxShadow != null ? [boxShadow!] : null,
          gradient: gradient,
        ),
        child: child,
      ),
    );
  }
}
