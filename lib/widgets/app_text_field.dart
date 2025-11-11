import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final IconData? iconData;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Color focusedBorderColor;
  final Widget? suffixIcon;
  final bool obscureText;

  const AppTextField({
    super.key,
    required this.hint,
    this.iconData,
    required this.keyboardType,
    required this.controller,
    this.focusedBorderColor = Colors.blue,
    this.suffixIcon,
    this.obscureText = false,

  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.cairo(
        fontSize: 13.sp
      ),
     decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        hintText: hint,
        hintStyle: GoogleFonts.cairo(
        ),
        suffixIcon: suffixIcon,
        helperMaxLines: 1,
        prefixIcon: iconData != null ? Icon(iconData) : null,
        enabledBorder: buildOutlineInputBorder(),
        focusedBorder: buildOutlineInputBorder(color: focusedBorderColor),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder({Color color =Colors.grey}) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: color),
      );
  }


}

