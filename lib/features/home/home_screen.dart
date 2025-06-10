import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';
import 'package:smodi/features/home/widgets/feature_card.dart';
import 'package:smodi/features/common_widgets/coming_soon_screen.dart'; // Import placeholder screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Untuk Bottom Navigation Bar, 0 = Home

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Dummy navigation for now based on bottom bar index
    if (index == 0) {
      // Stay on home
    } else {
      // Simulate navigation to other sections if implemented later
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigating to index $index (Coming Soon)!')),
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'Bottom Nav Feature')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background gelap sesuai desain
      appBar: AppBar(
        backgroundColor: Colors.white, // App bar juga gelap
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black), // Icon hamburger
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Buka drawer
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black), // Icon profil
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile icon clicked! (Coming Soon)')),
              );
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'User Profile')));
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context), // Drawer navigasi
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome ,',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              'this is Smodi', // Ganti WorkSight dengan FocusForge
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ready to learn?', // Atau 'Ready to start!'
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 32),
            // Kartu "Deep Focus"
            FeatureCard(
              title: 'Deep Focus',
              subtitle: 'Configuration',
              icon: Icons.lightbulb_outline, // Contoh ikon
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Deep Focus clicked!')),
                );
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'Deep Focus (F1)')));
              },
              backgroundColor: const Color(0xFF1A237E), // Biru gelap
            ),
            const SizedBox(height: 20),
            // Kartu "Activity and Productivity Tracker"
            FeatureCard(
              title: 'Activity and Productivity Tracker',
              icon: Icons.timer_outlined, // Contoh ikon jam
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Activity Tracker clicked!')),
                );
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'Activity & AI Insights (F2)')));
              },
              backgroundColor: const Color(0xFF8BC34A), // Hijau terang
            ),
            const SizedBox(height: 20),
            // Kartu "Camera Visual and Control"
            FeatureCard(
              title: 'Camera Visual and Control',
              subtitle: 'Configuration',
              icon: Icons.camera_alt_outlined, // Contoh ikon kamera
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Camera Control clicked!')),
                );
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'Camera Control (F3)')));
              },
              backgroundColor: const Color(0xFF009688), // Teal
            ),
            const SizedBox(height: 20),
            // Kartu "Settings and Personalization"
            FeatureCard(
              title: 'Settings and Personalization',
              icon: Icons.settings_outlined, // Contoh ikon pengaturan
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings clicked!')),
                );
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'Settings & Personalization (F4)')));
              },
              backgroundColor: const Color(0xFF607D8B), // Abu-abu kebiruan
            ),
            // const SizedBox(height: 30),
            // // Bagian "Configuration" dan "bla bla bla"
            // // Desainnya menunjukkan ini adalah deskripsi umum atau info tambahan.
            // // Bisa berupa teks statis atau informasi dinamis.
            // const Text(
            //   'configuration',
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // const Text(
            //   'bla bal bla',
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.white70,
            //   ),
            // ),
            // const Text(
            //   'bla bla :',
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.white70,
            //   ),
            // ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.black, // Latar belakang gelap
      //   selectedItemColor: AppColors.accentColor, // Warna ikon terpilih (kuning)
      //   unselectedItemColor: Colors.white54, // Warna ikon tidak terpilih
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.folder_open), // Ikon folder
      //       label: 'Activity',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.history), // Ikon history/reload
      //       label: 'History',
      //     ),
      //   ],
      // ),
    );
  }

  // Widget untuk Navigation Drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E), // Warna drawer gelap
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black, // Warna header drawer
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.accentColor,
                  child: Icon(Icons.person, size: 40, color: AppColors.primaryColor),
                ),
                const SizedBox(height: 10),
                const Text(
                  'User Name', // Placeholder nama pengguna
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  'user.email@example.com', // Placeholder email
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Item menu drawer (sesuai "Frame 1" dan sitemap)
          _buildDrawerMenuItem(
            context,
            title: 'Home',
            icon: Icons.home,
            onTap: () {
              Navigator.pop(context); // Tutup drawer
              setState(() => _selectedIndex = 0); // Set home sebagai selected
              // Tidak perlu navigasi karena sudah di home
            },
            isActive: _selectedIndex == 0,
          ),
          _buildDrawerMenuItem(
            context,
            title: 'Deep Focus',
            subtitle: 'Configuration',
            icon: Icons.lightbulb_outline,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Drawer: Deep Focus clicked!')),
              );
              Navigator.pop(context); // Tutup drawer
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'Deep Focus (F1)')));
            },
          ),
          _buildDrawerMenuItem(
            context,
            title: 'Activity and Productivity Tracker',
            icon: Icons.timer_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Drawer: Activity Tracker clicked!')),
              );
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'Activity & AI Insights (F2)')));
            },
          ),
          _buildDrawerMenuItem(
            context,
            title: 'Camera Visual and Control',
            subtitle: 'Configuration',
            icon: Icons.camera_alt_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Drawer: Camera Control clicked!')),
              );
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'Camera Control (F3)')));
            },
          ),
          _buildDrawerMenuItem(
            context,
            title: 'Settings and Personalization',
            icon: Icons.settings_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Drawer: Settings clicked!')),
              );
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComingSoonScreen(featureName: 'Settings & Personalization (F4)')));
            },
          ),
          const Divider(color: Colors.white24), // Pemisah
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white54),
            title: const Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logging out... (Dummy)")),
              );
              Navigator.pop(context); // Tutup drawer
              Navigator.of(context).pushReplacementNamed('/auth'); // Kembali ke halaman login
            },
          ),
        ],
      ),
    );
  }

  // Helper untuk item menu drawer
  Widget _buildDrawerMenuItem(
      BuildContext context, {
        required String title,
        String? subtitle,
        required IconData icon,
        required VoidCallback onTap,
        bool isActive = false,
      }) {
    return Container(
      color: isActive ? Colors.yellow.withOpacity(0.2) : Colors.transparent, // Warna latar belakang jika aktif
      child: ListTile(
        leading: Icon(icon, color: isActive ? AppColors.accentColor : Colors.white54),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.accentColor : Colors.white,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: const TextStyle(color: Colors.white38, fontSize: 12),
        )
            : null,
        onTap: onTap,
        trailing: isActive
            ? Icon(Icons.keyboard_arrow_right, color: AppColors.accentColor) // Indikator jika aktif
            : null,
      ),
    );
  }
}