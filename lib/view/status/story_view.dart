import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:story_view/story_view.dart';

class StoryViewScreen extends StatelessWidget {
  final List<StoryItem> storyItems;
   StoryViewScreen({super.key, required this.storyItems});

  @override
  Widget build(BuildContext context) {
    final StoryController storyController = StoryController();


    return Scaffold(
      appBar: AppBar(
        title: Text("Status", style: TextStyle(color: Colors.black, fontFamily: "Bernhardt", fontSize: 16.sp),),
      ),
      body: StoryView(
        storyItems: storyItems,
        onComplete: () {
          Get.back();
        },
        repeat: false, 
        controller: storyController, 
      ),
    );
  }
}
