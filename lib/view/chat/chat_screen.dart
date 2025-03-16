import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:messenger_app/controller/add_contacts_controller.dart';
import 'package:messenger_app/controller/homechat_controller.dart';
import 'package:messenger_app/controller/status_controller.dart';
import 'package:messenger_app/controller/user_controller.dart';
import 'package:messenger_app/model/contacts_mode.dart';
import 'package:messenger_app/view/contacts/add_contacts_screen.dart';
import 'package:messenger_app/view/message/message_screen.dart';
import 'package:messenger_app/view/profile/profile_screen.dart';
import 'package:messenger_app/view/status/status_screen.dart';
import 'package:messenger_app/view/status/story_view.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class ChatScreen extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final ContactsController contactsController = Get.put(ContactsController());
  final HomeChatController homeChatController = Get.put(HomeChatController());
  final StatusController _statusController = Get.put(StatusController());

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 16.h),
          _buildHeader(context),
          SizedBox(height: 16.h),
          _buildStatusSection(),
          SizedBox(height: 16.h),
          Expanded(child: _buildChatList()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Get.to(MyProfileScreen(), transition: Transition.fadeIn);
            },
            child: Obx(() {
              final user = userController.user.value;

              return CircleAvatar(
                backgroundImage: (user?.profileImage != null &&
                        (user!.profileImage!.startsWith('http') ||
                            user.profileImage!.startsWith('https')))
                    ? NetworkImage(user.profileImage!)
                    : const AssetImage("assets/images/pr2.png")
                        as ImageProvider,
                radius: 24.sp,
              );
            }),
          ),
          Text(
            'Chats',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Bernhardt',
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white, size: 24.sp),
            onPressed: () {
              Get.to(AddContactScreen(), transition: Transition.fadeIn);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SizedBox(
            height: 80.h,
            child: Column(
              children: [
                Obx(() {
                  final user = userController.user.value;

                  final statusList = _statusController.statusModel.value;
                  List<StoryItem> storyItems = statusList
                      .map((status) => StoryItem.pageImage(
                          url: status.imageUrl ?? 'Images',
                          controller: StoryController()))
                      .toList();

                  return InkWell(
                    onTap: () {
                      Get.to(() => StoryViewScreen(storyItems: storyItems));
                    },
                    child: CircleAvatar(
                      backgroundImage: (user?.profileImage != null &&
                              (user!.profileImage!.startsWith('http') ||
                                  user.profileImage!.startsWith('https')))
                          ? NetworkImage(user.profileImage!)
                          : const AssetImage("assets/images/pr2.png")
                              as ImageProvider,
                      radius: 30.sp,
                    ),
                  );
                }),
                SizedBox(height: 4.h),
                Text(
                  'Your Status',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Bernhardt',
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(child: Obx(() {
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

          return SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: statusList.length,
              itemBuilder: (context, index) {
             
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: InkWell(
                    onTap: () {
                      List<StoryItem> storyItems = statusData.map((e) {
                        return StoryItem.pageImage(
                          url: e.imageUrl ?? '',
                          controller: StoryController(),
                        );
                      }).toList();

                      print("user id is " +
                          FirebaseAuth.instance.currentUser!.uid);
                      print("status id: ${statusList.length}");
                      print("img url ${statusData[index].imageUrl}");
                      Get.to(StoryViewScreen(storyItems: storyItems));
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              statusList[index].picture![index] ?? ''),
                          radius: 30.sp,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          statusList[index].name![index] ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Bernhardt',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        })),
      ],
    );
  }

  Widget _buildChatList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.sp),
          topRight: Radius.circular(30.sp),
        ),
      ),
      child: Obx(() {
        if (homeChatController.isLoading.value) {
          return Center(
              child: CircularProgressIndicator()); 
        }

        if (homeChatController.chatRooms.isEmpty) {
          return Center(
            child: Text(
              'No Chats Found',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Bernhardt',
                ),
              ),
            ),
          );
        }

        //
        //   print("chat rooms: ${homeChatController.chatRooms.length}");

        return ListView(
          children: homeChatController.chatRooms
              .toSet() 
              .map((e) {
            final uid = FirebaseAuth.instance.currentUser!.uid;

            String name = (e.receiver?.id == uid)
                ? e.sender?.name ?? ''
                : e.receiver?.name ?? '';
            String about = (e.receiver?.id == uid)
                ? e.sender?.about ?? ''
                : e.receiver?.about ?? '';
            String image = (e.receiver?.id == uid)
                ? e.sender?.profileImage ?? ''
                : e.receiver?.profileImage ?? '';
            ContactsModel? contact =
                (e.receiver?.id == uid) ? e.sender : e.receiver;
            String receiverIdContact =
                (e.receiver?.id == uid) ? e.sender!.id! : e.receiver!.id!;
            String receiverEmail =
                (e.receiver?.id == uid) ? e.sender!.email! : e.receiver!.email!;

            print("receiverId isssssss: $receiverIdContact");

            return ListTile(
              contentPadding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 20.w,
                right: 16.w,
              ),
              leading: CircleAvatar(
                backgroundImage: image.isNotEmpty
                    ? NetworkImage(image)
                    : const AssetImage("assets/images/pr2.png")
                        as ImageProvider,
              ),
              title: Text(
                name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Bernhardt',
                ),
              ),
              subtitle: Text(
                e.lastMessage ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontFamily: 'Bernhardt',
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 8.sp,
                    child: Text(
                      "1", 
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontFamily: 'Bernhardt',
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                print("Chat room: ${e.id}");
                Get.to(
                    () => MessageScreen(
                          contactsModel: contact!,
                          userProfileImage: image,
                          receiverId: receiverIdContact,
                          receiverName: name,
                          receiverEmail: receiverEmail,
                          about: about,
                        ),
                    transition: Transition.fade);
              },
            );
          }).toList(),
        );
      }),
    );
  }
}
