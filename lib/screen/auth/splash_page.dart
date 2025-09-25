import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String route = '/splash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Text('EvalProfs', style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          color: Theme.of(context).colorScheme.surface,
          fontWeight: FontWeight.w700,
        ),),
      ),
    );
  }
}