import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messenger_app/controller/add_contacts_controller.dart';
import 'package:messenger_app/controller/edit_screen_controller.dart';
import 'package:messenger_app/controller/user_controller.dart';

class EditProfileScreen extends StatelessWidget {
  final UserController _userController = Get.put(UserController());
  final EditScreenController _editScreenController =
      Get.put(EditScreenController());

  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _userController.fetchUserData();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      Text(
                        'Edit Profile',
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
              Center(
                child: Obx(() {
                  final user = _userController.user.value;
                  final isLoading = _editScreenController.isLoading.value;

                  if (isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (user == null) {
                    return const CircularProgressIndicator();
                  }
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        backgroundImage: user.profileImage == null
                            ? const AssetImage("assets/images/pr2.png")
                            : NetworkImage(user.profileImage!),
                        radius: 50.sp,
                        backgroundColor: Colors.black,
                      ),
                      Positioned(
                        bottom: -5.h,
                        right: -5.w,
                        child: InkWell(
                          onTap: () {
                            _editScreenController.pickImage();
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 2.sp),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 16.h),

              Container(
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
                    // Name Field
                    Text(
                      'Name',
                      style: TextStyle(
                        fontFamily: 'Bernhardt',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    Obx(() {
                      final user = _userController.user.value;
                      if (user == null) {
                        return const CircularProgressIndicator();
                      }
                      _editScreenController.genderController.text =
                          user.gender ?? 'None';
                      _editScreenController.nameController.text =
                          user.name ?? '';
                      _editScreenController.aboutController.text =
                          user.about ?? '';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _editScreenController.nameController,
                            style: TextStyle(
                              fontFamily: 'Bernhardt',
                              fontSize: 16.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(
                                fontFamily: 'Bernhardt',
                                fontSize: 16.sp,
                                color: Colors.black54,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.sp),
                                borderSide:
                                    const BorderSide(color: Colors.black54),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.sp),
                                borderSide:
                                    const BorderSide(color: Colors.black54),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.sp),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          Text(
                            'Gender',
                            style: TextStyle(
                              fontFamily: 'Bernhardt',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextField(
                            controller: _editScreenController.genderController,
                            style: TextStyle(
                              fontFamily: 'Bernhardt',
                              fontSize: 16.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your gender',
                              hintStyle: TextStyle(
                                fontFamily: 'Bernhardt',
                                fontSize: 16.sp,
                                color: Colors.black54,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.sp),
                                borderSide:
                                    const BorderSide(color: Colors.black54),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.sp),
                                borderSide:
                                    const BorderSide(color: Colors.black54),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.sp),
                                borderSide: const BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // About Field
                          Text(
                            'About',
                            style: TextStyle(
                              fontFamily: 'Bernhardt',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextField(
                            controller: _editScreenController.aboutController,
                            maxLines: 4,
                            style: TextStyle(
                              fontFamily: 'Bernhardt',
                              fontSize: 16.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Tell us about yourself',
                              hintStyle: TextStyle(
                                fontFamily: 'Bernhardt',
                                fontSize: 16.sp,
                                color: Colors.black54,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.sp),
                                borderSide:
                                    const BorderSide(color: Colors.black54),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.sp),
                                borderSide:
                                    const BorderSide(color: Colors.black54),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.sp),
                                borderSide: const BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    SizedBox(height: 24.h),

                    // Save Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _editScreenController.saveProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.w, vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.sp),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            fontFamily: 'Bernhardt',
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
