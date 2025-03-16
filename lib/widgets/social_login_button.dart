import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialLoginButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final Color borderColor;

  const SocialLoginButton({
    required this.imagePath,
    required this.onPressed,
    required this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.sp,
      height: 50.sp,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor, 
          width: 1.0, 
        ),
      ),
      child: IconButton(
        icon: Image.asset(imagePath, width: 30.sp), 
        onPressed: onPressed,
      ),
    );
  }
}
