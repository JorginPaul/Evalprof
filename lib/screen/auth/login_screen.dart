import 'package:flutter/material.dart';
import '../../utils/helpers.dart';
import '../../widgets/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  bool loading = false;
  String email = '', password = '';

  void _login() async {
    if (!_form.currentState!.validate()) return;
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // simulate
    setState(() => loading = false);
    replace(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const LoadingIndicator()
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Lecturer Hub',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        onChanged: (v) => email = v,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Enter email' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        onChanged: (v) => password = v,
                        validator: (v) => (v == null || v.length < 6)
                            ? 'Minimum 6 characters'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          child: const Text('Login'),
                        ),
                      ),
                      TextButton(
                        onPressed: () => push(context, '/register'),
                        child: const Text('Don’t have an account? Register'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
