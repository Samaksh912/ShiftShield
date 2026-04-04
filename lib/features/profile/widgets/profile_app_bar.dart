import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../core/services/auth_service.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top + 65,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 24,
        right: 24,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0E0E0E).withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.90),
        border: Border(
          bottom: BorderSide(
            color: context.colors.onSurface.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person_pin,
                color: context.colors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'PROFILE',
                style: GoogleFonts.spaceGrotesk(
                  color: context.colors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  await AuthService.logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
                icon: Icon(
                  Icons.logout,
                  color: context.colors.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
