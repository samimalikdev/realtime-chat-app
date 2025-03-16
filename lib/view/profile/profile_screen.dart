import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messenger_app/controller/auth_controller.dart';
import 'package:messenger_app/controller/user_controller.dart';
import 'package:messenger_app/model/user_model.dart';

class MyProfileScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final UserController userController = Get.put(UserController());

  MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    userController.fetchUserData();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [

          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Padding(
              padding: EdgeInsets.only(top: 24.0.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  Text(
                    'My Profile',
                    style: TextStyle(
                      fontFamily: 'Bernhardt', 
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                      width: 24.sp), 
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),
          Obx(() {
            final user = userController.user.value;
            if (user == null) {
              return const Text('No user data available',
                  style: TextStyle(color: Colors.white));
            }
            return CircleAvatar(
              backgroundImage: user.profileImage == null
                  ? const AssetImage("assets/images/pr2.png")
                  : NetworkImage(user.profileImage!),
              radius: 50.sp,
              backgroundColor: Colors.black,
            );
          }),
          SizedBox(height: 16.h),

          Obx(() {
            final user = userController.user.value;
            if (user == null) {
              return const Text('No user data available',
                  style: TextStyle(color: Colors.white));
            }
            return Column(
              children: [
                Text(
                  user.name ?? 'No name provided',
                  style: TextStyle(
                    fontFamily: 'Bernhardt', 
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  user.email ?? 'No email provided',
                  style: TextStyle(
                    fontFamily: 'Bernhardt', 
                    fontSize: 16.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            );
          }),

          SizedBox(height: 32.h),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.sp),
                  topRight: Radius.circular(30.sp),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final user = userController.user.value;
                    if (user == null) {
                      return const Text('No user data available',
                          style: TextStyle(color: Colors.black));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: TextStyle(
                            fontFamily: 'Bernhardt', 
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          user.about ?? "No bio provided",
                          style: TextStyle(
                            fontFamily: 'Bernhardt',
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    );
                  }),

                  SizedBox(height: 24.h),
                  const Divider(color: Colors.black, thickness: 1.2),
                  SizedBox(height: 16.h),

                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontFamily: 'Bernhardt', 
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5, 
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.black, size: 20.sp),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  'Activity ${index + 1}: Description of the activity goes here.',
                                  style: TextStyle(
                                    fontFamily: 'Bernhardt', 
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        authController.logout();
                      },
                      icon:
                          Icon(Icons.logout, size: 20.sp, color: Colors.white),
                      label: Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'Bernhardt', 
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.sp),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
