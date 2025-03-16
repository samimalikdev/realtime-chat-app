import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messenger_app/controller/auth_controller.dart';
import 'package:messenger_app/controller/login_controller.dart';
import 'package:messenger_app/view/auth/forgot_password_screen.dart';
import 'package:messenger_app/view/auth/register_screen.dart';
import 'package:messenger_app/widgets/custom_text_field.dart';
import 'package:messenger_app/widgets/social_login_button.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final AuthController authController = Get.put(AuthController());

  LoginScreen({super.key});

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
            _buildLoginContainer(),
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
            'Connect and Stay Close', // Add tagline
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

  Widget _buildLoginContainer() {
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
              _buildLoginNowSection(),
              SizedBox(height: 20.h),
              _buildEmailField(),
              SizedBox(height: 10.h),
              _buildPasswordField(),
              _buildRememberMeAndForgotPassword(),
              SizedBox(height: 20.h),
              _buildLoginButton(),
              SizedBox(height: 20.h),
              _buildDivider(),
              SizedBox(height: 20.h),
              _buildSocialLoginButtons(),
              SizedBox(height: 30.h),
              _buildRegisterSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginNowSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Login Now',
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
            'Welcome back! Connect with friends and family around the world.',
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
        Obx(() {
          return CustomTextField(
            controller: authController.passwordController,
            obscureText: loginController.isPasswordVisible.value,
            hintText: "Enter your password",
            suffixIcon: IconButton(
              icon: Icon(
                loginController.isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                loginController.togglePasswordVisibility();
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      children: [
        Obx(() => Checkbox(
              activeColor: Colors.black,
              value: loginController.isRememberMe.value,
              onChanged: (value) {
                loginController.isRememberMe.value = value!;
              },
            )),
        Text(
          'Remember Me',
          style: TextStyle(
            fontFamily: 'Bernhardt',
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Get.to(() => ForgotPasswordScreen());
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              fontFamily: 'Bernhardt',
              fontSize: 12.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
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
          authController.login();
        },
        child: Text(
          'Login',
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
            },
          ),
          SizedBox(width: 16.w),
          SocialLoginButton(
            imagePath: 'assets/images/onlyfans.png',
            borderColor: Colors.black,
            onPressed: () {
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterSection() {
  return Padding(
    padding: EdgeInsets.only(bottom: 10.h), 
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end, 
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(
                fontFamily: 'Bernhardt',
                fontSize: 16.sp,
                color: Colors.black54,
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => RegisterScreen());
              },
              child: Text(
                'Register',
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
