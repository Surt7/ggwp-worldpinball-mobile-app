import 'package:flutter/material.dart';

/// ArcadeLogoTransition:
/// Animates retro neon red "GG !" arcade pulse -> smoothly transitions to the full official "World Pinball" logo.
class ArcadeLogoTransition extends StatefulWidget {
  final double height;
  final VoidCallback? onAnimationComplete;

  const ArcadeLogoTransition({
    super.key,
    this.height = 80,
    this.onAnimationComplete,
  });

  @override
  State<ArcadeLogoTransition> createState() => _ArcadeLogoTransitionState();
}

class _ArcadeLogoTransitionState extends State<ArcadeLogoTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // GG entrance & neon pulse (0.0 -> 0.40)
  late final Animation<double> _ggOpacity;
  late final Animation<double> _ggScale;

  // GG fade-out (0.40 -> 0.65)
  late final Animation<double> _ggFadeOut;

  // World Pinball logo entrance (0.45 -> 1.0)
  late final Animation<double> _worldPinballOpacity;
  late final Animation<double> _worldPinballScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _ggOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.30, curve: Curves.easeOut),
      ),
    );

    _ggScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.40, curve: Curves.easeOutBack),
      ),
    );

    _ggFadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.65, curve: Curves.easeOut),
      ),
    );

    _worldPinballOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.85, curve: Curves.easeInOut),
      ),
    );

    _worldPinballScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.90, curve: Curves.easeOutCubic),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _replay() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _replay,
      child: SizedBox(
        height: widget.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final effectiveGgOpacity =
                (_ggOpacity.value * _ggFadeOut.value).clamp(0.0, 1.0);

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // 1. Retro Red Neon "GG !"
                if (effectiveGgOpacity > 0.01)
                  Opacity(
                    opacity: effectiveGgOpacity,
                    child: Transform.scale(
                      scale: _ggScale.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        child: Text(
                          'GG ! ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: widget.height * 0.68,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 6.0,
                            color: const Color(0xFFFF2A2A),
                            shadows: [
                              Shadow(
                                color: const Color(0xFFE53935).withValues(alpha: 0.95),
                                blurRadius: 28,
                              ),
                              Shadow(
                                color: const Color(0xFFFF1744).withValues(alpha: 0.7),
                                blurRadius: 44,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // 2. Full "World Pinball" Logo
                if (_worldPinballOpacity.value > 0.01)
                  Opacity(
                    opacity: _worldPinballOpacity.value,
                    child: Transform.scale(
                      scale: _worldPinballScale.value,
                      child: Image.asset(
                        'assets/images/logo_world_pinball.png',
                        height: widget.height,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
