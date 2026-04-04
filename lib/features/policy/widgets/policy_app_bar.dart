import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class PolicyAppBar extends StatelessWidget {
  const PolicyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 65,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF0E0E0E).withValues(alpha: 0.70)
                  : Colors.white.withValues(alpha: 0.80),
              border: Border(
                bottom: BorderSide(
                  color: context.colors.outline.withValues(alpha: 0.05),
                ),
              ),
            ),
          ),
        ),
      ),
      // Placed inside title so Flutter natively handles the Safe Area!
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.shield, color: context.colors.primary, size: 24),
          const SizedBox(width: 12),
          Text(
            'POLICIES',
            style: GoogleFonts.spaceGrotesk(
              color: context.colors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
