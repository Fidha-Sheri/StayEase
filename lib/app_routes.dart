import 'package:flutter/material.dart';

// Common Screens
import 'splash_screen.dart';
import 'login_page.dart';
import 'register_page.dart';

// Role-based Dashboards
import 'student_home.dart';
import 'warden_home.dart';
import 'admin_home.dart';

// Warden Screens
import 'wardenscreens/profile_page.dart';

// Admin Screens
import 'adminscreens/student_management_page.dart';
import 'adminscreens/warden_management_page.dart';
import 'adminscreens/fee_management_page.dart';

class AppRoutes {
  // Common
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Homes
  static const String homeStudent = '/home/student';
  static const String homeWarden = '/home/warden';
  static const String homeAdmin = '/home/admin';

  // Warden
  static const String wardenProfile = '/warden/profile';

  // Admin
  static const String studentManagement = '/admin/student-management';
  static const String wardenManagement = '/admin/warden-management';
  static const String feeManagement = '/admin/fee-management';

  static Map<String, WidgetBuilder> routes = {
    // Common
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),

    // Homes
    homeStudent: (context) => const StudentHome(),
    homeWarden: (context) => const WardenHome(),
    homeAdmin: (context) => const AdminHome(),

    // Warden
    wardenProfile: (context) => const ProfilePage(),

    // Admin
    studentManagement: (context) => const StudentManagementPage(),
    wardenManagement: (context) => const WardenManagementPage(),
    feeManagement: (context) => const FeeManagementPage(),
  };
}
