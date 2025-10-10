import 'package:flutter/material.dart';
import '../../utils/helpers.dart';
import '../../widgets/loading_indicator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  bool loading = false;
  bool agreeToTerms = false;
  String name = '', email = '', password = '', confirmPassword = '';
  String institution = '', subject = '', academicLevel = '';

  // Subject options
  final List<String> subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer Science',
    'Engineering',
    'Literature',
    'History',
    'Psychology',
    'Economics',
    'Other'
  ];

  // Academic level options
  final List<String> academicLevels = [
    'High School',
    'Undergraduate',
    'Graduate',
    'Postgraduate',
    'Professor/Faculty'
  ];

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

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
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return 'Password must contain at least one special character (!@#\$&*~)';
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

  Widget _buildInputField(String label, String hint, Function(String) onChanged, String? Function(String?) validator, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
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
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String hint, List<String> items, String value, Function(String?) onChanged, String? Function(String?) validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          decoration: InputDecoration(
            hintText: hint,
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
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  void _register() async {
    if (!_form.currentState!.validate()) return;
    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms of Service and Privacy Policy')),
      );
      return;
    }
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // simulate
    setState(() => loading = false);
    replace(context, '/login');
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

                        const SizedBox(height: 20),

                        // Logo Container
                        Container(
                          width: 60,
                          height: 60,
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
                              Icons.school,
                              size: 30,
                              color: Color(0xFFFF4444),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Welcome Text
                        const Text(
                          'Join EvalProfs Today!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF4444),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Subtitle
                        const Text(
                          'Create your account to get started.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF888888),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Personal Details Section
                        _buildSectionTitle('Personal Details'),
                        _buildInputField(
                          'Full Name',
                          'Enter your full name',
                          (v) => name = v,
                          (v) => (v == null || v.isEmpty) ? 'Enter your name' : null,
                        ),

                        const SizedBox(height: 20),

                        _buildInputField(
                          'Email Address',
                          'your.email@example.com',
                          (v) => email = v,
                          _validateEmail,
                        ),

                        const SizedBox(height: 32),

                        // Academic Information Section
                        _buildSectionTitle('Academic Information'),
                        _buildInputField(
                          'Institution',
                          'Your university or institution',
                          (v) => institution = v,
                          (v) => (v == null || v.isEmpty) ? 'Enter your institution' : null,
                        ),

                        const SizedBox(height: 20),

                        _buildDropdownField(
                          'Subject',
                          'Select your primary subject',
                          subjects,
                          subject,
                          (v) => setState(() => subject = v ?? ''),
                          (v) => (v == null || v.isEmpty) ? 'Select a subject' : null,
                        ),

                        const SizedBox(height: 20),

                        _buildDropdownField(
                          'Academic Level',
                          'Select your academic level',
                          academicLevels,
                          academicLevel,
                          (v) => setState(() => academicLevel = v ?? ''),
                          (v) => (v == null || v.isEmpty) ? 'Select academic level' : null,
                        ),

                        const SizedBox(height: 32),

                        // Account Security Section
                        _buildSectionTitle('Account Security'),
                        _buildInputField(
                          'Create Password',
                          'Enter a secure password',
                          (v) => setState(() => password = v),
                          _validatePassword,
                          obscureText: true,
                        ),

                        const SizedBox(height: 8),

                        // Password Requirements
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                              width: 1,
                            ),
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

                        const SizedBox(height: 20),

                        _buildInputField(
                          'Confirm Password',
                          'Re-enter your password',
                          (v) => confirmPassword = v,
                          (v) => (v != password) ? 'Passwords do not match' : null,
                          obscureText: true,
                        ),

                        const SizedBox(height: 24),

                        // Terms and Conditions
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: agreeToTerms,
                                onChanged: (v) => setState(() => agreeToTerms = v ?? false),
                                activeColor: const Color(0xFFFF4444),
                              ),
                              const Expanded(
                                child: Text(
                                  'I agree to the EvalProfs Terms of Service and Privacy Policy.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Register Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF4444),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Create My EvalProfs Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login Section
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF888888),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        TextButton(
                          onPressed: () => push(context, '/login'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFFF4444),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Copyright
                        const Text(
                          '© 2023 EvalProfs. All rights reserved.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                          textAlign: TextAlign.center,
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