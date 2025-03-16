import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/controller/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditScreenController extends GetxController {
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final aboutController = TextEditingController();
  final _userController = Get.find<UserController>();

  final ImagePicker _picker = ImagePicker();
  final profileImage = Rx<File?>(null);
  final isLoading = false.obs; 

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        profileImage.value = File(image.path);
        saveImagePathToPrefs(image.path);
        print('Image picked: ${image.path}');
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick an image.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> saveImagePathToPrefs(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('localProfileImagePath', path);
    print("Image path saved to SharedPreferences: $path");
  }

  Future<String?> getImagePathFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('localProfileImagePath');
  }

  Future<String?> uploadImage(String userId) async {
    if (profileImage.value == null) {
      return null;
    }

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('$userId.jpg');


      await ref.putFile(profileImage.value!);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

Future<void> saveProfileAndUploadImage() async {
  final id = _userController.getUserId();
  if (id != null) {
    isLoading.value = true;
    try {
      final imageUrl = await uploadImage(id);
      print("image url: $imageUrl");

      if (imageUrl != null) {
        _userController.getProfileImage(imageUrl);
        print("Profile saved with image URL: $imageUrl");
      } else {
        print("No image URL returned from uploadImage.");
      }
    } catch (e) {
      print("Error saving profile and uploading image: $e");
    } finally {
        isLoading.value = false; // Set loading to false
      } 
  } else {
    print("User ID is null.");
    isLoading.value = false;
  }
}
Future<void> saveProfile() async {
  final name = nameController.text.trim();
  final gender = genderController.text.trim();
  final about = aboutController.text.trim();

  if (name.isEmpty || gender.isEmpty || about.isEmpty) {
    Get.snackbar(
      'Required',
      'All fields are required.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
    return;
  }

  await saveProfileAndUploadImage();

  final currentUser = _userController.user.value;

  if (currentUser != null) {
    bool nameChanged = currentUser.name != name;
    bool genderChanged = currentUser.gender != gender;
    bool aboutChanged = currentUser.about != about;

    bool imageChanged = profileImage.value != null && currentUser.profileImage != profileImage.value!.path;

    if (!nameChanged && !genderChanged && !aboutChanged && !imageChanged) {
      Get.snackbar(
        'No Update',
        'No changes detected in your profile.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
  }

  _userController.updateUserData(name, about, gender).then((_) {
    Get.snackbar(
      'Profile Updated',
      'Your profile has been updated successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }).catchError((_) {
    Get.snackbar(
      'Error',
      'Failed to update profile.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  });
}


  
}