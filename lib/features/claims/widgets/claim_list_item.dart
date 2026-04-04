import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import 'claim_detail_bottom_sheet.dart';

class ClaimListItem extends StatelessWidget {
  final Map<String, dynamic> claim;

  const ClaimListItem({super.key, required this.claim});

  @override
  Widget build(BuildContext context) {
    final claimDate = Formatters.formatDate(claim['claim_date'] as String?);
    final shiftType = claim['shift_type'] as String? ?? 'lunch';
    final triggerType = claim['trigger_type'] as String? ?? 'aqi';
    final payoutAmount = claim['payout_amount'] ?? 0;
    final status = claim['status'] as String? ?? 'under_review';

    final isPaid = status == 'paid';
    final isRejected = status == 'rejected';

    Color triggerColor;
    IconData triggerIcon;
    if (triggerType == 'aqi') {
      triggerColor = context.colors.tertiary;
      triggerIcon = Icons.air;
    } else if (triggerType == 'rain') {
      triggerColor = const Color(0xFF5BC8F5);
      triggerIcon = Icons.water_drop_outlined;
    } else {
      triggerColor = context.colors.error;
      triggerIcon = Icons.thermostat;
    }

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (ctx) => ClaimDetailBottomSheet(claim: claim),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Trigger Icon Box
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: triggerColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(triggerIcon, color: triggerColor, size: 20),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      claimDate,
                      style: GoogleFonts.spaceGrotesk(
                        color: context.colors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          Formatters.capitalise(shiftType),
                          style: GoogleFonts.manrope(
                            color: context.colors.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: context.colors.onSurfaceVariant.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          triggerType.toUpperCase(),
                          style: GoogleFonts.manrope(
                            color: triggerColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
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
                    color: isRejected
                        ? context.colors.onSurfaceVariant
                        : context.colors.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    decoration: isRejected ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? context.colors.primary.withValues(alpha: 0.1)
                        : isRejected
                            ? context.colors.error.withValues(alpha: 0.1)
                            : context.colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status.replaceAll('_', ' ').toUpperCase(),
                    style: GoogleFonts.manrope(
                      color: isPaid
                          ? context.colors.primary
                          : isRejected
                              ? context.colors.error
                              : context.colors.onSurfaceVariant,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
