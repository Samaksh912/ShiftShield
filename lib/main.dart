import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'core/config.dart';
import 'core/services/auth_service.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DEV BYPASS: pre-save token so the auth guard lets us through to dashboard
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
    return MaterialApp.router(
      title: 'ShiftShield',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
