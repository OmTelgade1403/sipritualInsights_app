import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../providers/app_providers.dart';

/// Profile screen showing user info, stats, achievements, and activity history.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final gamification = ref.read(gamificationServiceProvider);

    return Scaffold(
      body: SafeArea(
        child: userAsync.when(
          data: (user) {
            if (user == null) {
              return const Center(child: Text('Not signed in'));
            }

            final levelName = LevelThresholds.getLevelName(user.score);
            final levelProgress = gamification.getLevelProgress(user.score);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ─── Profile Header ────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile',
                        style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        onPressed: () => context.push('/settings'),
                        icon: const Icon(Icons.settings_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Avatar & name
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                    backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                    child: user.photoUrl == null
                        ? Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                            style: GoogleFonts.outfit(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  if (user.category != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${UserCategory.icons[user.category] ?? ''} ${user.category}',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Edit profile button
                  OutlinedButton.icon(
                    onPressed: () => context.push('/edit-profile'),
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('Edit Profile'),
                  ),
                  const SizedBox(height: 28),

                  // ─── Stats Cards ───────────────────────────────────
                  Row(
                    children: [
                      _ProfileStat(label: 'Score', value: '${user.score}', icon: Icons.stars_rounded, color: AppColors.secondary),
                      const SizedBox(width: 12),
                      _ProfileStat(label: 'Streak', value: '${user.streak}', icon: Icons.local_fire_department_rounded, color: AppColors.error),
                      const SizedBox(width: 12),
                      _ProfileStat(label: 'Level', value: levelName, icon: Icons.emoji_events_rounded, color: AppColors.accent),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Level progress
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Level Progress', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600)),
                            Text('$levelName → ${LevelThresholds.getLevelName(LevelThresholds.getNextLevelScore(user.score))}',
                              style: GoogleFonts.outfit(fontSize: 13, color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: levelProgress,
                            minHeight: 10,
                            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(levelProgress * 100).toStringAsFixed(0)}% to next level',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ─── Achievements ──────────────────────────────────
                  _SectionHeader(title: 'Achievements'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: Badges.all.map((badge) {
                      final earned = user.badges.contains(badge.id);
                      return Container(
                        width: (MediaQuery.of(context).size.width - 64) / 2,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: earned
                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
                              : Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: earned
                                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                                : Colors.grey.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(badge.icon, style: TextStyle(fontSize: 28, color: earned ? null : Colors.grey)),
                            const SizedBox(height: 8),
                            Text(
                              badge.name,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: earned ? null : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              badge.description,
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: earned ? 0.5 : 0.3),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // ─── Goals ─────────────────────────────────────────
                  if (user.goals.isNotEmpty) ...[
                    _SectionHeader(title: 'My Goals'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user.goals.map((goal) => Chip(
                        avatar: Text(GoalOptions.icons[goal] ?? '✨', style: const TextStyle(fontSize: 16)),
                        label: Text(goal, style: GoogleFonts.outfit(fontWeight: FontWeight.w500)),
                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                        side: BorderSide.none,
                      )).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ProfileStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(label, style: GoogleFonts.outfit(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title, 
        style: GoogleFonts.playfairDisplay(
          fontSize: 22, 
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

