import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCallScreen extends StatelessWidget {
  AddCallScreen({super.key});

  final List<Map<String, String>> contacts = [
    {'name': 'Sami Malik', 'status': 'Online', 'image': 'assets/images/pr.png'},
    {'name': 'Hamza Malik', 'status': 'Offline', 'image': 'assets/images/pr1.png'},
    {'name': 'Zain Malik', 'status': 'Busy', 'image': 'assets/images/pr2.png'},
    {'name': 'Bd Gulamabadia', 'status': 'Offline', 'image': 'assets/images/pr3.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back(); 
          },
        ),
        title: Text(
          'Add Call',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.sp),
                  topRight: Radius.circular(30.sp),
                ),
              ),
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(contact['image']!),
                      radius: 24.sp,
                    ),
                    title: Text(
                      contact['name']!,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      contact['status']!,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.call, color: Colors.green),
                          onPressed: () {
                            print('Calling ${contact['name']}');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.videocam, color: Colors.blue),
                          onPressed: () {
                            print('Video calling ${contact['name']}');
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
