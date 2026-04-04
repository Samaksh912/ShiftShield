import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class ClaimsSummarySection extends StatelessWidget {
  final Map<String, dynamic> summary;

  const ClaimsSummarySection({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final totalClaims = summary['total_claims'] ?? 0;
    final totalPayout = summary['total_payout'] ?? 0;
    final totalPremiums = summary['total_premiums_paid'] ?? summary['total_premiums'] ?? 0;
    final netBenefit = summary['net_benefit'] ?? 0;

    final isPositive = netBenefit >= 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Financial Overview',
                style: GoogleFonts.spaceGrotesk(
                  color: context.colors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bar_chart, color: context.colors.onSurfaceVariant, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '$totalClaims CLAIMS',
                      style: GoogleFonts.manrope(
                        color: context.colors.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Massive Net Benefit Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isPositive
                  ? context.colors.primary.withValues(alpha: 0.1)
                  : context.colors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isPositive
                    ? context.colors.primary.withValues(alpha: 0.2)
                    : context.colors.error.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL NET BENEFIT',
                      style: GoogleFonts.manrope(
                        color: isPositive ? context.colors.primary : context.colors.error,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹$netBenefit',
                      style: GoogleFonts.spaceGrotesk(
                        color: isPositive ? context.colors.primary : context.colors.error,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? context.colors.primary : context.colors.error,
                  size: 32,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Sub metrics
          Row(
            children: [
              Expanded(child: _buildMetricCard(context, 'TOTAL PAYOUT', '₹$totalPayout', context.colors.onSurface)),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard(context, 'PREMIUMS PAID', '₹$totalPremiums', context.colors.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              color: context.colors.onSurfaceVariant,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              color: valueColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
