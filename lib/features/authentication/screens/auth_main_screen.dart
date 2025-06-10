import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';
import 'package:smodi/features/authentication/screens/login_form.dart';
import 'package:smodi/features/authentication/screens/signup_form.dart';

class AuthMainScreen extends StatefulWidget {
  const AuthMainScreen({super.key});

  @override
  State<AuthMainScreen> createState() => _AuthMainScreenState();
}

class _AuthMainScreenState extends State<AuthMainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper untuk menampilkan snackbar (untuk notifikasi UI sederhana)
  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.errorColor : AppColors.successColor,
        // behavior: SnackBarBehavior.floating, // Tampil di atas keyboard
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.splashGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Let's get started!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.headingText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Login or sign up to explore our app",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.headingText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), // Warna latar belakang tab bar
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    // indicator: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(30),
                    //   color: AppColors.tabIndicatorColor, // Warna indikator tab
                    // ),
                    labelColor: AppColors.primaryColor, // Warna teks tab terpilih
                    unselectedLabelColor: Colors.white, // Warna teks tab tidak terpilih
                    tabs: const [
                      Tab(text: 'Login'),
                      Tab(text: 'Sign Up'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      LoginForm(
                        onForgotPassword: () {
                          _showSnackbar("Forgot password clicked!", isError: false);
                          // TODO: Navigasi ke layar Forgot Password
                        },
                        onLoginSubmit: (email, password) {
                          _showSnackbar("Dummy Login: $email / $password", isError: false);
                          // Simulasi sukses login
                          Navigator.of(context).pushReplacementNamed('/home');
                        },
                      ),
                      SignUpForm(
                        onSignUpSubmit: (email, username, password) {
                          _showSnackbar("Dummy Sign Up: $email / $username / $password", isError: false);
                          // Setelah dummy sign up, bisa pindah ke tab login
                          _tabController.animateTo(0);
                        },
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 24),
                // // Opsi Login Lain
                // Row(
                //   children: [
                //     Expanded(child: Divider(color: Colors.white.withOpacity(0.5))),
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //       child: Text("other way", style: TextStyle(color: Colors.white.withOpacity(0.7))),
                //     ),
                //     Expanded(child: Divider(color: Colors.white.withOpacity(0.5))),
                //   ],
                // ),
                // const SizedBox(height: 16),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     _buildSocialButton('assets/icons/google_icon.png', () { // Ganti dengan path icon Anda
                //       _showSnackbar("Dummy Google Login clicked!", isError: false);
                //       // Navigator.of(context).pushReplacementNamed('/home'); // Simulasi login
                //     }),
                //     _buildSocialButton('assets/icons/github_icon.png', () { // Ganti dengan path icon Anda
                //       _showSnackbar("Dummy GitHub Login clicked!", isError: false);
                //     }),
                //     _buildSocialButton('assets/icons/facebook_icon.png', () { // Ganti dengan path icon Anda
                //       _showSnackbar("Dummy Facebook Login clicked!", isError: false);
                //     }),
                //   ],
                // ),
                // const SizedBox(height: 32),
                // // Login as Guest
                // TextButton(
                //   onPressed: () {
                //     _showSnackbar("Logging in as Guest...", isError: false);
                //     Navigator.of(context).pushReplacementNamed('/home'); // Langsung ke Home
                //   },
                //   child: const Text(
                //     "Login as Guest",
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 16,
                //       decoration: TextDecoration.underline,
                //       decorationColor: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk tombol sosial
  Widget _buildSocialButton(String imagePath, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10), // Sesuaikan border radius dengan desain
      child: Container(
        width: 60, // Sesuaikan ukuran
        height: 60, // Sesuaikan ukuran
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.socialButtonBgColor, // Latar belakang putih
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.socialButtonBorderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(imagePath, color: AppColors.socialButtonIconColor), // Gunakan Image.asset untuk logo
      ),
    );
  }
}