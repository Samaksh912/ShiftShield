import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'dashboard_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const Center(child: Text('Policy Screen')),
    const Center(child: Text('Claims Screen')),
    const Center(child: Text('Wallet Screen')),
    const Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      extendBody: true, // Need this so scrolling content goes behind nav bar glass
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBarColor = isDark
        ? const Color(0xFF131313).withValues(alpha: 0.8)
        : const Color(0xFFFFFFFF).withValues(alpha: 0.8);
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.5)
        : Colors.black.withValues(alpha: 0.05);

    return Container(
      decoration: BoxDecoration(
        color: navBarColor,
        border: Border(top: BorderSide(color: context.colors.primary.withValues(alpha: 0.1))),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: _FluidNavBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FluidNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FluidNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final itemWidth = totalWidth / 5;

        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            // The moving fluid highlight
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              left: currentIndex * itemWidth,
              child: Container(
                width: itemWidth,
                alignment: Alignment.center,
                child: Container(
                  width: itemWidth * 0.75, // Width of the highlight pill
                  height: 60, // Height to cover icon and text nicely
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            // The actual tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                  width: itemWidth,
                ),
                _NavBarItem(
                  icon: Icons.shield_outlined,
                  activeIcon: Icons.shield,
                  label: 'Policy',
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                  width: itemWidth,
                ),
                _NavBarItem(
                  icon: Icons.description_outlined,
                  activeIcon: Icons.description,
                  label: 'Claims',
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                  width: itemWidth,
                ),
                _NavBarItem(
                  icon: Icons.account_balance_wallet_outlined,
                  activeIcon: Icons.account_balance_wallet,
                  label: 'Wallet',
                  isSelected: currentIndex == 3,
                  onTap: () => onTap(3),
                  width: itemWidth,
                ),
                _NavBarItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  isSelected: currentIndex == 4,
                  onTap: () => onTap(4),
                  width: itemWidth,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double width;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Icon(
              isSelected ? activeIcon : icon,
              size: 24,
              color: isSelected ? context.colors.primary : context.colors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 6),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.spaceGrotesk(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: isSelected ? context.colors.primary : context.colors.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
