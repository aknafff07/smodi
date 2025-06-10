import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onForgotPassword;
  final Function(String email, String password) onLoginSubmit;

  const LoginForm({
    super.key,
    required this.onForgotPassword,
    required this.onLoginSubmit,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    // Simulasi penundaan untuk UI loading
    await Future.delayed(const Duration(seconds: 1));

    // Panggil callback untuk menyerahkan data ke parent (AuthMainScreen)
    widget.onLoginSubmit(_emailController.text, _passwordController.text);

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
            decoration: const InputDecoration(
              hintText: 'username/email',
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.white70, // Warna checkbox saat tidak terpilih
                    ),
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _rememberMe = newValue ?? false;
                        });
                      },
                    ),
                  ),
                  const Text('Remember me', style: TextStyle(color: Colors.white70)),
                ],
              ),
              TextButton(
                onPressed: widget.onForgotPassword,
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.deepPurpleAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Login', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}