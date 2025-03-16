import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/controller/user_controller.dart';
import 'package:messenger_app/model/chat_room_model.dart';
import 'package:messenger_app/model/contacts_mode.dart';
import 'package:messenger_app/model/user_model.dart'; // Ensure UserModel is imported correctly
import 'package:messenger_app/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/view/message/message_screen.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController messageController = TextEditingController();
  File? imageFile;
  File? videoFile;
  var isPicking = false.obs; 

  RxList<MessageModel> messages =
      <MessageModel>[].obs; 
  RxBool isLoading = true.obs;

  RxList<ContactsModel> senderModelList = <ContactsModel>[].obs; 
  


  Future<void> fetchMessages(String roomId) async {
    isLoading.value = true;

    try {
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(roomId)
          .collection("messages")
          .orderBy("timestamp",
              descending: false) 
          .snapshots()
          .listen((snapshot) {
        messages.clear(); 
        for (var doc in snapshot.docs) {
          messages.add(
              MessageModel.fromJson(doc.data())); 
        }
        isLoading.value = false; 
      });
    } catch (e) {
      _showErrorSnackbar(e.toString());
      isLoading.value = false;
    }
  }

  String? generateRoomId(String receiverId) {
    final senderId = userId;
    if (senderId.hashCode <= receiverId.hashCode) {
      return '$senderId-$receiverId';
    } else {
      return '$receiverId-$senderId';
    }
  }
String generateCallId(String receiverId) {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    if (senderId.hashCode <= receiverId.hashCode) {
      return '$senderId-$receiverId';
    } else {
      return '$receiverId-$senderId';
    }
  }



  Future<void> pickImage() async {
    if (isPicking.value) return; 
    isPicking.value = true;

    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? value = await _picker.pickImage(source: ImageSource.gallery);
      if (value != null) {
        imageFile = File(value.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      isPicking.value = false; 
    }
  }

  Future<void> pickVideo() async {
    if (isPicking.value) return; 
    isPicking.value = true;
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? value = await _picker.pickVideo(source: ImageSource.gallery);
      if (value != null) {
        videoFile = File(value.path);
      }
    } catch (e) {
      print('Error picking video: $e');
    } finally {
      isPicking.value = false; 
    }
  }

Future<String?> uploadMedia(File mediaFile) async {
  try {
    var uploadRef = await FirebaseStorage.instance
        .ref()
        .child('chatrooms/$userId')
        .child('${DateTime.now().millisecondsSinceEpoch}');

    await uploadRef.putFile(mediaFile);
    var downloadUrl = await uploadRef.getDownloadURL();
    print('Media uploaded: $downloadUrl');
    return downloadUrl;
  } catch (e) {
    print('Error uploading media: $e');
    return null; 
  }
}


 Future<void> sendMessage(
  String message,
  String receiverId,
  ContactsModel receiverModel, {
  File? mediaFile, 
  String? mediaType, 
}) async {
  var uuid = const Uuid();
  try {
    String? roomId = generateRoomId(receiverId);
    print("Room ID: $roomId");

    var result = await FirebaseFirestore.instance
        .collection("contacts")
        .doc(userId)
        .collection("searchedContacts")
        .where('receiver.id', isEqualTo: receiverId)
        .get();

    if (result.docs.isNotEmpty) {
      var contactData = result.docs.first.data();
      var senderData = contactData['sender'];

      if (senderData != null) {
        var senderModel = ContactsModel.fromJson(senderData);

        senderModelList.add(senderModel);
        
        var chatRoomDoc = await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(roomId)
            .get();

        if (!chatRoomDoc.exists) {
          await FirebaseFirestore.instance
              .collection("chatrooms")
              .doc(roomId)
              .set({
            'lastMessage': message,
            'senderDetails': senderModel.toJson(),
            'receiverDetails': receiverModel.toJson(),
          });


          print("Chat Room created: $roomId");
        } else {
          await FirebaseFirestore.instance
              .collection("chatrooms")
              .doc(roomId)
              .update({
            'lastMessage': message,
          });

          var existingData = chatRoomDoc.data() ?? {};
          if (existingData['receiverDetails'] == null ||
              existingData['receiverDetails']['id'] != receiverModel.id) {
            await FirebaseFirestore.instance
                .collection("chatrooms")
                .doc(roomId)
                .update({
              'receiverDetails': receiverModel.toJson(),
            });
          }

          if (existingData['senderDetails'] == null ||
              existingData['senderDetails']['id'] != senderModel.id) {
            await FirebaseFirestore.instance
                .collection("chatrooms")
                .doc(roomId)
                .update({
              'senderDetails': senderModel.toJson(),
            });
          }
          print("Chat Room updated: $roomId with lastMessage: $message");
        }

        String? mediaUrl;
        if (mediaFile != null) {
          mediaUrl = await uploadMedia(mediaFile);
        }

        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(roomId)
            .collection("messages")
            .doc(uuid.v4())
            .set(
              MessageModel(
                senderId: userId,
                messageId: uuid.v4(),
                messageContent: message,
                timestamp: Timestamp.now(),
                imageUrl: mediaUrl, 
                messageType: mediaType, 
              ).toJson(),
            );
      } else {
        _showErrorSnackbar('Sender details not found.');
      }
    } else {
      _showErrorSnackbar('Add contact first before sending message.');
    }
  } catch (e) {
    _showErrorSnackbar('An error occurred: ${e.toString()}');
  }
}


  Stream<List<MessageModel>> getMessagesStream(String receiverId) async* {
    String? roomId = await generateRoomId(receiverId);
    if (roomId != null) {
      yield* FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(roomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList();
      });
    
    }
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'No timestamp';
    }
    DateTime dateTime = timestamp.toDate();
    DateTime localDateTime = dateTime.toLocal();

    return DateFormat('h:mm a').format(localDateTime);
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar('Success', message, snackPosition: SnackPosition.BOTTOM);
  }
}
