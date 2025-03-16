import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:messenger_app/controller/main_controller.dart';
import 'package:messenger_app/view/calls/calls_screen.dart';
import 'package:messenger_app/view/chat/chat_screen.dart';
import 'package:messenger_app/view/settings/settings_screen.dart';
import 'package:messenger_app/view/status/status_screen.dart';

class MainScreen extends StatelessWidget {
  final MainController mainController = Get.put(MainController());

  final List<Widget> screens = [
    ChatScreen(),
    StatusScreen(),
    RecentCallsScreen(),
    SettingsScreen(),
  ];

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: Obx(() => screens[mainController.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => SizedBox(
          height: 80.h,
          width: double.infinity,
          child: BottomNavigationBar(
            selectedItemColor: const Color(0xff24786D),
            currentIndex: mainController.currentIndex.value,
            onTap: (index) {
              mainController.changeIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/svgs/message.svg', height: 26.h, width: 26.w),
                label: 'Chats',
                tooltip: 'Chats', 
              
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/svgs/contacts.svg', height: 26.h, width: 26.w),
                label: 'Status',
                tooltip: 'Status',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/svgs/call.svg', height: 26.h, width: 26.w),
                label: 'Calls',
                tooltip: 'Calls',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/svgs/settings.svg', height: 26.h, width: 26.w),
                label: 'Settings',
                tooltip: 'Settings',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(
              fontFamily: 'Bernhardt', 
              fontWeight: FontWeight.w400,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Bernhardt', 
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
