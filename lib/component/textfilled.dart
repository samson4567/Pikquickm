import 'package:flutter/material.dart';

class TextFormFieldWithCustomStyles extends StatelessWidget {
  final TextEditingController controller;
  final String? label; // ✅ Nullable label
  final String hintText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final Color? fillColor;
  final Color textColor;
  final Color borderColor;
  final Color labelColor;
  final Color? hintColor;
  final TextStyle? hintStyle;
  final String? prefixImagePath;
  final String? suffixImagePath;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final BoxDecoration? boxDecoration;
  final InputDecoration? inputDecoration;
  final double? width;
  final double? height;
  final int? maxLines;
  final TextStyle? style;

  const TextFormFieldWithCustomStyles({
    super.key,
    required this.controller,
    this.label, // ✅ made nullable
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.fillColor = const Color(0xFF2C2F32),
    this.textColor = Colors.white,
    this.borderColor = Colors.grey,
    this.labelColor = Colors.white,
    this.hintColor = const Color.fromRGBO(255, 255, 255, 0.502),
    this.hintStyle,
    this.prefixImagePath,
    this.suffixImagePath,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.boxDecoration,
    this.inputDecoration,
    this.width,
    this.height,
    this.maxLines,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: boxDecoration,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines ?? 1,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: inputDecoration ??
            InputDecoration(
              // ✅ Only show label if it's not null or empty
              labelText: (label != null && label!.isNotEmpty) ? label : null,
              hintText: hintText,
              labelStyle: TextStyle(color: labelColor),
              hintStyle: hintStyle ?? TextStyle(color: hintColor),
              filled: true,
              fillColor: fillColor,
              prefixIcon: prefixImagePath != null
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:
                          Image.asset(prefixImagePath!, width: 20, height: 20),
                    )
                  : prefixIcon != null
                      ? Icon(prefixIcon, color: textColor)
                      : null,
              suffixIcon: suffixImagePath != null
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(suffixImagePath!,
                            width: 20, height: 20),
                      ),
                    )
                  : suffixIcon != null
                      ? GestureDetector(
                          onTap: onSuffixTap,
                          child: Icon(suffixIcon, color: textColor),
                        )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: borderColor, width: 2.0),
              ),
            ),
        validator: validator,
        style: style ?? TextStyle(color: textColor),
      ),
    );
  }
}
