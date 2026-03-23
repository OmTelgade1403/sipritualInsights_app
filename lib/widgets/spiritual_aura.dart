import 'dart:math';
import 'package:flutter/material.dart';
import '../config/theme.dart';

class SpiritualAura extends StatefulWidget {
  final Widget child;
  final bool showParticles;

  const SpiritualAura({
    super.key,
    required this.child,
    this.showParticles = true,
  });

  @override
  State<SpiritualAura> createState() => _SpiritualAuraState();
}

class _SpiritualAuraState extends State<SpiritualAura>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = List.generate(25, (_) => _Particle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Aura Gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.gradientAura,
            ),
          ),
        ),

        // Floating Particles
        if (widget.showParticles)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ParticlePainter(_particles, _controller.value),
                );
              },
            ),
          ),

        // Screen Content
        Positioned.fill(child: widget.child),
      ],
    );
  }
}

class _Particle {
  late double x;
  late double y;
  late double size;
  late double speed;
  late double opacity;

  _Particle() {
    _reset();
  }

  void _reset() {
    x = Random().nextDouble();
    y = Random().nextDouble();
    size = Random().nextDouble() * 3 + 1;
    speed = Random().nextDouble() * 0.1 + 0.05;
    opacity = Random().nextDouble() * 0.3 + 0.1;
  }

  void move() {
    y -= speed * 0.01;
    if (y < -0.1) {
      y = 1.1;
      x = Random().nextDouble();
    }
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double animationValue;

  _ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var particle in particles) {
      particle.move();
      final pos = Offset(particle.x * size.width, particle.y * size.height);
      paint.color = Colors.white.withValues(alpha: particle.opacity);
      canvas.drawCircle(pos, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
