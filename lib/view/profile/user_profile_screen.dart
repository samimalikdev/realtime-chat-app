import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messenger_app/controller/add_contacts_controller.dart';
import 'package:messenger_app/view/message/message_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final String profileImage; 
  final String name;
  final String email;
  final String about;

  UserProfileScreen({
    super.key,
    required this.profileImage,
    required this.name,
    required this.email,
    required this.about,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: profileImage.isEmpty ? const AssetImage('assets/images/pr2.png') : NetworkImage(profileImage),
                  radius: 40.sp,
                ),
                SizedBox(height: 5.h),
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Bernhardt',
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    fontFamily: 'Bernhardt',
                    fontSize: 16.sp,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: _buildIcon(Icons.message, 'Message'),
                    ),
                    _buildIcon(Icons.call, 'Call'),
                    _buildIcon(Icons.video_call, 'Video Call'),
                    _buildIcon(Icons.more_horiz, 'More'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.w),
              width: double.infinity, 
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.sp),
                  topRight: Radius.circular(30.sp),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    'Name',
                    style: TextStyle(
                      fontFamily: 'Bernhardt',
                      fontSize: 14.sp,
                      color: const Color(0xff797C7B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Bernhardt',
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Email',
                    style: TextStyle(
                      fontFamily: 'Bernhardt',
                      fontSize: 14.sp,
                      color: const Color(0xff797C7B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontFamily: 'Bernhardt',
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'About',
                    style: TextStyle(
                      fontFamily: 'Bernhardt',
                      fontSize: 14.sp,
                      color: const Color(0xff797C7B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    about,
                    style: TextStyle(
                      fontFamily: 'Bernhardt',
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Skills',
                    style: TextStyle(
                      fontFamily: 'Bernhardt',
                      fontSize: 14.sp,
                      color: const Color(0xff797C7B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Flutter, Dart, Firebase', 
                    style: TextStyle(
                      fontFamily: 'Bernhardt',
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Location',
                    style: TextStyle(
                      fontFamily: 'Bernhardt',
                      fontSize: 14.sp,
                      color: const Color(0xff797C7B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'San Francisco, CA',
                    style: TextStyle(
                      fontFamily: 'Bernhardt',
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xff051D13),
          radius: 24.sp, 
          child: Icon(
            icon,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Bernhardt',
            fontSize: 12.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
