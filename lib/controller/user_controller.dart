import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:messenger_app/model/user_model.dart';
import 'package:messenger_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();

  var user = Rx<UserModel?>(null);
    SharedPreferences? prefs;


  String? getUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  void onInit() async {
    super.onInit();
     prefs = await SharedPreferences.getInstance();
    loadUserDataFromSharedPreferences();
    fetchUserData();
  }

  Future<void> saveDataPreference() async {
  if (prefs != null && user.value != null) {
    List<String> userDataJson = [jsonEncode(user.value!.toJson())]; 
    await prefs!.setStringList('userData', userDataJson);
    print('User data saved to SharedPreferences');
  } else {
    print('User data not saved to SharedPreferences');
  }
}


  Future<void> loadUserDataFromSharedPreferences() async {
    if (prefs != null) {
      List<String>? userDataJson = prefs!.getStringList('userData');
      if (userDataJson != null && userDataJson.isNotEmpty) {
        String userData = userDataJson.first; 
        user.value = UserModel.fromJson(jsonDecode(userData)); 
        print("User loaded from SharedPreferences: ${user.value?.email}");
        print('Profile image: ${user.value?.profileImage.toString()}');
      }
    }
  }

  Future<void> fetchUserData() async {
    String? userId = getUserId();
    if (userId != null) {
      UserModel? userModel = await _databaseService.getUserById(userId);
      user(userModel);
      saveDataPreference();
    } else {
      user(null);
    }
  }

  Future<void> updateUserData(String name, String about, String? gender) async {
    String? userId = getUserId();
    if (userId != null) {
      await _databaseService.updateUserData(userId, name, about, gender);
      fetchUserData();
    } else {
      print('User not found');
    }
  }

  Future<void> getProfileImage(String profileUrl) async {
    final id = getUserId();
    if (id != null) {
      _databaseService.updateProfile(id, profileUrl);
    }
  }

  
}
