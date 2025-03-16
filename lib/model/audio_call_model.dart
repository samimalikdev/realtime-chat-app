
class AudioCallModel {
  String? id;
  String? callerId;
  String? callerName;
  String? callerPic;
  String? receiverId;
  String? receiverName;
  String? receiverPic;
  String? receiverEmail;
  String? callStatus;
  int? timestamp;
  String? callerEmail;
  bool? isCallEnded = false;

  AudioCallModel({this.id, this.callerId, this.callerName, this.callerPic, this.receiverId, this.receiverName, this.receiverPic, this.receiverEmail, this.callStatus, this.timestamp, this.callerEmail, this.isCallEnded = false});

  AudioCallModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["callerId"] is String) {
      callerId = json["callerId"];
    }
    if(json["callerName"] is String) {
      callerName = json["callerName"];
    }
    if(json["callerPic"] is String) {
      callerPic = json["callerPic"];
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
    if(json["receiverEmail"] is String) {
      receiverEmail = json["receiverEmail"];
    }
    if(json["callStatus"] is String) {
      callStatus = json["callStatus"];
    }
    if(json["timestamp"] is int) {
      timestamp = json["timestamp"];
    }
       if(json["callerEmail"] is String) {
      callerEmail = json["callerEmail"];
    }
    if(json["isCallEnded"] is bool) {
      isCallEnded = json["isCallEnded"];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["callerId"] = callerId;
    _data["callerName"] = callerName;
    _data["callerPic"] = callerPic;
    _data["receiverId"] = receiverId;
    _data["receiverName"] = receiverName;
    _data["receiverPic"] = receiverPic;
    _data["receiverEmail"] = receiverEmail;
    _data["callStatus"] = callStatus;
    _data["timestamp"] = timestamp;
        _data["callerEmail"] = callerEmail;
    _data["isCallEnded"] = isCallEnded;

    return _data;
  }
}