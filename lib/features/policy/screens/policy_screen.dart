import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_animate/flutter_animate.dart' hide ShimmerEffect;
import '../../../theme/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../data/policy_mock_data.dart';
import '../widgets/policy_app_bar.dart';
import '../widgets/current_policy_card.dart';
import '../widgets/policy_history_list.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _currentPolicy = {};
  List<dynamic> _policyHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchPolicyData();
  }

  Future<void> _fetchPolicyData() async {
    setState(() => _isLoading = true);
    try {
      final currentRes = await ApiService.getCurrentPolicy();
      final historyRes = await ApiService.getPolicyHistory();

      setState(() {
        _currentPolicy = currentRes['current_policy'] as Map<String, dynamic>? ?? {};
        _policyHistory = historyRes['policies'] as List<dynamic>? ?? [];
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('>>> POLICY FETCH ERROR: $e');
      setState(() {
        _currentPolicy = mockCurrentPolicy['current_policy'];
        _policyHistory = mockPolicyHistory['policies'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: RefreshIndicator(
        color: context.colors.primary,
        onRefresh: _fetchPolicyData,
        child: Skeletonizer(
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
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const PolicyAppBar(),
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: 160, // Padding for global bottom nav
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (_currentPolicy.isNotEmpty)
                      CurrentPolicyCard(policy: _currentPolicy)
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.05, curve: Curves.easeOutQuad),
                    const SizedBox(height: 48),
                    if (_policyHistory.isNotEmpty)
                      PolicyHistoryList(policies: _policyHistory)
                          .animate(delay: 100.ms)
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.05, curve: Curves.easeOutQuad),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
