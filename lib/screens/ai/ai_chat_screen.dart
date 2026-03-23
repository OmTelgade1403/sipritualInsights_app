import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Namaste. I am Sarthi, your spiritual companion. How can I assist you on your journey today?',
      'isUser': false,
    },
  ];

  void _handleSend() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _controller.text,
        'isUser': true,
      });
    });

    final userQuery = _controller.text.toLowerCase();
    _controller.clear();

    // Sarthi's Spiritual Response Logic
    Future.delayed(const Duration(seconds: 1), () {
      String response = "That is a deep reflection. Silence often holds the answers we seek.";
      
      if (userQuery.contains('meditation')) {
        response = "Meditation is the art of doing nothing. It is finding the center of your own storm.";
      } else if (userQuery.contains('mantra')) {
        response = "A mantra is like a seed. Plant it in your heart with devotion, and it will grow into peace.";
      } else if (userQuery.contains('peace')) {
        response = "Inner peace begins the moment you choose not to allow another person or event to control your emotions.";
      } else if (userQuery.contains('hanuman')) {
        response = "Lord Hanuman is the embodiment of 'Bhakti' (devotion) and 'Shakti' (power). Meditating on his strength brings courage.";
      } else if (userQuery.contains('sarthi')) {
        response = "I am Sarthi, here to light the lamp of wisdom in your heart.";
      }

      if (mounted) {
        setState(() {
          _messages.add({
            'text': response,
            'isUser': false,
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Column(
          children: [
            Text('Sarthi', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.gold)),
            Text('Your Spiritual Guide', style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w400)),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryDark.withOpacity(0.5),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _ChatBubble(
                  text: msg['text'],
                  isUser: msg['isUser'],
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: TextField(
                  controller: _controller,
                  style: GoogleFonts.outfit(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Seek guidance...',
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                  ),
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.gradientScore,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.gold.withOpacity(0.3), blurRadius: 10, spreadRadius: 2),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                onPressed: _handleSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const _ChatBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          gradient: isUser 
            ? AppColors.gradientPurple 
            : LinearGradient(
                colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(24),
            topRight: const Radius.circular(24),
            bottomLeft: Radius.circular(isUser ? 24 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 24),
          ),
          border: Border.all(color: Colors.white.withOpacity(isUser ? 0.2 : 0.05)),
          boxShadow: [
            if (isUser)
              BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('Sarthi', style: GoogleFonts.outfit(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.bold)),
              ),
            Text(
              text,
              style: GoogleFonts.outfit(
                color: Colors.white.withOpacity(0.95),
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
