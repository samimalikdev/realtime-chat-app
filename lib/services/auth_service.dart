import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:messenger_app/controller/login_controller.dart';
import 'package:messenger_app/routes/routes.dart';
import 'package:messenger_app/view/auth/login_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:messenger_app/view/auth/login_screen.dart';

class AuthService {
  Future<User?> signupWithEmail(String email, String password, String name) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print("User created");
      return userCredential.user;
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
    return null;
  }

  Future<User?> loginWithEmail(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      print("User logged in");
      return userCredential.user;
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
    return null;
  }

  Future<void> signOut() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  
  await auth.signOut();

  print("User signed out successfully"); 
}

}
