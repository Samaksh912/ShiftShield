import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/dashboard/screens/main_layout.dart';
import 'core/config.dart';
import 'core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DEV BYPASS: skip auth entirely and jump straight to the dashboard
  if (AppConfig.devBypassAuth) {
    await AuthService.saveToken(AppConfig.devJwt);
    await AuthService.savePhone('9876543210');
  }

  runApp(const IgniteApp());
}

class IgniteApp extends StatelessWidget {
  const IgniteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShiftShield',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // If bypass is active, start directly on the main layout (dashboard)
      // otherwise go through the normal onboarding / login flow
      home: AppConfig.devBypassAuth ? const MainLayout() : const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
