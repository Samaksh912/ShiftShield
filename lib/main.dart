import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/foundation.dart'; // for kIsWeb

import 'theme/app_theme.dart';
import 'core/config.dart';
import 'core/services/auth_service.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.devBypassAuth) {
    await AuthService.saveToken(AppConfig.devJwt);
    await AuthService.savePhone('9876543210');
  } else {
    await AuthService.clearToken();
  }

  runApp(const IgniteApp());
}

class IgniteApp extends StatelessWidget {
  const IgniteApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget app = MaterialApp.router(
      title: 'ShiftShield',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );

    // 👉 Only apply mobile frame on WEB
    if (kIsWeb) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.grey[300],
          body: Center(
            child: Container(
              width: 375, // mobile width
              height: 812, // mobile height
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(blurRadius: 20, color: Colors.black26),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: app,
              ),
            ),
          ),
        ),
      );
    }

    // 👉 Normal mobile app
    return app;
  }
}
