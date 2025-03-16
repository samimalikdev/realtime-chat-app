import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:messenger_app/model/contacts_mode.dart';

class HomeChatController extends GetxController {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  RxList<ContactsModel> chatRooms = <ContactsModel>[].obs; 
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    fetchChatRooms();
    super.onInit();
  }

 

Future<void> fetchChatRooms() async {
  try {
    print("User ID: $userId");
     isLoading.value = true;

    firestore.collection("chatrooms").snapshots().listen((querySnapshot) {
      List<ContactsModel> tempChatRoomList = [];

      tempChatRoomList = querySnapshot.docs.map((doc) {
        return ContactsModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      chatRooms.value = tempChatRoomList.where((e) {
        bool isInSender = e.sender?.id == userId; 
        bool isInReceiver = e.receiver?.id == userId; 
        print("return: $isInSender || $isInReceiver");
        return isInSender || isInReceiver; 
        
      }).toList();

      print("Total chat rooms: ${chatRooms.length}");
    });
  } catch (e) {
    _showErrorSnackbar(e.toString());
  } finally {
      isLoading.value = false; 
    }
}





  void _showErrorSnackbar(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }
}
