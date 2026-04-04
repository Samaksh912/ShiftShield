import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config.dart';
import '../services/auth_service.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/verify_otp_screen.dart';
import '../../features/auth/screens/rider_profile_screen.dart';
import '../../features/dashboard/screens/main_layout.dart';

// ---------------------------------------------------------------------------
// Named route constants — use these everywhere instead of raw strings
// ---------------------------------------------------------------------------
abstract class AppRoutes {
  static const String onboarding   = '/onboarding';
  static const String login        = '/login';
  static const String signup       = '/signup';
  static const String verifyOtp    = '/verify-otp/:phone';
  static const String riderProfile = '/rider-profile';
  static const String dashboard    = '/dashboard';

  /// Build the concrete verify-otp path for a given phone number.
  static String verifyOtpPath(String phone) => '/verify-otp/$phone';
}

// ---------------------------------------------------------------------------
// Route names (for context.goNamed / context.pushNamed)
// ---------------------------------------------------------------------------
abstract class RouteNames {
  static const String onboarding   = 'onboarding';
  static const String login        = 'login';
  static const String signup       = 'signup';
  static const String verifyOtp    = 'verifyOtp';
  static const String riderProfile = 'riderProfile';
  static const String dashboard    = 'dashboard';
}

// ---------------------------------------------------------------------------
// The router instance
// ---------------------------------------------------------------------------
final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,

  // Where the app starts — devBypassAuth skips straight to dashboard.
  initialLocation:
      AppConfig.devBypassAuth ? AppRoutes.dashboard : AppRoutes.onboarding,

  // Auth guard redirect
  redirect: (BuildContext context, GoRouterState state) async {
    // Protected routes that require a valid token
    final protectedRoutes = [AppRoutes.dashboard, AppRoutes.riderProfile];
    final bool isProtected = protectedRoutes.any(
      (r) => state.matchedLocation.startsWith(r.split('/:').first),
    );

    if (!isProtected) return null; // auth routes, let through

    // Dev bypass: token was pre-saved in main() — always let through
    if (AppConfig.devBypassAuth) return null;

    final token = await AuthService.getToken();
    if (token == null || token.isEmpty) {
      return AppRoutes.login;
    }
    return null;
  },

  routes: [
    // ── Onboarding ──────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.onboarding,
      name: RouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // ── Auth ────────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.login,
      name: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: AppRoutes.signup,
      name: RouteNames.signup,
      builder: (context, state) => const SignupScreen(),
    ),

    GoRoute(
      path: AppRoutes.verifyOtp,            // '/verify-otp/:phone'
      name: RouteNames.verifyOtp,
      builder: (context, state) {
        final phone = state.pathParameters['phone'] ?? '';
        final extra = state.extra as Map<String, dynamic>?;
        final isLogin = extra?['isLogin'] as bool? ?? true;
        return VerifyOtpScreen(mobileNumber: phone, isLogin: isLogin);
      },
    ),

    GoRoute(
      path: AppRoutes.riderProfile,
      name: RouteNames.riderProfile,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return RiderProfileScreen(
          phone: extra?['phone'] as String? ?? '',
          verificationToken: extra?['verification_token'] as String? ?? '',
        );
      },
    ),

    // ── Dashboard (main layout with bottom nav) ──────────────────────────
    GoRoute(
      path: AppRoutes.dashboard,
      name: RouteNames.dashboard,
      builder: (context, state) => const MainLayout(),
    ),
  ],

  // Custom error page
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(
        'Page not found: ${state.error}',
        style: const TextStyle(color: Colors.red),
      ),
    ),
  ),
);
