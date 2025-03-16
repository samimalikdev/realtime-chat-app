import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart';  // Import Firebase core
import 'package:messenger_app/controller/call_controller.dart';
import 'package:messenger_app/controller/user_controller.dart';
import 'package:messenger_app/routes/routes.dart';
import 'package:messenger_app/view/auth/login_screen.dart';
import 'package:messenger_app/view/navigation/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';  


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "",
      authDomain: "",
      projectId: "",
      storageBucket: "",
      messagingSenderId: "",
      appId: "",
      measurementId: "",  
    ),

  );

   FirebaseAppCheck instance = FirebaseAppCheck.instance;
 await instance.activate(
  androidProvider: AndroidProvider.debug,
);

  await ScreenUtil.ensureScreenSize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserController _userController = Get.put(UserController());
  
   MyApp({super.key});

  

  @override
  Widget build(BuildContext context) {
       CallController _callController = Get.put(CallController());
        _userController.fetchUserData();
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: Root(), 
        );
      },
    );
  }
}
class Root extends StatelessWidget {
  const Root({super.key});

  Future<bool> _checkUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("User ID: ${prefs.getString('userId')}");
    return prefs.containsKey('userId');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkUserSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("An error occurred: ${snapshot.error}"));
        }

        if (snapshot.data == true) {
          return MainScreen();
        }

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (authSnapshot.hasError) {
              return Center(
                  child: Text("An error occurred: ${authSnapshot.error}"));
            }

            return authSnapshot.data != null ? MainScreen() : LoginScreen();
          },
        );
      },
    );
  }
}

