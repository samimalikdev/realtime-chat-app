import 'package:get/get.dart';
import 'package:messenger_app/view/auth/login_screen.dart';
import 'package:messenger_app/view/auth/register_screen.dart';
import 'package:messenger_app/view/profile/profile_screen.dart';

import '../view/navigation/main_screen.dart';

class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String profile = '/profile';
}

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: Routes.main,
      page: () => MainScreen(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => MyProfileScreen(),
    ),
    // Add more routes here
  ];
}
