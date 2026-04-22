import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'New Story Added! 📖',
        'desc': 'Discover "The Wisdom of Ganesha" in the Animated Stories section.',
        'time': '2 hours ago',
        'icon': Icons.auto_stories_rounded,
        'color': Colors.purple,
      },
      {
        'title': 'Evening Prayer Reminder 🙏',
        'desc': 'It\'s time for your daily evening Aarti. Stay blessed.',
        'time': '5 hours ago',
        'icon': Icons.notifications_active_rounded,
        'color': Colors.orange,
      },
      {
        'title': 'Achievement Unlocked! 🏆',
        'desc': 'You completed 108 Jap chants today. Great progress!',
        'time': 'Yesterday',
        'icon': Icons.star_rounded,
        'color': Colors.amber,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Updates & Alerts', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final note = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (note['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(note['icon'] as IconData, color: note['color'] as Color),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note['title'] as String,
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        note['desc'] as String,
                        style: GoogleFonts.outfit(fontSize: 13, color: Colors.white60),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note['time'] as String,
                        style: GoogleFonts.outfit(fontSize: 11, color: Colors.white24, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
