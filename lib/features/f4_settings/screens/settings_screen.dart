import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';
import 'package:smodi/features/f4_settings/widgets/settings_list_tile.dart';
import 'package:smodi/features/f4_settings/screens/profile_settings_screen.dart'; // Import sub-layar
import 'package:smodi/features/f4_settings/screens/iot_device_settings_screen.dart'; // Import sub-layar
import 'package:smodi/features/common_widgets/coming_soon_screen.dart'; // General placeholder

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showSnackbar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.errorColor : AppColors.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headingText,
      appBar: AppBar(
        backgroundColor: AppColors.headingText,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Settings & Personalization (F4)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Account Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            SettingsListTile(
              title: 'Edit Profile',
              icon: Icons.person_outline,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileSettingsScreen()));
              },
            ),
            SettingsListTile(
              title: 'Change Password',
              icon: Icons.lock_outline,
              onTap: () {
                _showSnackbar(context, 'Change Password screen (Coming Soon)');
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'Change Password')));
              },
            ),
            SettingsListTile(
              title: 'Delete Account',
              icon: Icons.delete_outline,
              onTap: () {
                _showSnackbar(context, 'Delete Account confirmation (Coming Soon)', isError: true);
                // Biasanya menampilkan dialog konfirmasi
              },
              iconColor: AppColors.errorColor, // Warna ikon merah untuk delete
              textColor: AppColors.errorColor, // Warna teks merah untuk delete
            ),
            const Divider(color: Colors.white24, indent: 16, endIndent: 16),
            const SizedBox(height: 10),

            // Section: General Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'General Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            SettingsListTile(
              title: 'Notifications',
              icon: Icons.notifications_none,
              trailing: Switch(
                value: true, // Dummy value
                onChanged: (bool value) {
                  _showSnackbar(context, 'Notifications ${value ? "On" : "Off"} (Dummy)');
                },
                activeColor: AppColors.primaryColor,
              ),
            ),
            SettingsListTile(
              title: 'App Theme',
              icon: Icons.color_lens_outlined,
              onTap: () {
                _showSnackbar(context, 'Theme selection (Coming Soon)');
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'App Theme')));
              },
            ),
            SettingsListTile(
              title: 'Language',
              icon: Icons.language_outlined,
              onTap: () {
                _showSnackbar(context, 'Language selection (Coming Soon)');
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'Language Settings')));
              },
            ),
            const Divider(color: Colors.white24, indent: 16, endIndent: 16),
            const SizedBox(height: 10),

            // Section: IoT Device Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'IoT Device Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            SettingsListTile(
              title: 'Manage Devices',
              icon: Icons.devices_other_outlined,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const IoTDeviceSettingsScreen()));
              },
            ),
            SettingsListTile(
              title: 'Device Calibration',
              icon: Icons.precision_manufacturing_outlined,
              onTap: () {
                _showSnackbar(context, 'Device Calibration (Coming Soon)');
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'Device Calibration')));
              },
            ),
            const Divider(color: Colors.white24, indent: 16, endIndent: 16),
            const SizedBox(height: 10),

            // Section: Privacy & Security
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Privacy & Security',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            SettingsListTile(
              title: 'Privacy Policy',
              icon: Icons.privacy_tip_outlined,
              onTap: () {
                _showSnackbar(context, 'Opening Privacy Policy...');
                // Implementasi untuk membuka URL atau layar kebijakan privasi
              },
            ),
            SettingsListTile(
              title: 'Biometric Authentication',
              icon: Icons.fingerprint,
              trailing: Switch(
                value: false, // Dummy value
                onChanged: (bool value) {
                  _showSnackbar(context, 'Biometric Auth ${value ? "Enabled" : "Disabled"} (Dummy)');
                },
                activeColor: AppColors.primaryColor,
              ),
            ),
            const Divider(color: Colors.white24, indent: 16, endIndent: 16),
            const SizedBox(height: 10),

            // Section: About
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            SettingsListTile(
              title: 'App Version',
              icon: Icons.info_outline,
              trailing: const Text('1.0.0', style: TextStyle(color: Colors.white70)),
              onTap: () {
                _showSnackbar(context, 'You are using version 1.0.0');
              },
            ),
            SettingsListTile(
              title: 'Help & Support',
              icon: Icons.help_outline,
              onTap: () {
                _showSnackbar(context, 'Opening Help & Support (Coming Soon)');
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'Help & Support')));
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}