import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';
import 'package:smodi/features/f4_settings/screens/profile_settings_screen.dart'; // Import layar edit profil

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy user data
    final String userName = 'John Doe';
    final String userEmail = 'john.doe@example.com';
    final String userBio = 'Productivity enthusiast and software developer. Striving for focus and efficiency.';
    final int totalFocusSessions = 125;
    final String totalFocusTime = '250h 30m';

    return Scaffold(
      backgroundColor: AppColors.headingText,
      appBar: AppBar(
        backgroundColor: AppColors.headingText,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileSettingsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar Pengguna
            CircleAvatar(
              radius: 70,
              backgroundColor: AppColors.primaryColor,
              child: Icon(Icons.person, size: 90, color: Colors.white.withOpacity(0.8)),
            ),
            const SizedBox(height: 20),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userEmail,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),

            // Bio / Deskripsi Diri
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                userBio,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.white60,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Statistik Ringkas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  label: 'Total Sessions',
                  value: totalFocusSessions.toString(),
                  icon: Icons.access_time_outlined,
                ),
                _buildStatColumn(
                  label: 'Total Focus Time',
                  value: totalFocusTime,
                  icon: Icons.hourglass_empty_outlined,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Contoh: Tombol untuk melihat riwayat aktivitas lebih detail
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/activity_insights'); // Navigasi ke F2
              },
              icon: const Icon(Icons.bar_chart_outlined, color: Colors.white),
              label: const Text('View Detailed Activity', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Logout
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      title: const Text('Logout', style: TextStyle(color: Colors.white)),
                      content: const Text('Are you sure you want to log out?', style: TextStyle(color: Colors.white70)),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel', style: TextStyle(color: AppColors.primaryColor)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Logout', style: TextStyle(color: AppColors.errorColor)),
                          onPressed: () {
                            Navigator.of(context).pop(); // Tutup dialog
                            Navigator.of(context).pushReplacementNamed('/auth'); // Kembali ke halaman login
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn({required String label, required String value, required IconData icon}) {
    return Column(
      children: [
        Icon(icon, size: 30, color: AppColors.accentColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}