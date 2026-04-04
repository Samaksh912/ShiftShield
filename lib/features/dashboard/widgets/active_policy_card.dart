import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../core/utils/formatters.dart';

class ActivePolicyCard extends StatelessWidget {
  final Map<String, dynamic> policy;

  const ActivePolicyCard({super.key, required this.policy});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final weekStart = Formatters.formatDate(policy['week_start'] as String?);
    final weekEnd = Formatters.formatDate(policy['week_end'] as String?);
    final status = policy['status'] as String? ?? 'active';
    final premiumPaid = policy['premium_paid'] ?? 0;
    final totalPayout = policy['total_payout_this_week'] ?? 0;
    final shiftsRem = (policy['shifts_remaining'] as Map<String, dynamic>?) ?? {};

    Color statusColor;
    String statusLabel;
    if (status == 'active') {
      statusColor = context.colors.primary;
      statusLabel = 'COVERED';
    } else if (status == 'scheduled') {
      statusColor = context.colors.tertiary;
      statusLabel = 'SCHEDULED';
    } else {
      statusColor = context.colors.onSurfaceVariant;
      statusLabel = 'EXPIRED';
    }

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: isLight ? 0.25 : 0.15),
            blurRadius: isLight ? 24 : 20,
            offset: isLight ? const Offset(0, 8) : Offset.zero,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left accent bar
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: Container(
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ACTIVE POLICY',
                          style: GoogleFonts.spaceGrotesk(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          '$weekStart – $weekEnd',
                          style: GoogleFonts.spaceGrotesk(
                            color: context.colors.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.shield, color: statusColor, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            statusLabel,
                            style: GoogleFonts.manrope(
                              color: statusColor,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Money Row (Huge focus)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PREMIUM PAID',
                          style: GoogleFonts.manrope(
                            color: context.colors.onSurfaceVariant,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          '₹$premiumPaid',
                          style: GoogleFonts.spaceGrotesk(
                            color: context.colors.onSurface,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'TOTAL PAYOUT',
                          style: GoogleFonts.manrope(
                            color: context.colors.onSurfaceVariant,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          '₹$totalPayout',
                          style: GoogleFonts.spaceGrotesk(
                            color: context.colors.primary,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                
                // Shifts Remaining Header
                Text(
                  'SHIFTS REMAINING',
                  style: GoogleFonts.manrope(
                    color: context.colors.onSurfaceVariant,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                
                // Shifts remaining compact layout
                Row(
                  children: [
                    Expanded(
                      child: _buildShiftBoxCompact(
                        context,
                        'LUNCH',
                        '${shiftsRem['lunch'] ?? 0}',
                        statusColor,
                        Icons.wb_sunny_outlined,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildShiftBoxCompact(
                        context,
                        'DINNER',
                        '${shiftsRem['dinner'] ?? 0}',
                        statusColor,
                        Icons.restaurant_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftBoxCompact(
    BuildContext context,
    String label,
    String value,
    Color accent,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: context.colors.onSurfaceVariant, size: 14),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.manrope(
                  color: context.colors.onSurfaceVariant,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.spaceGrotesk(
                  color: context.colors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
