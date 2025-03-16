
import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  String? imageUrl;
  bool? isVideo;
  String? userId;
  String? statusProfilePic;
  String? statusName;
  Timestamp? timestamp;
  String? receiverId;
  String? receiverName;
  String? receiverPic;
  List<String>? picture;
  List<String>? name;
  List<String>? visibleTo;

  StatusModel({this.imageUrl, this.isVideo, this.userId, this.statusProfilePic, this.statusName, this.timestamp, this.receiverId, this.receiverName, this.receiverPic, this.picture, this.name, this.visibleTo});

  StatusModel.fromJson(Map<String, dynamic> json) {
    if(json["imageUrl"] is String) {
      imageUrl = json["imageUrl"];
    }
    if(json["isVideo"] is bool) {
      isVideo = json["isVideo"];
    }
    if(json["userId"] is String) {
      userId = json["userId"];
    }
    if(json["statusProfilePic"] is String) {
      statusProfilePic = json["statusProfilePic"];
    }
    if(json["statusName"] is String) {
      statusName = json["statusName"];
    }
    if(json["timestamp"] is Timestamp) {
      timestamp = json["timestamp"];
    }
    if(json["receiverId"] is String) {
      receiverId = json["receiverId"];
    }
    if(json["receiverName"] is String) {
      receiverName = json["receiverName"];
    }
    if(json["receiverPic"] is String) {
      receiverPic = json["receiverPic"];
    }
    if(json["picture"] is List) {
      picture = json["picture"] == null ? null : List<String>.from(json["picture"]);
    }
    if(json["name"] is List) {
      name = json["name"] == null ? null : List<String>.from(json["name"]);
    }
    if(json["visibleTo"] is List) {
      visibleTo = json["visibleTo"] == null ? null : List<String>.from(json["visibleTo"]);
    }
  }

  static List<StatusModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(StatusModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["imageUrl"] = imageUrl;
    _data["isVideo"] = isVideo;
    _data["userId"] = userId;
    _data["statusProfilePic"] = statusProfilePic;
    _data["statusName"] = statusName;
    _data["timestamp"] = timestamp;
    _data["receiverId"] = receiverId;
    _data["receiverName"] = receiverName;
    _data["receiverPic"] = receiverPic;
    if(picture != null) {
      _data["picture"] = picture;
    }
    if(name != null) {
      _data["name"] = name;
    }
    if(visibleTo != null) {
      _data["visibleTo"] = visibleTo;
    }
    return _data;
  }
}