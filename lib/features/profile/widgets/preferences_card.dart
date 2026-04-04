import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class PreferencesCard extends StatelessWidget {
  final Map<String, dynamic> preferences;
  final ValueChanged<String> onShiftChanged;
  final ValueChanged<String> onPayoutChanged;
  final TextEditingController upiController;

  const PreferencesCard({
    super.key,
    required this.preferences,
    required this.onShiftChanged,
    required this.onPayoutChanged,
    required this.upiController,
  });

  @override
  Widget build(BuildContext context) {
    final shiftPref = preferences['shift_preference'] as String? ?? 'both';
    final payoutPref = preferences['payout_preference'] as String? ?? 'wallet';

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune,
                  color: context.colors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'PREFERENCES',
                  style: GoogleFonts.manrope(
                    color: context.colors.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Shift Preferences
            Text(
              'Preferred Shifts',
              style: GoogleFonts.spaceGrotesk(
                color: context.colors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildSegmentedControl(
              context,
              options: [
                {'label': 'Lunch', 'value': 'lunch'},
                {'label': 'Both', 'value': 'both'},
                {'label': 'Dinner', 'value': 'dinner'},
              ],
              currentValue: shiftPref,
              onChanged: onShiftChanged,
            ),
            
            const SizedBox(height: 32),
            const Divider(color: Colors.white10),
            const SizedBox(height: 24),

            // Payout Preferences
            Text(
              'Payout Mode',
              style: GoogleFonts.spaceGrotesk(
                color: context.colors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildSegmentedControl(
              context,
              options: [
                {'label': 'Wallet', 'value': 'wallet'},
                {'label': 'Direct (UPI)', 'value': 'upi'},
              ],
              currentValue: payoutPref,
              onChanged: onPayoutChanged,
            ),
            
            // Conditional UPI Field
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: payoutPref == 'upi'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'UPI ID REQUIRED',
                            style: GoogleFonts.manrope(
                              color: context.colors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: context.colors.surfaceContainer,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: context.colors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: TextField(
                              controller: upiController,
                              style: GoogleFonts.spaceGrotesk(
                                color: context.colors.onSurface,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: 'e.g. rahul@okaxis',
                                hintStyle: GoogleFonts.spaceGrotesk(
                                  color: context.colors.onSurfaceVariant.withValues(alpha: 0.5),
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(
    BuildContext context, {
    required List<Map<String, String>> options,
    required String currentValue,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = currentValue == option['value'];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(option['value']!),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected ? context.colors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    option['label']!,
                    style: GoogleFonts.manrope(
                      color: isSelected
                          ? context.colors.onPrimaryFixed
                          : context.colors.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
