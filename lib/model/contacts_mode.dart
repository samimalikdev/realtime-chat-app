import 'package:messenger_app/model/user_model.dart';

class ContactsModel {
  String? id;
  String? name;
  String? profileImage;
  String? about;
  String? email;
  String? secretKey;
  ContactsModel? sender;
  ContactsModel? receiver;
  String? lastMessage; 
  int? messageCount;

  ContactsModel({
    this.id,
    this.name,
    this.profileImage,
    this.about,
    this.email,
    this.secretKey,
    this.sender,
    this.receiver,
    this.lastMessage,
    this.messageCount
  });

  ContactsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] as String?;
    name = json["name"] as String?;
    profileImage = json["profileImage"] as String?;
    about = json["about"] as String?;
    email = json["email"] as String?;
    secretKey = json["secretKey"] as String?;

    if (json["senderDetails"] is Map) {
      sender = ContactsModel.fromJson(json["senderDetails"]);
    }
    if (json["receiverDetails"] is Map) {
      receiver = ContactsModel.fromJson(json["receiverDetails"]);
    }

    lastMessage = json["lastMessage"] as String?;
    messageCount = json["messageCount"] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["profileImage"] = profileImage;
    data["about"] = about;
    data["email"] = email;
    data["secretKey"] = secretKey;
    if (sender != null) {
      data["senderDetails"] = sender!.toJson();
    }
    if (receiver != null) {
      data["receiverDetails"] = receiver!.toJson();
    }

    data["lastMessage"] = lastMessage;
    data["messageCount"] = messageCount;
    return data;
  }
}
