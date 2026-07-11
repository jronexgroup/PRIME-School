import 'dart:math';
import 'package:flutter/material.dart';

class RewardAnimation extends StatefulWidget {
  final Widget child;
  final bool showAnimation;

  const RewardAnimation({super.key, required this.child, this.showAnimation = false});

  @override
  State<RewardAnimation> createState() => _RewardAnimationState();
}

class _RewardAnimationState extends State<RewardAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  final List<_Particle> _particles = [];
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    if (widget.showAnimation) {
      _controller.forward();
      for (int i = 0; i < 12; i++) {
        _particles.add(_Particle(
          dx: _random.nextDouble() * 200 - 100,
          dy: _random.nextDouble() * 200 - 100,
          rotation: _random.nextDouble() * 2 * pi,
          color: _random.nextBool() ? const Color(0xFFF59E0B) : const Color(0xFF6366F1),
          size: _random.nextDouble() * 8 + 4,
          delay: _random.nextDouble() * 0.5,
        ));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Transform.scale(
              scale: _scale.value,
              child: widget.child,
            ),
            ..._particles.map((p) {
              final progress = (_controller.value - p.delay).clamp(0.0, 1.0);
              if (progress <= 0) return const SizedBox.shrink();
              return Positioned(
                left: 100 + p.dx * progress,
                top: 100 + p.dy * progress,
                child: Opacity(
                  opacity: 1 - progress,
                  child: Transform.rotate(
                    angle: p.rotation * progress,
                    child: Container(
                      width: p.size,
                      height: p.size,
                      decoration: BoxDecoration(
                        color: p.color,
                        borderRadius: BorderRadius.circular(p.size / 2),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _Particle {
  final double dx, dy, rotation, size, delay;
  final Color color;
  _Particle({required this.dx, required this.dy, required this.rotation, required this.color, required this.size, required this.delay});
}
