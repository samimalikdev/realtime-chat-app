import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/controller/edit_screen_controller.dart';
import 'package:messenger_app/controller/status_controller.dart';
import 'package:messenger_app/controller/user_controller.dart';
import 'package:messenger_app/model/contacts_mode.dart';
import 'package:messenger_app/model/status_model.dart';
import 'package:messenger_app/view/status/story_view.dart';
import 'package:story_view/story_view.dart';
import 'package:uuid/uuid.dart';


class StatusScreen extends StatelessWidget {
  final StatusController _statusController = Get.put(StatusController());
  final EditScreenController _editScreenController =
      Get.put(EditScreenController());

  StatusScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 20.h),
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Obx(() {
                  return _statusController.isUploading.value
                      ? CircularProgressIndicator()
                      : IconButton(
                          onPressed: () async {
                            await _statusController.pickImage();
                            if (_statusController.image.value != null) {
                              await _statusController.uploadStatus();
                            } else {
                              print("No image selected.");
                            }
                          },
                          icon:
                              Icon(Icons.add, color: Colors.white, size: 22.sp),
                        );
                })
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.sp),
                  topRight: Radius.circular(25.sp),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    _buildMyStatus(),
                    SizedBox(height: 12.h),
                    InkWell(
                        onTap: () {
                          _statusController.fetchStatus();
                        },
                        child: _buildStatusTitle('Recent Updates')),
                    _buildStatusList(),
                 
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyStatus() {
    return Obx(() {
      final statusList = _statusController.statusModel.value;
      List<StoryItem> storyItems = statusList
          .map((status) => StoryItem.pageImage(
              url: status.imageUrl ?? 'Images', controller: StoryController()))
          .toList();
      return InkWell(
        onTap: () {
          Get.to(() => StoryViewScreen(storyItems: storyItems));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12.sp),
          ),
          padding: EdgeInsets.all(12.sp),
          child: Row(
            children: [
              Obx(() {
                final statusModel = _statusController.statusModel.value;
                if (statusModel.isEmpty) {
                  return CircleAvatar(
                    backgroundImage: const AssetImage('assets/images/pr2.png'),
                    radius: 30.sp,
                  );
                } else {
                  final status = statusModel[0];
                  return CircleAvatar(
                    backgroundImage: NetworkImage(status.statusProfilePic!),
                    radius: 30.sp,
                  );
                }
              }),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'My Status',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                },
                icon:
                    Icon(Icons.arrow_forward, color: Colors.white, size: 22.sp),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatusTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildStatusList() {
    return Obx(() {
      final statusList = _statusController.statuses;
      final statusData = _statusController.statusData;

      if (statusList.isEmpty || statusData.isEmpty) {
        return Center(
          child: Text(
            "No statuses found",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        );
      }
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: statusList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(statusList[index].picture![index] ?? ''),
              radius: 35.r,
            ),
            title: Text(
              statusList[index].name![index] ?? '',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            onTap: () {
              List<StoryItem> storyItems = statusData.map((status) {
                return StoryItem.pageImage(
                  url: status.imageUrl ?? '',
                  controller: StoryController(),
                );
              }).toList();

              print("user id is " + FirebaseAuth.instance.currentUser!.uid);
              print("status id: ${statusList.length}");
              print("img url ${statusData[index].imageUrl}");
              Get.to(StoryViewScreen(storyItems: storyItems));
            },
          );
        },
      );
    });
  }

  

  
}
