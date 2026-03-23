import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../providers/app_providers.dart';
import '../../widgets/spiritual_aura.dart';

/// Main shell with bottom navigation bar wrapping child routes.
class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SpiritualAura(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: child,
        bottomNavigationBar: Container(
          height: 85,
          decoration: const BoxDecoration(
            gradient: AppColors.navGradient,
            border: Border(
              top: BorderSide(color: Colors.white12, width: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: const SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                  path: '/home',
                ),
                _NavItem(
                  icon: Icons.explore_rounded,
                  label: 'Explore',
                  index: 1,
                  path: '/explore',
                ),
                _NavItem(
                  icon: Icons.leaderboard_rounded,
                  label: 'Rankings',
                  index: 2,
                  path: '/leaderboard',
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  index: 3,
                  path: '/profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends ConsumerWidget {
  final IconData icon;
  final String label;
  final int index;
  final String path;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.path,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = ref.watch(bottomNavIndexProvider);
    final isActive = activeIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(bottomNavIndexProvider.notifier).state = index;
          context.go(path);
          HapticFeedback.lightImpact();
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isActive ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isActive ? AppColors.gold : Colors.white.withValues(alpha: 0.6),
                size: 26,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppColors.gold : Colors.white.withValues(alpha: 0.5),
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
