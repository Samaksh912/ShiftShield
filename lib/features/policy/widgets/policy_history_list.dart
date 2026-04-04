import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../core/utils/formatters.dart';

class PolicyHistoryList extends StatelessWidget {
  final List<dynamic> policies;

  const PolicyHistoryList({super.key, required this.policies});

  @override
  Widget build(BuildContext context) {
    if (policies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Policy History',
          style: GoogleFonts.spaceGrotesk(
            color: context.colors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.25,
          ),
        ),
        const SizedBox(height: 24),
        ...policies.map(
          (p) => PolicyHistoryItem(policy: p as Map<String, dynamic>),
        ),
      ],
    );
  }
}

class PolicyHistoryItem extends StatelessWidget {
  final Map<String, dynamic> policy;

  const PolicyHistoryItem({super.key, required this.policy});

  @override
  Widget build(BuildContext context) {
    final weekStart = Formatters.formatDate(policy['week_start'] as String?);
    final weekEnd = Formatters.formatDate(policy['week_end'] as String?);
    final status = policy['status'] as String? ?? 'expired';
    final premiumPaid = policy['premium_paid'] ?? 0;
    final shiftsCovered = policy['shifts_covered'] as String? ?? 'Both Shifts';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colors.outline.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.history,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$weekStart - $weekEnd',
                        style: GoogleFonts.spaceGrotesk(
                          color: context.colors.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shiftsCovered.toUpperCase(),
                        style: GoogleFonts.manrope(
                          color: context.colors.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹$premiumPaid',
                style: GoogleFonts.spaceGrotesk(
                  color: context.colors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status.toLowerCase() == 'expired'
                      ? context.colors.error.withValues(alpha: 0.1)
                      : context.colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: GoogleFonts.manrope(
                    color: status.toLowerCase() == 'expired'
                        ? context.colors.error
                        : context.colors.onSurfaceVariant,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
