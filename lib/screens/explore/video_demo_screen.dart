import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class VideoDemoScreen extends StatelessWidget {
  const VideoDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Kids Animations', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Placeholder
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1CB5E0), Color(0xFF000851)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1599488615731-7e5c2e23fd26?w=800&auto=format',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      color: Colors.black26,
                      colorBlendMode: BlendMode.darken,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.blue.shade900,
                        child: const Icon(Icons.movie_rounded, size: 80, color: Colors.white24),
                      ),
                    ),
                  ),
                  const Icon(Icons.play_circle_fill_rounded, size: 80, color: Colors.white),
                  Positioned(
                    bottom: 20,
                    child: Text(
                      'Little Krishna - The Butter Thief',
                      style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Movie Details', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              'Join Little Krishna in his playful adventures in Vrindavan! In this episode, he outsmarts everyone to reach the butter pots hidden high up.',
              style: GoogleFonts.outfit(fontSize: 15, color: Colors.white60, height: 1.6),
            ),
            const SizedBox(height: 32),
            Text('More for Kids', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildVideoItem('Ganesha\'s Wisdom', 'Episode 12', Colors.orange),
            _buildVideoItem('Hanuman\'s Mighty Leap', 'Episode 05', Colors.red),
            _buildVideoItem('Divine Tales: The Beginning', 'Special Edition', Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoItem(String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.movie_filter_rounded, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                Text(subtitle, style: GoogleFonts.outfit(fontSize: 12, color: Colors.white30)),
              ],
            ),
          ),
          const Icon(Icons.play_arrow_rounded, color: Colors.white24),
        ],
      ),
    );
  }
}
