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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#  void _login() async {*~]').hasMatch(value)) {
      return 'Password must contain at least one special character (!@#\  void _login() async {*~)';
    }
    return null;
  }

  Widget _buildPasswordRequirement(String requirement, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: isMet ? const Color(0xFF4CAF50) : const Color(0xFFBBBBBB),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              requirement,
              style: TextStyle(
                fontSize: 11,
                color: isMet ? const Color(0xFF4CAF50) : const Color(0xFF666666),
                fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
      backgroundColor: Colors.white,
      body: loading
          ? const LoadingIndicator()
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                      // App Title
                      const Text(
                        'EvalProfs',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Logo Container - Placeholder for your logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.school, // Placeholder - replace with your logo
                            size: 40,
                            color: Color(0xFFFF4444),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Welcome Text
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF4444),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Subtitle
                      const Text(
                        'Sign in to access your teaching resources.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF888888),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Email Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'your.email@example.com',
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 170, 165, 165),
                              ),
                              filled: true,
                              fillColor: const Color.fromARGB(255, 226, 224, 224),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onChanged: (v) => email = v,
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Enter email' : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 170, 165, 165),
                              ),
                              filled: true,
                              fillColor: const Color.fromARGB(255, 226, 224, 224),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onChanged: (v) => password = v,
                            validator: (v) => _validatePassword(v),
                          ),

                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                                width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildPasswordRequirement(
                                    'At least 8 characters', password.length >= 8),
                                _buildPasswordRequirement(
                                    'Contains uppercase letter',
                                    RegExp(r'[A-Z]').hasMatch(password)),
                                _buildPasswordRequirement(
                                    'Contains lowercase letter',
                                    RegExp(r'[a-z]').hasMatch(password)),
                                _buildPasswordRequirement(
                                    'Contains number',
                                    RegExp(r'[0-9]').hasMatch(password)),
                                _buildPasswordRequirement(
                                    'Contains special character (!@#\$&*~)',
                                    RegExp(r'[!@#\$&*~]').hasMatch(password)),
                              ],
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 32),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF4444),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Log In Securely',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Register Section
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF888888),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      TextButton(
                        onPressed: () => push(context, '/register'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFFF4444),
                        ),
                        child: const Text(
                          'Register Now',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              ),
            ),
    );
  }
}