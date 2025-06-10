import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';

class SignUpForm extends StatefulWidget {
  final Function(String email, String username, String password) onSignUpSubmit;

  const SignUpForm({
    super.key,
    required this.onSignUpSubmit,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    setState(() {
      _isLoading = true;
    });

    // Simulasi penundaan untuk UI loading
    await Future.delayed(const Duration(seconds: 1));

    // Panggil callback untuk menyerahkan data ke parent (AuthMainScreen)
    widget.onSignUpSubmit(
      _emailController.text,
      _usernameController.text,
      _passwordController.text,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'email',
              prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              hintText: 'username',
              prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'password',
              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSignUp,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Done', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}