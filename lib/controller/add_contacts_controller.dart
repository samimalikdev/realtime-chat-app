import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/model/chat_room_model.dart';
import 'package:messenger_app/model/contacts_mode.dart';
import 'package:messenger_app/model/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ContactsController extends GetxController {
  var filteredContacts = <ContactsModel>[].obs; // Observable list of contacts
  final TextEditingController searchController = TextEditingController();

  String? userId = FirebaseAuth.instance.currentUser?.uid;
  var isLoading = false.obs;  
  SharedPreferences? prefs;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchContacts();
    prefs = await SharedPreferences.getInstance();  
    loadFilteredContacts();
    ever(filteredContacts, (_) => fetchContacts());
  }

  Future<void> saveFilteredContacts() async {
    if (prefs != null) {
      List<String> contactsJson = filteredContacts.map((contact) => jsonEncode(contact.toJson())).toList();
      await prefs!.setStringList('filteredContacts', contactsJson);
      print('Filtered contacts saved');
    }
  }

  
  Future<void> fetchContacts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    isLoading.value = true;

    try {
      var result = await firestore
          .collection("contacts")
          .doc(userId)
          .collection("searchedContacts")
          .get();

      if (result.docs.isNotEmpty) {
        for (var doc in result.docs) {
          var contactData = doc.data();

          if (contactData['receiver'] != null) {
            var receiverData = contactData['receiver'];
            var receiverModel = ContactsModel.fromJson(receiverData);

            bool exists = filteredContacts
                .any((contact) => contact.email == receiverModel.email);
            if (!exists) {
              filteredContacts
                  .add(receiverModel); 
                  await saveFilteredContacts();
              }
          }
        }

        print("Total : ${filteredContacts.length}");
      } else {
        print('Not found.');
      }
    } catch (e) {
      print('Error fetching: $e');
    } finally {
    isLoading.value = false; 
  }
  }

  Future<void> onSearch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
 isLoading.value = true;  
    try {
      String searchText = searchController.text.trim();
      print('Searching for email: $searchText');

      if (searchText.isNotEmpty) {
        var receiverModel = await _searchForContact(searchText);

        if (receiverModel != null) {
          var senderModel = await _getSenderDetails();

          if (!await _isDuplicateContact(senderModel, receiverModel)) {
            await _addContact(senderModel, receiverModel);
          } else {
            _showErrorSnackbar('Contact already exists.');
          }
        } else {
          _showErrorSnackbar('No contacts found');
        }
      } else {
        _showErrorSnackbar('Please enter an email');
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
      print('Error during search: $e');
    } finally {
    isLoading.value = false;  
  }
  }


  Future<ContactsModel?> _searchForContact(String email) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var result = await firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();

    if (result.docs.isNotEmpty) {
      var contactData = result.docs.first.data();
      var contactModel = ContactsModel.fromJson(contactData);
      print('Found contact email: ${contactModel.email}');
      return contactModel;
    } else {
      print('No contacts found for email: $email');
      return null;
    }
  }

  Future<ContactsModel> _getSenderDetails() async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    var senderSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserId)
        .get();
    var senderData = senderSnapshot.data() ?? {};
    var senderModel = ContactsModel.fromJson(senderData);
    print('Fetched sender details: ${senderModel.email}');

    return senderModel;
  }

  Future<bool> _isDuplicateContact(
      ContactsModel senderModel, ContactsModel receiverModel) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;

    var existingContactQuery = await FirebaseFirestore.instance
        .collection('contacts')
        .doc(currentUserId)
        .collection("searchedContacts")
        .where('receiver.email',
            isEqualTo: receiverModel.email) 
        .get();

    return existingContactQuery
        .docs.isNotEmpty; 
  }

  Future<void> deleteContacts (String contactId) async{
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final result = await firestore.collection("contacts").doc(userId).collection("searchedContacts").where("receiver.id", isEqualTo: contactId).get();

      print("lenght is : ${result.docs.length}");

      for (var doc in result.docs){
        await doc.reference.delete();
     
      }
        SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();

          filteredContacts.removeWhere((e)=> e.id == contactId);

    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  Future<void> _addContact(ContactsModel senderModel, ContactsModel receiverModel) async {
  var currentUserId = FirebaseAuth.instance.currentUser!.uid;
  var contactData = {
    'sender': senderModel.toJson(),
    'receiver': receiverModel.toJson(),
  };

  await FirebaseFirestore.instance
      .collection('contacts')
      .doc(currentUserId)
      .collection("searchedContacts")
      .add(contactData);

  print('Contact added: Sender and receiver details saved.');

  _showSuccessSnackbar('Contact added successfully');

  await fetchContacts();
}  

void loadFilteredContacts() async {
  if (prefs != null){
    List<String>? contactJson = prefs!.getStringList('filteredContacts');
    if (contactJson != null){
      filteredContacts.value = contactJson.map((contact)=> ContactsModel.fromJson(jsonDecode(contact))).toList();
      print('Filtered contacts loaded {${filteredContacts.length}}');
    }
  }
}


  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'No timestamp';
    }
    DateTime dateTime = timestamp.toDate();

    DateTime localDateTime = dateTime.toLocal();

    return DateFormat('h:mm a').format(localDateTime);
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.sp,
      titleText: Text(
        'Error',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: Colors.white),
        ),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(fontSize: 14.sp, color: Colors.white),
        ),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.sp,
      titleText: Text(
        'Success',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: Colors.white),
        ),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(fontSize: 14.sp, color: Colors.white),
        ),
      ),
    );
  }
}
