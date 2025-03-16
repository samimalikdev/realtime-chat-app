
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/controller/edit_screen_controller.dart';
import 'package:messenger_app/controller/user_controller.dart';
import 'package:messenger_app/model/contacts_mode.dart';
import 'package:messenger_app/model/status_model.dart';
import 'package:uuid/uuid.dart';

class StatusController extends GetxController {
  var isMutedStatusExpanded = false.obs;
  final EditScreenController _editScreenController =
      Get.put(EditScreenController());
  final UserController _userController = Get.put(UserController());
  final ImagePicker _picker = ImagePicker();
  final image = Rx<File?>(null);
  final statusModel = Rx<List<StatusModel>>([]);
  final statuses = <StatusModel>[].obs;
  final statusData = <StatusModel>[].obs;
  var _uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
    fetchStatus();
    getReceiverStatus();
  }

  Future<void> pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image.value = File(pickedImage.path);
    }
  }

  final isUploading = false.obs;

  Future<String?> uploadImage() async {
    isUploading.value = true;
    try {
      if (image.value == null) {
        print("No image selected!");
        isUploading.value = false;
        return null; 
      }

      final storage = FirebaseStorage.instance
          .ref()
          .child("status")
          .child(_userController.getUserId()!)
          .child("${_uuid.v4()}");

      await storage.putFile(image.value!);

      final downloadUrl = await storage.getDownloadURL();

      if (downloadUrl.isNotEmpty) {
        isUploading.value = false;
      }
      print("Image uploaded: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      isUploading.value = false;
      print("Error uploading image: $e");
      return null;
    }
  }


  Future<List<Map<String, dynamic>>> getVisibleIds() async {
    List<StatusModel> otherUsersDetails = await getStoryContacts();

    return otherUsersDetails
        .where((e) => e.receiverId != null)
        .map((e) => {
              'receiverId': e.receiverId!, 
              'receiverName':
                  e.receiverName ?? '', 
              'receiverPic':
                  e.receiverPic ?? '', 
            })
        .toList();
  }

  Future<void> uploadStatus() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      final status = await uploadImage();
      if (status == null) {
        print("Error uploading status");
      }
      print("Status uploaded: $status");

      final userDetails = _userController.user.value;
      if (userDetails == null) {
        print("User details not found");
      }

      List<Map<String, dynamic>> visibleIds = await getVisibleIds();
      List<String> receiverPictures =
          visibleIds.map((e) => e['receiverPic'] as String).toList();
      List<String> receiverNames =
          visibleIds.map((e) => e['receiverName'] as String).toList();
      List<String> receiverIds =
          visibleIds.map((e) => e['receiverId'] as String).toList();

      DocumentReference docRef = await firestore
          .collection("statuses")
          .doc(_userController.getUserId())
          .collection("visibleTo")
          .doc(_userController.getUserId());

      StatusModel statusModel = StatusModel(
        visibleTo: receiverIds,
        picture: receiverPictures,
        name: receiverNames,
        statusName: userDetails!.name,
        statusProfilePic: userDetails.profileImage,
      );
      docRef.set(statusModel.toJson());

      StatusModel statusModel2 = StatusModel(
          imageUrl: status,
          isVideo: false,
          userId: _userController.getUserId(),
          timestamp: Timestamp.now(),
          statusName: userDetails.name,
          statusProfilePic: userDetails.profileImage);

      DocumentReference docRef2 = docRef.collection("userStatus").doc();

      docRef2.set(statusModel2.toJson());
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  Future<void> fetchStatus() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      final querySnapshot = await firestore
          .collection("statuses")
          .doc(_userController.getUserId())
          .collection("visibleTo")
          .doc(_userController.getUserId())
          .collection("userStatus")
          .where("userId", isEqualTo: _userController.getUserId())
          .get();

      print("Status fetched: ${querySnapshot.docs.length}");
      if (querySnapshot.docs.isNotEmpty) {
        statusModel.value = querySnapshot.docs
            .map((doc) => StatusModel.fromJson(doc.data()))
            .toList();

        if (statusModel.value.isNotEmpty) {
          print("Status added: ${statusModel.value.length}");
        }
      }
    } catch (e) {
      print("Error fetching status: $e");
    }
  }

  Future<List<StatusModel>> getStoryContacts() async {
    List<StatusModel> contacts = [];
    final querySnapshot = await FirebaseFirestore.instance
        .collection("contacts")
        .doc(_userController.getUserId())
        .collection("searchedContacts")
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        if (data['receiver'] != null) {
          var receiverData = data['receiver'];
          var receiverModel = ContactsModel.fromJson(receiverData);
          print(receiverModel.email);
          StatusModel status = StatusModel(
            receiverId: receiverModel.id,
            receiverName: receiverModel.name,
            receiverPic: receiverModel.profileImage,
          );
          contacts.add(status);
          print("Status added size is: ${contacts.length}");
        }
      }
    }
    return contacts;
  }

  Future<void> getReceiverStatus() async {
    List<StatusModel> contacts = [];
    List<StatusModel> receiverStatus = [];
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      print("User ID: ${_userController.getUserId()}");

      final snapshot = await firestore
          .collection("contacts")
          .doc(_userController.getUserId())
          .collection("searchedContacts")
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          var data = doc.data();
          if (data['receiver'] != null) {
            var receiverData = data['receiver'];
            var receiverModel = ContactsModel.fromJson(receiverData);
            print("Receiver email: ${receiverModel.id}");

            final querySnapshot = await firestore
                .collection("statuses")
                .doc(_userController.getUserId())
                .collection("visibleTo")
                .where("visibleTo", arrayContains: receiverModel.id)
                .get();

            print(
                "Number of status documents: sddssd ${querySnapshot.docs.length}");

            final receiverSnapshot = await firestore
                .collection("statuses")
                .doc(receiverModel.id)
                .collection("visibleTo")
                .where("visibleTo", arrayContains: _userController.getUserId())
                .get();

            if (receiverSnapshot.docs.isNotEmpty) {
              for (var doc in querySnapshot.docs) {
                var data = doc.data();
                StatusModel status = StatusModel.fromJson(data);
                contacts.add(status);
                statuses.assignAll(contacts);
              }

              final querySnapshot2 = await receiverSnapshot.docs.first.reference
                  .collection("userStatus")
                  .get();
              if (querySnapshot2.docs.isNotEmpty) {
                for (var doc in querySnapshot2.docs) {
                  var data = doc.data();
                  StatusModel status = StatusModel.fromJson(data);
                  receiverStatus.add(status);
                }
                statusData.assignAll(receiverStatus);
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error getting receiver status: $e");
    }
  }

 
}