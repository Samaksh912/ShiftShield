import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../quote/screens/quote_screen.dart';

// ─── Dummy fallback data (shown when API is unreachable) ───────────────────
const _dummyDashboard = {
  'rider': {
    'name': 'Rider',
    'zone_name': 'Your Zone',
    'platform': 'swiggy',
  },
  'wallet': {'balance': 0},
  'current_policy': null, // No active policy in dummy state
  'zone_weather': {
    'current_temp': 0,
    'current_aqi': 0,
    'current_rain_mm': 0.0,
    'status': 'normal',
    'last_updated': '',
  },
  'recent_claims': <dynamic>[],
  'next_week_quote_available': true,
};

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  bool _usedFallback = false;
  Map<String, dynamic> _data = Map<String, dynamic>.from(_dummyDashboard);

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getDashboard();
      setState(() {
        _data = data;
        _usedFallback = false;
        _isLoading = false;
      });
    } catch (_) {
      // Silently fall back to dummy data — screen still renders
      setState(() {
        _data = Map<String, dynamic>.from(_dummyDashboard);
        _usedFallback = true;
        _isLoading = false;
      });
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.length < 10) return '—';
    final parts = dateStr.substring(0, 10).split('-');
    if (parts.length != 3) return dateStr;
    const months = {
      '01': 'Jan', '02': 'Feb', '03': 'Mar', '04': 'Apr',
      '05': 'May', '06': 'Jun', '07': 'Jul', '08': 'Aug',
      '09': 'Sep', '10': 'Oct', '11': 'Nov', '12': 'Dec',
    };
    return '${months[parts[1]] ?? parts[1]} ${parts[2]}';
  }

  String _capitalise(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: context.colors.surface,
        body: Center(
          child: CircularProgressIndicator(color: context.colors.primary),
        ),
      );
    }

    final rider = (_data['rider'] as Map<String, dynamic>?) ?? {};
    final wallet = (_data['wallet'] as Map<String, dynamic>?) ?? {};
    final currentPolicy = _data['current_policy'] as Map<String, dynamic>?;
    final weather = (_data['zone_weather'] as Map<String, dynamic>?) ?? {};
    final recentClaims = (_data['recent_claims'] as List<dynamic>?) ?? [];
    final nextWeekQuoteAvailable =
        _data['next_week_quote_available'] as bool? ?? true;

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: RefreshIndicator(
        color: context.colors.primary,
        onRefresh: _fetchDashboard,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context, rider, wallet),
            SliverPadding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 24, bottom: 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Offline banner
                  if (_usedFallback) ...[
                    _buildOfflineBanner(context),
                    const SizedBox(height: 16),
                  ],
                  // Active policy OR no-policy card
                  currentPolicy != null
                      ? _buildActiveShield(context, currentPolicy)
                      : _buildNoPolicyCard(context),
                  const SizedBox(height: 24),
                  // Weather bento
                  _buildWeatherBento(context, weather),
                  const SizedBox(height: 24),
                  // Recent payouts
                  recentClaims.isNotEmpty
                      ? _buildRecentPayouts(context, recentClaims)
                      : _buildNoClaimsCard(context),
                  const SizedBox(height: 24),
                  // CTA
                  if (nextWeekQuoteAvailable) _buildCta(context),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Top bar ──────────────────────────────────────────────────────────────

  Widget _buildSliverAppBar(
    BuildContext context,
    Map<String, dynamic> rider,
    Map<String, dynamic> wallet,
  ) {
    final name = (rider['name'] as String? ?? 'Rider').toUpperCase();
    final zone = (rider['zone_name'] as String? ?? 'Zone').toUpperCase();
    final balance = wallet['balance'] ?? 0;

    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      expandedHeight: 80,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? const Color(0xFF131313).withValues(alpha: 0.85)
                  : Colors.white.withValues(alpha: 0.85),
              boxShadow: [
                BoxShadow(
                  color: context.colors.primary.withValues(alpha: 0.12),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                )
              ],
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 24,
              right: 24,
              bottom: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: context.colors.primary.withValues(alpha: 0.25)),
                        color: context.colors.surfaceContainerHighest,
                      ),
                      child: Icon(Icons.person,
                          color: context.colors.onSurfaceVariant, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.spaceGrotesk(
                            color: context.colors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          zone,
                          style: GoogleFonts.manrope(
                            color: context.colors.onSurfaceVariant,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: context.colors.onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '₹$balance',
                    style: GoogleFonts.spaceGrotesk(
                      color: context.colors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Offline banner ───────────────────────────────────────────────────────

  Widget _buildOfflineBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.colors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: context.colors.error.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: context.colors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Could not reach server. Showing cached placeholder data. Pull down to retry.',
              style: GoogleFonts.manrope(
                color: context.colors.error,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Active policy shield ─────────────────────────────────────────────────

  Widget _buildActiveShield(
      BuildContext context, Map<String, dynamic> policy) {
    // Field mapping per backend audit:
    // week_start / week_end / status / premium_paid / shifts_covered /
    // shifts_remaining.{lunch,dinner} / claims_this_week / total_payout_this_week
    final weekStart = _formatDate(policy['week_start'] as String?);
    final weekEnd = _formatDate(policy['week_end'] as String?);
    final status = policy['status'] as String? ?? 'active'; // scheduled | active | expired
    final premiumPaid = policy['premium_paid'] ?? 0;
    final claimsThisWeek = policy['claims_this_week'] ?? 0;
    final totalPayout = policy['total_payout_this_week'] ?? 0;
    final shiftsRem = (policy['shifts_remaining'] as Map<String, dynamic>?) ?? {};

    // Status colour
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
            color: statusColor.withValues(alpha: 0.15),
            blurRadius: 20,
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: Container(
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(12)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
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
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$weekStart – $weekEnd',
                          style: GoogleFonts.spaceGrotesk(
                            color: context.colors.onSurface,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.shield, color: statusColor, size: 13),
                          const SizedBox(width: 5),
                          Text(
                            statusLabel,
                            style: GoogleFonts.manrope(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Shifts remaining row
                Row(
                  children: [
                    Expanded(
                      child: _buildShiftBox(
                          context, 'LUNCH SHIFTS', '${shiftsRem['lunch'] ?? 0}', statusColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildShiftBox(
                          context, 'DINNER SHIFTS', '${shiftsRem['dinner'] ?? 0}', statusColor),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Stats row: premium paid / claims / payout
                Row(
                  children: [
                    _buildStatChip(context, '₹$premiumPaid', 'PREMIUM PAID'),
                    const SizedBox(width: 8),
                    _buildStatChip(context, '$claimsThisWeek', 'CLAIMS'),
                    const SizedBox(width: 8),
                    _buildStatChip(context, '₹$totalPayout', 'PAYOUT'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftBox(
      BuildContext context, String label, String value, Color accent) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        border:
            Border(left: BorderSide(color: accent.withValues(alpha: 0.35), width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              color: context.colors.onSurfaceVariant,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.spaceGrotesk(
                  color: accent,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'rem.',
                style: GoogleFonts.manrope(
                    color: context.colors.onSurfaceVariant, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                color: context.colors.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.manrope(
                color: context.colors.onSurfaceVariant,
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── No policy card ───────────────────────────────────────────────────────

  Widget _buildNoPolicyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: context.colors.outlineVariant.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.shield_outlined,
              size: 40, color: context.colors.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            'NO ACTIVE POLICY',
            style: GoogleFonts.spaceGrotesk(
              color: context.colors.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You are not covered this week. Get a quote to protect your shifts.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              color: context.colors.onSurfaceVariant.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Weather bento ────────────────────────────────────────────────────────

  Widget _buildWeatherBento(
      BuildContext context, Map<String, dynamic> weather) {
    // status: "normal" | "elevated" | "threshold_breached"
    final status = weather['status'] as String? ?? 'normal';
    Color aqiColor;
    String statusText;

    switch (status) {
      case 'elevated':
        aqiColor = context.colors.tertiary;
        statusText = 'Elevated';
      case 'threshold_breached':
        aqiColor = context.colors.error;
        statusText = 'Breached';
      default:
        aqiColor = context.colors.primary;
        statusText = 'Normal';
    }

    final temp = weather['current_temp'] ?? 0;
    final aqi = weather['current_aqi'] ?? 0;
    final rain = weather['current_rain_mm'] ?? 0.0;

    return Row(
      children: [
        // Temperature card (wider)
        Expanded(
          flex: 7,
          child: Container(
            height: 160,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(Icons.thermostat,
                      color: context.colors.onSurfaceVariant, size: 18),
                  const SizedBox(width: 8),
                  Text('WEATHER',
                      style: GoogleFonts.manrope(
                        color: context.colors.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      )),
                ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$temp°C',
                      style: GoogleFonts.spaceGrotesk(
                        color: context.colors.onSurface,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${rain}mm RAIN TODAY',
                      style: GoogleFonts.manrope(
                        color: context.colors.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // AQI card (narrower)
        Expanded(
          flex: 5,
          child: Container(
            height: 160,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(Icons.air, color: aqiColor, size: 18),
                  const SizedBox(width: 8),
                  Text('AQI',
                      style: GoogleFonts.manrope(
                        color: context.colors.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      )),
                ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$aqi',
                      style: GoogleFonts.spaceGrotesk(
                        color: aqiColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: aqiColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        statusText.toUpperCase(),
                        style: GoogleFonts.manrope(
                          color: aqiColor,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Recent payouts ───────────────────────────────────────────────────────

  Widget _buildRecentPayouts(BuildContext context, List<dynamic> claims) {
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
          // Backend fields: shift_type / trigger_type / severity_level /
          //                 payout_percent / payout_amount / status / created_at
          final isLunch = (claim['shift_type'] as String?) == 'lunch';
          final triggerType = claim['trigger_type'] as String? ?? '';
          final payoutAmount = claim['payout_amount'] ?? 0;
          final status = claim['status'] as String? ?? 'paid';
          final date = _formatDate(claim['created_at'] as String?);

          // Trigger badge
          Color triggerColor = context.colors.tertiary;
          String triggerLabel = triggerType.toUpperCase();
          if (triggerType == 'aqi') {
            triggerColor = context.colors.tertiary;
          } else if (triggerType == 'rain') {
            triggerColor = const Color(0xFF5BC8F5); // blue-ish
          } else if (triggerType == 'heat') {
            triggerColor = context.colors.error;
          }

          // Status indicator
          final isPaid = status == 'paid';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Shift icon
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isLunch
                            ? Icons.wb_sunny_outlined
                            : Icons.restaurant_outlined,
                        color: context.colors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Text info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLunch ? 'Lunch Shift' : 'Dinner Shift',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: context.colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            // Trigger badge
                            if (triggerLabel.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
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
                // Amount + status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹$payoutAmount',
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: context.colors.onSurface,
                      ),
                    ),
                    Text(
                      isPaid ? 'PAID' : _capitalise(status).toUpperCase(),
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

  // ─── No claims card ───────────────────────────────────────────────────────

  Widget _buildNoClaimsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline,
              color: context.colors.primary, size: 28),
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
                    color: context.colors.onSurfaceVariant.withValues(alpha: 0.7),
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

  // ─── CTA ──────────────────────────────────────────────────────────────────

  Widget _buildCta(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const QuoteScreen())),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [context.colors.primary, context.colors.primaryContainer],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "GET NEXT WEEK'S QUOTE",
                style: GoogleFonts.spaceGrotesk(
                  color: context.colors.onPrimaryFixed,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.colors.onPrimaryFixed.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_forward_ios,
                  color: context.colors.onPrimaryFixed, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
