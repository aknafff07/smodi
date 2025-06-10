import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progressBarValue = 0.0;

  @override
  void initState() {
    super.initState();
    _startAppInitialization();
  }

  Future<void> _startAppInitialization() async {
    // Simulasi inisialisasi dan loading UI
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _progressBarValue = 0.3); // Progress 1
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _progressBarValue = 0.6); // Progress 2
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _progressBarValue = 1.0); // Progress 3 (Selesai)

    await Future.delayed(const Duration(seconds: 1)); // Beri waktu untuk melihat progres

    if (!mounted) return;

    // Untuk fokus UI, kita selalu navigasi ke layar otentikasi setelah splash
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Tidak ada aksi untuk "Tap anywhere to start" jika loading otomatis
          // Jika mau, Anda bisa uncomment bagian di bawah dan hanya navigasi saat tap
          // if (_progressBarValue >= 1.0) {
          //   Navigator.of(context).pushReplacementNamed('/auth');
          // }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.splashGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'SMODI', // Nama aplikasi
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.headingText,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    value: _progressBarValue,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF011D3A)),
                  ),
                ),
                const SizedBox(height: 20),
                // Jika ingin ada "Tap anywhere to start" setelah loading selesai
                // if (_progressBarValue >= 1.0)
                //   const Text(
                //     'Tap anywhere to start',
                //     style: TextStyle(color: Colors.white70, fontSize: 16),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}