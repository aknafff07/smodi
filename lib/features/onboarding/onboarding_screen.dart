import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Onboarding!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text('This is where you introduce features and setup IoT.', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Simulasi selesai onboarding
                Navigator.of(context).pushReplacementNamed('/home');
              },
              child: const Text('Finish Onboarding'),
            ),
          ],
        ),
      ),
    );
  }
}