import 'package:cloud_firestore/cloud_firestore.dart';


class MessageModel {
  String? senderId;
  String? receiverId;
  String? messageContent;
 Timestamp? timestamp;
  bool? isRead;
  bool? isSent;
  String? lastMessage;
  int? messageCount;
  String? profileImage;
  String? senderImage;
  bool? isOnline;
  String? audioUrl;
  String? videoUrl;
  String? imageUrl;
  String? documentUrl;
  String? linkPreview;
  String? senderName;
  String? receiverName;
  String? messageType;
  String? messageId;

  MessageModel({this.senderId, this.receiverId, this.messageContent, this.timestamp, this.isRead, this.isSent, this.lastMessage, this.messageCount, this.profileImage,
   this.isOnline, this.audioUrl, this.videoUrl, this.imageUrl, this.documentUrl, this.linkPreview, 
   this.senderName, this.messageType, this.messageId, this.senderImage, this.receiverName, String? receiverEmail});

  MessageModel.fromJson(Map<String, dynamic> json) {
    if(json["senderId"] is String) {
      senderId = json["senderId"];
    }
    if(json["receiverId"] is String) {
      receiverId = json["receiverId"];
    }
    if(json["messageContent"] is String) {
      messageContent = json["messageContent"];
    }
    if(json["timestamp"] is Timestamp) {
      timestamp = json["timestamp"];
    }
    if(json["isRead"] is bool) {
      isRead = json["isRead"];
    }
    if(json["isSent"] is bool) {
      isSent = json["isSent"];
    }
    if(json["lastMessage"] is String) {
      lastMessage = json["lastMessage"];
    }
    if(json["messageCount"] is int) {
      messageCount = json["messageCount"];
    }
    if(json["profileImage"] is String) {
      profileImage = json["profileImage"];
    }
    if(json["isOnline"] is bool) {
      isOnline = json["isOnline"];
    }
    if(json["audioUrl"] is String) {
      audioUrl = json["audioUrl"];
    }
    if(json["videoUrl"] is String) {
      videoUrl = json["videoUrl"];
    }
    if(json["imageUrl"] is String) {
      imageUrl = json["imageUrl"];
    }
    if(json["documentUrl"] is String) {
      documentUrl = json["documentUrl"];
    }
    if(json["linkPreview"] is String) {
      linkPreview = json["linkPreview"];
    }
    if(json["senderName"] is String) {
      senderName = json["senderName"];
    }
    if(json["messageType"] is String) {
      messageType = json["messageType"];
    }
    if(json["messageId"] is String) {
      messageId = json["messageId"];
    }
    if(json["senderImage"] is String) {
      senderImage = json["senderImage"];
    }
    if(json["receiverName"] is String) {
      receiverName = json["receiverName"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["senderId"] = senderId;
    data["receiverId"] = receiverId;
    data["messageContent"] = messageContent;
    data["timestamp"] = timestamp;
    data["isRead"] = isRead;
    data["isSent"] = isSent;
    data["lastMessage"] = lastMessage;
    data["messageCount"] = messageCount;
    data["profileImage"] = profileImage;
    data["isOnline"] = isOnline;
    data["audioUrl"] = audioUrl;
    data["videoUrl"] = videoUrl;
    data["imageUrl"] = imageUrl;
    data["documentUrl"] = documentUrl;
    data["linkPreview"] = linkPreview;
    data["senderName"] = senderName;
    data["messageType"] = messageType;
    data["messageId"] = messageId;
    data["senderImage"] = senderImage;
    data["receiverName"] = receiverName;
    return data;
  }
}