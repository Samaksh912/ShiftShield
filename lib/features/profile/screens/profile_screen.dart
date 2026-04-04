import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_animate/flutter_animate.dart' hide ShimmerEffect;
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../core/services/api_service.dart';

import '../data/profile_mock_data.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/user_info_card.dart';
import '../widgets/zone_selection_card.dart';
import '../widgets/preferences_card.dart';
import '../widgets/baseline_earnings_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasActivePolicy = false;

  Map<String, dynamic> _rider = {};
  List<dynamic> _zones = [];
  Map<String, dynamic> _baselines = {};
  Map<String, dynamic> _preferences = {};

  final TextEditingController _upiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  @override
  void dispose() {
    _upiController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfileData() async {
    setState(() => _isLoading = true);
    try {
      final responses = await Future.wait([
        ApiService.getMe(),
        ApiService.getZones(),
        ApiService.getCurrentPolicy().catchError((_) => <String, dynamic>{}),
      ]);

      final riderRes = responses[0] as Map<String, dynamic>;
      final zonesRes = responses[1] as Map<String, dynamic>;
      final policyRes = responses[2] as Map<String, dynamic>;

      _setupState(
        riderData: riderRes['rider'],
        zonesData: zonesRes['zones'] ?? [],
        hasPolicy:
            policyRes.containsKey('policy') && policyRes['policy'] != null,
      );
    } catch (e) {
      debugPrint('>>> PROFILE FETCH ERROR: $e');
      _setupState(
        riderData: mockProfileData['rider'],
        zonesData: mockZonesList['zones'],
        hasPolicy: false,
      );
    }
  }

  void _setupState({
    required Map<String, dynamic> riderData,
    required List<dynamic> zonesData,
    required bool hasPolicy,
  }) {
    setState(() {
      _rider = Map<String, dynamic>.from(riderData);
      _baselines = Map<String, dynamic>.from(_rider['baselines'] ?? {});
      _preferences = Map<String, dynamic>.from(_rider['preferences'] ?? {});
      _zones = zonesData;
      _hasActivePolicy = hasPolicy;

      _upiController.text = _preferences['upi_id'] ?? '';
      _isLoading = false;
    });
  }

  Future<void> _saveChanges() async {
    // Validate if direct payout
    if (_preferences['payout_preference'] == 'direct' &&
        _upiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('UPI ID is required for Direct payout.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    // Construct local payload updates
    final updatedPrefs = Map<String, dynamic>.from(_preferences);
    updatedPrefs['upi_id'] = _upiController.text.trim();

    final body = {'zone_id': _rider['zone_id'], 'preferences': updatedPrefs};

    try {
      await ApiService.updateMe(body);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Preferences securely saved.',
              style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save preferences. Retry later.'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Skeletonizer(
        enabled: _isLoading,
        effect: ShimmerEffect(
          baseColor: context.colors.surfaceContainerHigh,
          highlightColor: context.colors.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          duration: const Duration(milliseconds: 1200),
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        child: Stack(
          children: [
            CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: ProfileAppBar()),
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 24,
                    bottom: 200, // Padding for Save button & Bottom Nav
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (_rider.isNotEmpty)
                        UserInfoCard(rider: _rider)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.05, curve: Curves.easeOutQuad),

                      const SizedBox(height: 24),
                      if (_rider.isNotEmpty)
                        ZoneSelectionCard(
                              rider: _rider,
                              zones: _zones,
                              isLocked: _hasActivePolicy,
                              onZoneChanged: (newZoneId) {
                                setState(() {
                                  _rider['zone_id'] = newZoneId;
                                  _rider['zone_name'] = _zones.firstWhere(
                                    (z) => z['id'] == newZoneId,
                                  )['name'];
                                });
                              },
                            )
                            .animate(delay: 50.ms)
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.05, curve: Curves.easeOutQuad),

                      const SizedBox(height: 24),
                      if (_preferences.isNotEmpty)
                        PreferencesCard(
                              preferences: _preferences,
                              upiController: _upiController,
                              onShiftChanged: (shift) {
                                setState(
                                  () =>
                                      _preferences['shift_preference'] = shift,
                                );
                              },
                              onPayoutChanged: (payout) {
                                setState(
                                  () => _preferences['payout_preference'] =
                                      payout,
                                );
                              },
                            )
                            .animate(delay: 100.ms)
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.05, curve: Curves.easeOutQuad),

                      const SizedBox(height: 24),
                      if (_baselines.isNotEmpty)
                        BaselineEarningsCard(baselines: _baselines)
                            .animate(delay: 150.ms)
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.05, curve: Curves.easeOutQuad),
                    ]),
                  ),
                ),
              ],
            ),

            // Save Changes CTA
            Positioned(
              bottom: 120, // Sit significantly above the global nav bar shadow
              left: 24,
              right: 24,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isLoading ? 0.0 : 1.0,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.colors.primary,
                            context.colors.primaryContainer,
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: _isSaving
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: context.colors.onPrimaryFixed,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'SAVE CHANGES',
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      color: context.colors.onPrimaryFixed,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: context.colors.onPrimaryFixed,
                                    size: 20,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
