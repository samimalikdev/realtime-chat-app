import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messenger_app/controller/add_contacts_controller.dart';
import 'package:messenger_app/controller/homechat_controller.dart';
import 'package:messenger_app/controller/message_controller.dart';
import 'package:messenger_app/view/message/message_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddContactScreen extends StatelessWidget {
  final ContactsController contactsController = Get.put(ContactsController());
  final ChatController chatController = Get.put(ChatController());
  final HomeChatController homeChatController = Get.put(HomeChatController());

  AddContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // contactsController.fetchContacts(); // Fetch contacts on build
    // homeChatController.fetchChatRooms();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon:
                      Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                  onPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(width: 16.w),
                Text(
                  'Add Contact',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Bernhardt',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.sp),
                  topRight: Radius.circular(30.sp),
                ),
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  TextFormField(
                    controller: contactsController.searchController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                    ),
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () async {
                      String email =
                          contactsController.searchController.text.trim();
                      if (email.isEmpty ||
                          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                        Get.snackbar(
                          'Error',
                          'Please enter a valid email address.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.all(16.w),
                          borderRadius: 12.sp,
                        );
                        return;
                      }

                      showAddContactConfirmationDialog(email);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 14.h, horizontal: 24.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Add to Contacts',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Bernhardt',
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: Obx(() {
                      if (contactsController.isLoading.value) {
                        return Center(
                            child:
                                CircularProgressIndicator()); 
                      }

                      return ListView.builder(
                        itemCount: contactsController.filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact =
                              contactsController.filteredContacts[index];

                          return Slidable(
                            key: ValueKey(contact.id),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    print("receivrId is: ${contact.id}");
                                    contactsController.deleteContacts(contact.id!);
                                    
                                    Get.snackbar(
                                      'Deleted',
                                      'Contact ${contact.name ?? 'Unknown'} has been deleted.',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.sp),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 8.h),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(12.w),
                                leading: CircleAvatar(
                                  backgroundImage: contact.profileImage == null
                                      ? const AssetImage(
                                          "assets/images/pr2.png")
                                      : NetworkImage(contact.profileImage!),
                                ),
                                title: Text(
                                  contact.name ?? '',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Bernhardt',
                                  ),
                                ),
                                subtitle: Text(
                                  contact.about ?? '',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                    fontFamily: 'Bernhardt',
                                  ),
                                ),
                                onTap: () {
                                  // print("Contact ID: ${contact.toJson()}");

                                  Get.to(MessageScreen(
                                    contactsModel: contact,
                                    userProfileImage: contact.profileImage ??
                                        'assets/images/pr2.png',
                                    receiverId: contact.id!,
                                    receiverName: contact.name!,
                                  ));
                                  //  chatController.getIds();
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showAddContactConfirmationDialog(String email) {
    Get.defaultDialog(
      title: "Add Contact",
      titleStyle: const TextStyle(
        fontFamily: 'Bernhardt',
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      content: Column(
        children: [
          const Text(
            "Do you want to add the contact with email:",
            style: TextStyle(
              fontFamily: 'Bernhardt',
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            email,
            style: const TextStyle(
              fontFamily: 'Bernhardt',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          contactsController.onSearch(); 

          Get.back(); 
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        child: Text(
          "Yes",
          style: TextStyle(fontFamily: 'Bernhardt'),
        ),
      ),
      cancel: TextButton(
        onPressed: () {
          Get.back(); 
        },
        child: const Text(
          "No",
          style: TextStyle(fontFamily: 'Bernhardt', color: Colors.black),
        ),
      ),
    );
  }
}
