import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home_page.dart';
import 'package:mobile_app/screens/home_screen.dart';
import 'package:mobile_app/screens/register_screen.dart';
import 'package:mobile_app/screens/login_screen.dart';
import 'package:mobile_app/screens/profile_screen.dart';
import 'package:mobile_app/screens/setting_screen.dart';
import 'package:mobile_app/screens/forgot_password_screen.dart';
import 'package:mobile_app/screens/change_password.dart';
import 'package:mobile_app/screens/change_email.dart';

class Routes {
  static const String home = '/home';
  static const String register = '/register';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String setting = '/settings';
  static const String forgot = '/forgot';
  static const String passwordChange = '/passwordChange';
  static const String emailChange = '/emailChange';

  // Centralized route generation
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case setting:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case passwordChange:
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen());
      case emailChange:
        return MaterialPageRoute(builder: (_) => ChangeEmailScreen());
      default:
        return null;
    }
  }
}
