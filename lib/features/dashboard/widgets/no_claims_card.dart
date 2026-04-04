import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class NoClaimsCard extends StatelessWidget {
  const NoClaimsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final defaultShadow = isLight
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ]
        : <BoxShadow>[];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: defaultShadow,
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: context.colors.primary,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NO RECENT CLAIMS',
                  style: GoogleFonts.spaceGrotesk(
                    color: context.colors.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You\'re protected. Payouts appear here if a weather trigger occurs.',
                  style: GoogleFonts.manrope(
                    color: context.colors.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
