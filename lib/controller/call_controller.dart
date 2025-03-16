import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/config/strings.dart';
import 'package:messenger_app/controller/message_controller.dart';
import 'package:messenger_app/model/audio_call_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatController chatController = Get.put(ChatController());
  var isCalling = false.obs;
late String appId;
  late String token;

  @override
  void onInit() {
    super.onInit();
    listenForIncomingCalls();
  }


  void startCall({
    required String receiverId,
    required String callType, 
    required String receiverName,
    required String receiverProfileImage,
    required String userName,
  }) {
    var currentUserId = _auth.currentUser?.uid ?? 'unknown';
    var callId = chatController.generateCallId(receiverId);
    
    // ZegoUIKitPrebuiltCallConfig config = callType == 'audio'
    //     ? ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
    //     : ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall();

    // Get.to(() => ZegoUIKitPrebuiltCall(
    //       appID: ZegoCloudConfig.appID, 
    //       appSign: ZegoCloudConfig.appSign,
    //       userID: currentUserId,
    //       userName: receiverName,
    //       callID: callId,
    //       config: config,
    //     ));



    sendCallNotification(receiverId, callType, callId, userName);
    updateCallStatus(currentUserId, receiverId, callId);
  }

  void listenForIncomingCalls() {
    var currentUserId = _auth.currentUser?.uid;

    if (currentUserId == null) {
      print("Error: Current user ID is null.");
      return;
    }
    _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: currentUserId)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        var data = doc.data();
        var callType = data['callType'];
        var callerName = data['title'];

        Get.snackbar(
          "Incoming Call",
          "$callerName is calling you",
          icon: const Icon(Icons.call, color: Colors.white),
          colorText: Colors.white,
          backgroundColor: Colors.green[400],
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () {
              Get.to(() => ZegoUIKitPrebuiltCall(
                appID: ZegoCloudConfig.appID, 
                appSign: ZegoCloudConfig.appSign,
                userID: _auth.currentUser!.uid,
                userName: callerName,
                callID: data['callId'],
                config: callType == 'audio' 
                    ? ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall() 
                    : ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
              ));
            },
            child: const Text("Answer", style: TextStyle(color: Colors.white)),
          ),
        );

        doc.reference.delete();
      }
    });
  }

 Future<void> sendCallNotification(String receiverId, String callType, String callId, String userName) async {
    var currentUserId = _auth.currentUser?.uid;

    if (currentUserId == null) {
      print("Error: Current user ID is null.");
      return;
    }

    var notificationData = {
      'title': userName!,
      'body': 'Incoming ${callType == 'audio' ? 'Audio' : 'Video'} Call',
      'senderId': currentUserId,
      'receiverId': receiverId, 
      'callType': callType,
      'callId': callId,
      'action': 'call', 
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    try {
      await _firestore
          .collection('notifications') 
          .add(notificationData);
    } catch (e) {
      print("Error sending notification: $e");
    }
  }


  void updateCallStatus(String senderId, String receiverId, String callId) async {
    var callData = AudioCallModel(
      id: callId,
      callerId: senderId,
      receiverId: receiverId,
      isCallEnded: true,
    );

    try {
      await _firestore
          .collection('callLogs')
          .doc(callId)
          .set(callData.toJson());
    } catch (e) {
      print("Error updating call status: $e");
    }
  }

  Future<void> endCall(String callId) async {
    try {
      await _firestore.collection('callLogs').doc(callId).update({
        'isCallEnded': false,
      });
    } catch (e) {
      print("Error ending call: $e");
    }
  }
}
