import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class AnimatedStoriesScreen extends StatelessWidget {
  const AnimatedStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> stories = [
      {
        'title': 'Krishna & The Butter',
        'desc': 'The mischievous little Krishna steals butter from the pots!',
        'image': 'https://images.unsplash.com/photo-1599488615731-7e5c2e23fd26?w=500&auto=format',
        'color': Colors.orange.shade100,
        'content': 'Once upon a time, in the beautiful village of Vrindavan, lived a playful little boy named Krishna. Krishna loved butter more than anything else in the world!\n\nHis mother, Yashoda, would keep the fresh butter in pots high up from the ceiling. But little Krishna was very clever. He would call his friends and make a human pyramid to reach the pots!'
      },
      {
        'title': 'Mighty Hanuman',
        'desc': 'Little Hanuman flies to the sun thinking it\'s a giant fruit!',
        'image': 'https://images.unsplash.com/photo-1620055375842-16786aa6396e?w=500&auto=format',
        'color': Colors.red.shade100,
        'content': 'One morning, baby Hanuman woke up very hungry. He looked into the sky and saw a big, glowing orange thing. He thought it was a giant, delicious mango!\n\nWith his magical powers, he leaped into the air and started flying towards the sun. He was so strong and fast that even the gods were amazed!'
      },
      {
        'title': 'Ganesha\'s Wisdom',
        'desc': 'How Ganesha won the divine race with his intelligence.',
        'image': 'https://images.unsplash.com/photo-1567591414240-e0906fc00171?w=500&auto=format',
        'color': Colors.blue.shade100,
        'content': 'Kartikeya and Ganesha were asked to race around the world. Kartikeya jumped on his peacock and flew away quickly.\n\nBut Ganesha simply walked around his parents, Shiva and Parvati. He said, "My parents are my whole world." His wisdom touched everyone\'s hearts!'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Animated Stories', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return GestureDetector(
            onTap: () => _showStoryDetail(context, story),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      story['image'] as String,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100,
                        height: 100,
                        color: (story['color'] as Color).withValues(alpha: 0.3),
                        child: const Icon(Icons.palette_rounded, color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story['title'] as String,
                          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          story['desc'] as String,
                          style: GoogleFonts.outfit(fontSize: 14, color: Colors.white60),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showStoryDetail(BuildContext context, Map<String, dynamic> story) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Color(0xFFFFF8E1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.brown.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(story['title'] as String, textAlign: TextAlign.center, style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.brown.shade800)),
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.network(
                        story['image'] as String, 
                        height: 250, 
                        width: double.infinity, 
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 250,
                          width: double.infinity,
                          color: (story['color'] as Color).withValues(alpha: 0.3),
                          child: const Icon(Icons.auto_awesome, size: 80, color: Colors.orange),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      story['content'] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(fontSize: 19, height: 1.6, color: Colors.brown.shade700),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      ),
                      child: const Text('Back to Stories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
