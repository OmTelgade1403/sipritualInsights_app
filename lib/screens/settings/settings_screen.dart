import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../providers/app_providers.dart';

/// Settings screen with theme toggle and account options.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Settings', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Appearance
          _SectionLabel(label: 'Appearance'),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.dark_mode_rounded,
            title: 'Dark Mode',
            trailing: Switch(
              value: isDark,
              onChanged: (v) => ref.read(isDarkModeProvider.notifier).state = v,
              activeTrackColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),

          // Account
          _SectionLabel(label: 'Account'),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.person_outlined,
            title: 'Edit Profile',
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/edit-profile'),
          ),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.notification_important_outlined,
            title: 'Test Notification',
            trailing: Icon(Icons.play_circle_outline, color: Theme.of(context).colorScheme.primary),
            onTap: () async {
              await ref.read(alarmServiceProvider).showNotification(
                id: 999,
                title: '✨ Spiritual Insight',
                body: 'Your journey to inner peace continues. Take a moment to breathe.',
              );
            },
          ),
          _SettingsTile(
            icon: Icons.language_rounded,
            title: 'Language',
            trailing: Text('English', style: GoogleFonts.outfit(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            )),
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // About
          _SectionLabel(label: 'About'),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.info_outlined,
            title: 'About Spiritual Insights',
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Spiritual Insights',
                applicationVersion: '1.0.0',
                applicationIcon: Icon(Icons.self_improvement_rounded,
                    size: 48, color: Theme.of(context).colorScheme.primary),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          const SizedBox(height: 32),

          // Sign out
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              label: Text('Sign Out',
                  style: GoogleFonts.outfit(color: AppColors.error, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Version 1.0.0',
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: GoogleFonts.outfit(
      fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5,
      color: Theme.of(context).colorScheme.primary,
    ));
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: GoogleFonts.outfit(fontSize: 16))),
            trailing,
          ],
        ),
      ),
    );
  }
}
