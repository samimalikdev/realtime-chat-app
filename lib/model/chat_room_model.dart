
class ChatRoomModel {
  String? senderId;
  String? roomId;
  String? senderName;
  String? senderProfileImage;
  String? receiverEmail;
  int? messageCount;
  String? lastMessage;
  String? receiverName;
  String? receiverProfileImage;
  String? senderEmail; 
  String? secretKey;    

  ChatRoomModel({this.senderId, this.roomId, this.senderName, this.senderProfileImage, this.receiverEmail, this.messageCount, this.lastMessage, this.receiverName, this.receiverProfileImage, this.senderEmail, this.secretKey});

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
    if(json["senderId"] is String) {
      senderId = json["senderId"];
    }
    if(json["roomId"] is String) {
      roomId = json["roomId"];
    }
    if(json["senderName"] is String) {
      senderName = json["senderName"];
    }
    if(json["senderProfileImage"] is String) {
      senderProfileImage = json["senderProfileImage"];
    }
    if(json["receiverEmail"] is String) {
      receiverEmail = json["receiverEmail"];
    }
    if(json["messageCount"] is int) {
      messageCount = json["messageCount"];
    }
    if(json["lastMessage"] is String) {
      lastMessage = json["lastMessage"];
    }
    if(json["receiverName"] is String) {
      receiverName = json["receiverName"];
    }
    if(json["receiverProfileImage"] is String) {
      receiverProfileImage = json["receiverProfileImage"];
    }
    if(json["senderEmail"] is String) {
      senderEmail = json["senderEmail"];
    }
    if(json["secretKey"] is String) {
      secretKey = json["secretKey"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["senderId"] = senderId;
    data["roomId"] = roomId;
    data["senderName"] = senderName;
    data["senderProfileImage"] = senderProfileImage;
    data["receiverEmail"] = receiverEmail;
    data["messageCount"] = messageCount;
    data["lastMessage"] = lastMessage;
    data["receiverName"] = receiverName;
    data["receiverProfileImage"] = receiverProfileImage;
    data["senderEmail"] = senderEmail;
    data["secretKey"] = secretKey;
    return data;
  }
}