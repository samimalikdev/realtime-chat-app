import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconButton? suffixIcon;

  const CustomTextField({super.key, 
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,

      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0.sp),
          borderSide: const BorderSide(
            color: Colors.black,
            
          ),
        ),
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        hintStyle:  TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
            fontWeight: FontWeight.w300,
            fontFamily: 'Bernhardt',
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
