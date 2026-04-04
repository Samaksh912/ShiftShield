import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../core/utils/formatters.dart';

class RecentPayoutsList extends StatelessWidget {
  final List<dynamic> claims;

  const RecentPayoutsList({super.key, required this.claims});

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT PAYOUTS',
                style: GoogleFonts.manrope(
                  color: context.colors.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                'VIEW ALL',
                style: GoogleFonts.manrope(
                  color: context.colors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        ...claims.take(3).map((c) {
          final claim = c as Map<String, dynamic>;
          final isLunch = (claim['shift_type'] as String?) == 'lunch';
          final triggerType = claim['trigger_type'] as String? ?? '';
          final payoutAmount = claim['payout_amount'] ?? 0;
          final status = claim['status'] as String? ?? 'paid';
          final date = Formatters.formatDate(claim['created_at'] as String?);

          Color triggerColor = context.colors.tertiary;
          String triggerLabel = triggerType.toUpperCase();
          if (triggerType == 'aqi') {
            triggerColor = context.colors.tertiary;
          } else if (triggerType == 'rain') {
            triggerColor = const Color(0xFF5BC8F5);
          } else if (triggerType == 'heat') {
            triggerColor = context.colors.error;
          }

          final isPaid = status == 'paid';

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
              boxShadow: defaultShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isLunch
                            ? Icons.wb_sunny_outlined
                            : Icons.restaurant_outlined,
                        color: context.colors.primary,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLunch ? 'Lunch Shift' : 'Dinner Shift',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: context.colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            if (triggerLabel.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: triggerColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  triggerLabel,
                                  style: GoogleFonts.manrope(
                                    color: triggerColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Text(
                              date,
                              style: GoogleFonts.manrope(
                                color: context.colors.onSurfaceVariant,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹$payoutAmount',
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: context.colors.onSurface,
                      ),
                    ),
                    Text(
                      isPaid ? 'PAID' : Formatters.capitalise(status).toUpperCase(),
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        letterSpacing: 0.5,
                        color: isPaid
                            ? context.colors.primary
                            : context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
