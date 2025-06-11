import 'package:flutter/material.dart';
import 'package:smodi/features/splash/splash_screen.dart';
import 'package:smodi/features/home/home_screen.dart'; // Pastikan ini diimpor
import 'package:smodi/features/authentication/screens/auth_main_screen.dart';
import 'package:smodi/features/onboarding/onboarding_screen.dart';
import 'package:smodi/core/constants/colors.dart';
import 'package:smodi/features/user_profile/screens/user_profile_screen.dart'; // Import UserProfileScreen

import 'features/f1_focus/screens/focus_session_screen.dart';
import 'features/f2_activity_insights/screens/activity_insight_screen.dart';
import 'features/f3_camera_control/screens/camera_control_screen.dart'; // Import colors for theme
import 'package:smodi/features/f4_settings/screens/settings_screen.dart'; // Import F4 main screen
import 'package:smodi/features/f4_settings/screens/profile_settings_screen.dart'; // Import sub-screen
import 'package:smodi/features/f4_settings/screens/iot_device_settings_screen.dart'; // Import sub-screen

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusForge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema global, bisa disesuaikan lebih lanjut
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat', // Pastikan font ini ada atau ganti dengan font default
        scaffoldBackgroundColor: Colors.black, // Background default untuk Scaffold
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // App Bar default gelap
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: AppColors.textFieldFillColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.primaryColor;
            }
            return Colors.white;
          }),
          checkColor: MaterialStateProperty.all(Colors.white),
        ),
        // Tambahkan tema untuk BottomNavigationBar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: AppColors.accentColor, // Kuning
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed, // Penting agar item tidak bergeser
          selectedLabelStyle: TextStyle(fontSize: 12),
          unselectedLabelStyle: TextStyle(fontSize: 12),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthMainScreen(),
        '/home': (context) => const HomeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/focus_session': (context) => const FocusSessionScreen(),
        '/activity_insights': (context) => const ActivityInsightsScreen(),
        '/camera_control': (context) => const CameraControlScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/settings/profile': (context) => const ProfileSettingsScreen(),
        '/settings/iot_devices': (context) => const IoTDeviceSettingsScreen(),
        '/user_profile': (context) => const UserProfileScreen(),
        // Anda bisa menambahkan rute lain di sini
      },
    );
  }
}
