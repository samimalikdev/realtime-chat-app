import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messenger_app/controller/auth_controller.dart';
import 'package:messenger_app/widgets/custom_text_field.dart';
import 'package:messenger_app/widgets/social_login_button.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final RxBool isAgreed = false.obs; 

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF121212)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              _buildHeaderBlackContainer(),
              SizedBox(height: 20.h),
              _buildRegisterContainer(),
            ],
          ),
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
            'Join Us and Connect',
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

  Widget _buildRegisterContainer() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRegisterNowSection(),
          SizedBox(height: 20.h),
          _buildNameField(),
          SizedBox(height: 10.h),
          _buildEmailField(),
          SizedBox(height: 10.h),
          _buildPasswordField(),
          SizedBox(height: 20.h),
          _buildAgreeCheckbox(), 
          SizedBox(height: 20.h),
          _buildRegisterButton(),
          SizedBox(height: 10.h),
          _buildDivider(),
          SizedBox(height: 20.h),
          _buildSocialLoginButtons(),
          SizedBox(height: 20.h),
          _buildLoginSection(),
        ],
      ),
    );
  }

  Widget _buildRegisterNowSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Register Now',
          style: TextStyle(
            fontFamily: 'Bernhardt',
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10.h),
        Center(
          child: Text(
            'Create an account to connect with friends and family.',
            style: TextStyle(
              fontFamily: 'Bernhardt',
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name',
          style: TextStyle(
            fontFamily: 'Bernhardt',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10.h),
        CustomTextField(
          controller: authController.nameController,
          hintText: "Enter your name",
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
          controller: authController.emailController,
          hintText: "Enter your email",
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontFamily: 'Bernhardt',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10.h),
        CustomTextField(
          controller: authController.passwordController,
          hintText: "Enter your password",
          obscureText: true,
        ),
      ],
    );
  }

  Widget _buildAgreeCheckbox() {
    return Obx(() => Row(
      children: [
        Checkbox(
          value: isAgreed.value,
          onChanged: (value) {
            isAgreed.value = value ?? false;
          },
          activeColor: Colors.black,
        ),
        Expanded(
          child: Text(
            'I agree to the terms and conditions',
            style: TextStyle(
              fontFamily: 'Bernhardt',
              fontSize: 14.sp,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildRegisterButton() {
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
          if (isAgreed.value) {
            authController.register();
          } else {
            Get.snackbar(
              'Error',
              'You must agree to the terms and conditions to register.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        },
        child: Text(
          'Register',
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

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.grey)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Text(
            'or',
            style: TextStyle(
              fontFamily: 'Bernhardt',
              fontSize: 16.sp,
              color: Colors.black54,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SocialLoginButton(
            imagePath: 'assets/images/facebook.png',
            borderColor: Colors.black,
            onPressed: () {
            },
          ),
          SizedBox(width: 16.w),
          SocialLoginButton(
            imagePath: 'assets/images/google.png',
            borderColor: Colors.black,
            onPressed: () {
              // Handle Google login
            },
          ),
          SizedBox(width: 16.w),
          SocialLoginButton(
            imagePath: 'assets/images/onlyfans.png',
            borderColor: Colors.black,
            onPressed: () {
              // Handle OnlyFans login
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginSection() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: TextStyle(
                  fontFamily: 'Bernhardt',
                  fontSize: 16.sp,
                  color: Colors.black54,
                ),
              ),
              InkWell(
                onTap: () {
                  Get.back(); 
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'Bernhardt',
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
