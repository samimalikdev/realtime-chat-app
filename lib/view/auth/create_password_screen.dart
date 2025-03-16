import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messenger_app/widgets/custom_text_field.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  CreateNewPasswordScreen({super.key});

  bool _isValidPassword(String password) {
    return password.isNotEmpty && password.length >= 6; 
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
            _buildCreateNewPasswordContainer(),
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
            'Create New Password',
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

  Widget _buildCreateNewPasswordContainer() {
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
              _buildNewPasswordField(),
              SizedBox(height: 20.h),
              _buildConfirmPasswordField(),
              SizedBox(height: 20.h),
              _buildSubmitButton(),
              SizedBox(height: 20.h),
              _buildBackToLoginSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionText() {
    return Text(
      'Please enter your new password below. Ensure that it is at least 6 characters long.',
      style: TextStyle(
        fontFamily: 'Bernhardt',
        fontSize: 16.sp,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildNewPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Password',
          style: TextStyle(
            fontFamily: 'Bernhardt',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10.h),
        CustomTextField(
          controller: newPasswordController,
          hintText: "Enter your new password",
          obscureText: true,
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: TextStyle(
            fontFamily: 'Bernhardt',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10.h),
        CustomTextField(
          controller: confirmPasswordController,
          hintText: "Re-enter your new password",
          obscureText: true,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
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
          String newPassword = newPasswordController.text.trim();
          String confirmPassword = confirmPasswordController.text.trim();

          if (newPassword.isEmpty || confirmPassword.isEmpty) {
            Get.snackbar(
              'Password Required',
              'Please enter both password fields.',
              snackPosition: SnackPosition.BOTTOM,
            );
          } else if (newPassword != confirmPassword) {
            Get.snackbar(
              'Password Mismatch',
              'Passwords do not match. Please try again.',
              snackPosition: SnackPosition.BOTTOM,
            );
          } else if (!_isValidPassword(newPassword)) {
            Get.snackbar(
              'Invalid Password',
              'Password must be at least 6 characters long.',
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.snackbar(
              'Password Updated',
              'Your password has been successfully updated.',
              snackPosition: SnackPosition.BOTTOM,
            );
            Get.back(); 
          }
        },
        child: Text(
          'Submit',
          style: TextStyle(
            fontFamily: 'Bernhardt',
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
