import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:messenger_app/config/strings.dart';
import 'package:messenger_app/controller/call_controller.dart';
import 'package:messenger_app/controller/message_controller.dart';
import 'package:messenger_app/controller/user_controller.dart';
import 'package:messenger_app/model/audio_call_model.dart';
import 'package:messenger_app/model/contacts_mode.dart';
import 'package:messenger_app/model/message_model.dart';
import 'package:messenger_app/view/profile/user_profile_screen.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class MessageScreen extends StatelessWidget {
  final ContactsModel contactsModel;
  final String receiverId;
  final String userProfileImage;
  final String receiverName;
  final String? receiverEmail;
  final String? about;

  final ChatController chatController = Get.put(ChatController());
  final UserController userController = Get.put(UserController());

  Map<String, dynamic> _fetchedPreviewData = {};

  MessageScreen({
    super.key,
    required this.contactsModel,
    required this.receiverId,
    required this.userProfileImage,
    required this.receiverName,
    this.receiverEmail,
    this.about,
  });

  @override
  Widget build(BuildContext context) {
    CallController callController = Get.put(CallController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Get.to(() => UserProfileScreen(
                      profileImage: userProfileImage,
                      name: receiverName,
                      about: receiverEmail ?? 'Unknown',
                      email: about ?? 'Unknown',
                    ));
              },
              child: CircleAvatar(
                backgroundImage: (userProfileImage.isNotEmpty &&
                        (userProfileImage.startsWith('http') ||
                            userProfileImage.startsWith('https')))
                    ? NetworkImage(userProfileImage)
                    : const AssetImage('assets/images/pr2.png')
                        as ImageProvider,
                radius: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receiverName ?? 'Unknown',
                    style: const TextStyle(
                      fontFamily: 'Bernhardt',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  const Row(
                    children: [
                      Icon(Icons.circle, color: Colors.green, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'Online',
                        style: TextStyle(
                          fontFamily: 'Bernhardt',
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.video_call, color: Colors.black, size: 24),
              onPressed: () {
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.call, color: Colors.black, size: 24),
              onPressed: () {
                var sender = chatController.senderModelList;
                var callId = chatController.generateCallId(receiverId);

                  String? callerName = (receiverId == FirebaseAuth.instance.currentUser!.uid)
                ? sender?.first.name ?? ''
                : receiverName ?? '';

                print("Call Name: $callerName");
             try {
                  Get.to(() => ZegoUIKitPrebuiltCall(
                      appID: ZegoCloudConfig.appID,
                      appSign: ZegoCloudConfig.appSign,
                      userID: sender.first.id ?? 'root',
                      userName: sender.first.name ?? 'root',
                      callID: callId,
                      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
                    ));

                 callController.startCall(
                  receiverId: receiverId,
                  callType: 'audio',
                  receiverName: sender.first.name ?? 'Unknown',
                  receiverProfileImage: userProfileImage,
                  userName: callerName,
                ); 
             } catch (e) {
                  print("call error is ja: $e");
                }
                
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final user = userController.user.value;
              return StreamBuilder<List<MessageModel>>(
                stream: chatController.getMessagesStream(receiverId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        width: 300,
                        height: 200,
                        child: Lottie.asset(
                          'assets/animation/amongus.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No messages'));
                  }

                  List<MessageModel> messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderId ==
                          FirebaseAuth.instance.currentUser?.uid;

                      // String receiverContactId = isMe ? contactsModel.sender?.id ?? '' : contactsModel.receiver?.id ?? '';
                      // print("receiverContactId: ${receiverContactId}");
                      // print("isMe: $isMe");

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isMe) ...[
                              CircleAvatar(
                                backgroundImage: (userProfileImage.isNotEmpty &&
                                        (userProfileImage.startsWith('http') ||
                                            userProfileImage
                                                .startsWith('https')))
                                    ? NetworkImage(userProfileImage)
                                    : const AssetImage('assets/images/pr2.png')
                                        as ImageProvider,
                                radius: 20,
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isMe ? Colors.black : Colors.grey[200],
                                    borderRadius: isMe
                                        ? BorderRadius.only(
                                            topLeft: Radius.circular(12.sp),
                                            bottomLeft: Radius.circular(12.sp),
                                            bottomRight: Radius.circular(12.sp),
                                          )
                                        : BorderRadius.only(
                                            topRight: Radius.circular(12.sp),
                                            bottomLeft: Radius.circular(12.sp),
                                            bottomRight: Radius.circular(12.sp),
                                          ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: const Offset(0, 1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      if (message.messageContent!
                                          .contains('http')) ...[
                                        LinkPreview(
                                          openOnPreviewImageTap: true,
                                          openOnPreviewTitleTap: true,
                                          enableAnimation: true,
                                          onPreviewDataFetched: (data) {
                                            if (!_fetchedPreviewData
                                                .containsKey(
                                                    message.messageContent)) {
                                              _fetchedPreviewData[message
                                                  .messageContent!] = data;
                                            }
                                          },
                                          previewData: _fetchedPreviewData[message
                                              .messageContent], 
                                          text: message.messageContent!,
                                          width: double.infinity,
                                          textStyle: TextStyle(
                                            fontFamily: 'Bernhardt',
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14,
                                          ),
                                          metadataTextStyle: TextStyle(
                                            fontFamily: 'Bernhardt',
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14,
                                          ),
                                          metadataTitleStyle: TextStyle(
                                            fontFamily: 'Bernhardt',
                                            color: isMe
                                                ? Colors.yellow
                                                : Colors.blue,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ] else if (message.imageUrl != null &&
                                          message.imageUrl!.isNotEmpty) ...[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            message.imageUrl!,
                                            width:
                                                250.w, 
                                            height: 150
                                                .h, 
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ] else if (message.videoUrl != null &&
                                          message.videoUrl!.isNotEmpty) ...[
                                        Text(
                                            "Video message (Link): ${message.videoUrl}"),
                                      ] else ...[
                                        Text(
                                          message.messageContent ?? '',
                                          style: TextStyle(
                                            fontFamily: 'Bernhardt',
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 4),
                                      Text(
                                        chatController
                                            .formatTimestamp(message.timestamp),
                                        style: TextStyle(
                                          fontFamily: 'Bernhardt',
                                          color: isMe
                                              ? Colors.white54
                                              : Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 12),
                              CircleAvatar(
                                backgroundImage: (user?.profileImage != null &&
                                        (user!.profileImage!
                                                .startsWith('http') ||
                                            user.profileImage!
                                                .startsWith('https')))
                                    ? NetworkImage(user.profileImage!)
                                    : const AssetImage("assets/images/pr2.png")
                                        as ImageProvider,
                                radius: 20,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.image, color: Colors.black, size: 24),
                    onPressed: () {
                      chatController.pickImage();
                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.emoji_emotions,
                        color: Colors.black, size: 24),
                    onPressed: () {
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: chatController.messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          fontFamily: 'Bernhardt',
                          color: Colors.black54,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.black, size: 24),
                    onPressed: () {
                      String messageContent =
                          chatController.messageController.text.trim();
                      if (messageContent.isNotEmpty ||
                          chatController.imageFile != null ||
                          chatController.videoFile != null) {
                        chatController.sendMessage(
                          messageContent,
                          receiverId,
                          contactsModel,
                          mediaFile: chatController.imageFile ??
                              chatController.videoFile,
                          mediaType: chatController.imageFile != null
                              ? "image"
                              : "video",
                        );
                        chatController.messageController
                            .clear(); 
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
