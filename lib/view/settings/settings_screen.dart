import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messenger_app/controller/user_controller.dart';
import 'package:messenger_app/view/profile/edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    _userController.fetchUserData();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 30.h),
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'Bernhardt', 
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 24.sp), 
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.w),
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
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Row(
                      children: [
                        Obx(() {
                          final user = _userController.user.value;
                          
                          if (user == null) {
                            return const CircularProgressIndicator();
                          }
                          return CircleAvatar(
                            backgroundImage: user.profileImage == null 
                              ? const AssetImage("assets/images/pr2.png") 
                              : NetworkImage(user.profileImage!),
                            radius: 40.sp,
                          );
                        }),
                        SizedBox(width: 16.w),
                        Obx(() {
                          final user = _userController.user.value;
                          if (user == null) {
                            return const CircularProgressIndicator();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? '',
                                style: TextStyle(
                                  fontFamily: 'Bernhardt',  
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user.email ?? '',
                                style: TextStyle(
                                  fontFamily: 'Bernhardt', 
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          );
                        })
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildSettingsItem('Profile', Icons.person, () {
                          Get.to(() => EditProfileScreen());
                        }),
                        _buildSettingsItem('Account', Icons.account_circle, () {}),
                        _buildSettingsItem('Abo4ut', Icons.info, () {}),
                        _buildSettingsItem('Privacy', Icons.lock, () {}),
                        _buildSettingsItem('Help', Icons.help, () {}),
                        _buildSettingsItem('Invite a Friend', Icons.share, () {}),
                      ],
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

  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        leading: Icon(icon, color: Colors.black, size: 24.sp),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Bernhardt',  
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
