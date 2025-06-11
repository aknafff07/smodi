import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _nameController = TextEditingController(text: 'John Doe'); // Dummy data
  final _emailController = TextEditingController(text: 'john.doe@example.com'); // Dummy data

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile saved: Name: ${_nameController.text}, Email: ${_emailController.text} (Dummy)'),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
    // Dummy save logic
    Navigator.pop(context); // Kembali ke layar sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headingText,
      appBar: AppBar(
        backgroundColor: AppColors.headingText,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primaryColor,
                    child: Icon(Icons.person, size: 80, color: Colors.white.withOpacity(0.8)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Change profile picture (Coming Soon)')),
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.accentColor,
                        child: Icon(Icons.camera_alt, size: 20, color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Changes', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}