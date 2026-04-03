import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

void main() {
  runApp(const IgniteApp());
}

class IgniteApp extends StatelessWidget {
  const IgniteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ignite Onboarding',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
