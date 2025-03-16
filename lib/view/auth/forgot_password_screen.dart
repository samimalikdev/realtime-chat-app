import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messenger_app/view/auth/create_password_screen.dart';
import 'package:messenger_app/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  bool _isValidEmail(String email) {
    return email.isNotEmpty && email.contains('@') && email.contains('.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF121212)],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            _buildHeaderBlackContainer(),
            SizedBox(height: 20.h),
            _buildForgotPasswordContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBlackContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Forgot Password',
            style: TextStyle(
              fontFamily: 'Bernhardt',
              fontSize: 24.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordContainer() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.sp)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.sp,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 26.sp, vertical: 20.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInstructionText(),
              SizedBox(height: 20.h),
              _buildEmailField(),
              SizedBox(height: 20.h),
              _buildSendResetLinkButton(),
              SizedBox(height: 20.h),
              _buildBackToLoginSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please enter your email address to receive a password reset link.',
          style: TextStyle(
            fontFamily: 'Bernhardt',
            fontSize: 16.sp,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Check your inbox for the reset link and follow the instructions to create a new password.',
          style: TextStyle(
            fontFamily: 'Bernhardt',
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(
            fontFamily: 'Bernhardt',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10.h),
        CustomTextField(
          controller: emailController,
          hintText: "Enter your email",
        ),
      ],
    );
  }

  Widget _buildSendResetLinkButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.sp,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 15.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.sp),
          ),
        ),
        onPressed: () {
          String email = emailController.text.trim();

          if (email.isEmpty) {
            Get.snackbar(
              'Email Required',
              'Please enter your email address.',
              snackPosition: SnackPosition.BOTTOM,
            );
          } else if (!_isValidEmail(email)) {
            Get.snackbar(
              'Invalid Email',
              'Please enter a valid email address.',
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.snackbar(
              'Reset Link Sent',
              'A password reset link has been sent to $email.',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        child: InkWell(
          onTap: () {
            Get.to(() => CreateNewPasswordScreen());
          },
          child: Text(
            'Send Reset Link',
            style: TextStyle(
              fontFamily: 'Bernhardt',
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLoginSection() {
    return Center(
      child: TextButton(
        onPressed: () {
          Get.back(); 
        },
        child: Text(
          'Back to Login',
          style: TextStyle(
            fontFamily: 'Bernhardt',
            fontSize: 14.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
