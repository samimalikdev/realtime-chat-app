
class UserModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? about;
  String? profileImage;
  String? gender;
  String? secretKey;

  UserModel({this.id, this.name, this.email, this.password, this.about, this.profileImage, this.gender, this.secretKey});

  UserModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    if(json["password"] is String) {
      password = json["password"];
    }
    if(json["about"] is String) {
      about = json["about"];
    }
    if(json["profileImage"] is String) {
      profileImage = json["profileImage"];
    }
    if(json["gender"] is String) {
      gender = json["gender"];
    }
    if(json["secretKey"] is String) {
      secretKey = json["secretKey"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["email"] = email;
    data["password"] = password;
    data["about"] = about;
    data["profileImage"] = profileImage;
    data["gender"] = gender;
    data["secretKey"] = secretKey;
    return data;
  }
}