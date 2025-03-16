import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messenger_app/view/calls/add_call_screen.dart';

class RecentCallsScreen extends StatelessWidget {
  RecentCallsScreen({super.key});

  final List<Map<String, String>> recentCalls = [
    {'name': 'Sami Malik', 'time': '10:30 AM', 'date': 'Today', 'type': 'call', 'duration': '2 min', 'status': 'Missed', 'image': 'assets/images/pr.png'},
    {'name': 'Hamza Malik', 'time': 'Yesterday', 'date': 'Yesterday', 'type': 'video', 'duration': '5 min', 'status': 'Completed', 'image': 'assets/images/pr1.png'},
    {'name': 'Zain Malik', 'time': '08:45 AM', 'date': '2 days ago', 'type': 'call', 'duration': '1 min', 'status': 'Missed', 'image': 'assets/images/pr2.png'},
    {'name': 'Bd Gulamabadia', 'time': '08:45 AM', 'date': '2 days ago', 'type': 'call', 'duration': '1 min', 'status': 'Missed', 'image': 'assets/images/pr3.png'},
    {'name': 'Sami Malik', 'time': '10:30 AM', 'date': 'Today', 'type': 'call', 'duration': '2 min', 'status': 'Missed', 'image': 'assets/images/pr.png'},
    {'name': 'Hamza Malik', 'time': 'Yesterday', 'date': 'Yesterday', 'type': 'video', 'duration': '5 min', 'status': 'Completed', 'image': 'assets/images/pr1.png'},
    {'name': 'Zain Malik', 'time': '08:45 AM', 'date': '2 days ago', 'type': 'call', 'duration': '1 min', 'status': 'Missed', 'image': 'assets/images/pr2.png'},
    {'name': 'Bd Gulamabadia', 'time': '08:45 AM', 'date': '2 days ago', 'type': 'call', 'duration': '1 min', 'status': 'Missed', 'image': 'assets/images/pr3.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 30.h),
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Get.to(() => AddCallScreen());
                  },
                  icon: Icon(Icons.add, color: Colors.white, size: 24.sp),
                ),
                Text(
                  'Recent Calls',
                  style: TextStyle(
                    fontFamily: 'Bernhardt',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.white, size: 24.sp),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Settings',
                            style: TextStyle(
                              fontFamily: 'Bernhardt',  
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Manage Recent Call Settings:',
                                style: TextStyle(
                                  fontFamily: 'Bernhardt',  
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Option 1'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Option 2'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Option 3'),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
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
                itemCount: recentCalls.length,
                itemBuilder: (context, index) {
                  final call = recentCalls[index];
                  Color callColor;
                  if (call['date'] == 'Today') {
                    callColor = Colors.green;
                  } else if (call['date'] == 'Yesterday') {
                    callColor = Colors.red;
                  } else {
                    callColor = Colors.grey;
                  }
                  return ListTile(
                    contentPadding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(call['image']!), 
                      radius: 24.sp,
                    ),
                    title: Text(
                      call['name']!,
                      style: TextStyle(
                        fontFamily: 'Bernhardt',  
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              call['type'] == 'video' ? Icons.videocam : Icons.call,
                              color: callColor,
                              size: 14.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '${call['time']} - ${call['date']}',
                              style: TextStyle(
                                fontFamily: 'Bernhardt',  
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${call['duration']} - ${call['status']}',
                          style: TextStyle(
                            fontFamily: 'Bernhardt', 
                            fontSize: 12.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.call, color: callColor),
                      onPressed: () {
                      },
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
