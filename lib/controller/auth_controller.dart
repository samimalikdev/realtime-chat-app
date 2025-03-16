import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:messenger_app/controller/add_contacts_controller.dart';
import 'package:messenger_app/controller/homechat_controller.dart';
import 'package:messenger_app/model/user_model.dart';
import 'package:messenger_app/routes/routes.dart';
import 'package:messenger_app/services/auth_service.dart';
import 'package:messenger_app/services/database_service.dart';
import 'package:messenger_app/view/auth/login_screen.dart';
import 'package:messenger_app/view/contacts/add_contacts_screen.dart';
import 'package:messenger_app/view/navigation/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthService authService = AuthService();
  final DatabaseService databaseService = DatabaseService();
  final ContactsController contactsController = Get.put(ContactsController());
  final HomeChatController homeChatController = Get.put(HomeChatController());
  
  var uuid = const Uuid();

  Future<void> register() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  final name = nameController.text.trim();

  if (email.isEmpty || password.isEmpty || name.isEmpty) {
    Get.snackbar(
      'Error Registering',
      'Please enter all the fields',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
    return;
  }

  try {
    User? user = await authService.signupWithEmail(email, password, name);
    if (user != null) {
      UserModel userModel = UserModel(
        id: user.uid,
        name: name,
        email: email,
        password: password,
        about: 'Hey there, I am using Messenger App',
        secretKey: uuid.v4(),
      );

      print("Saving user data: ${userModel.toJson()}"); // Debugging line
      await databaseService.saveData(userModel);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", user.uid);

      Get.snackbar(
        'Success',
        'You have successfully registered',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );

      emailController.clear();
      passwordController.clear();
      nameController.clear();
      Get.toNamed(Routes.login);
    } else {
      Get.snackbar(
        'Error Registering',
        'An error occurred while registering',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  } on FirebaseAuthException catch (e) {
    Get.snackbar(
      'Error Registering',
      e.message ?? 'An unexpected error occurred',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  } catch (e) {
    print(e);
    Get.snackbar(
      'Error',
      'An unexpected error occurred',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}


  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error Login',
        'Please enter all the fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    try {
      User? user = await authService.loginWithEmail(email, password);
      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userId", user.uid);

        Get.snackbar(
          'Success',
          'You have successfully logged in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
        emailController.clear();
        passwordController.clear();
        Get.offAll(() => MainScreen());
      } else {
        Get.snackbar(
          'Error Login',
          'An error occurred while logging in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void logout() async {
    await authService.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.deleteAll();
    print( "Contacts cleared {${contactsController.filteredContacts.length}}");
    Get.offAll(() => LoginScreen());
    Get.snackbar(
      'Logout',
      'You have successfully logged out',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
