import 'package:flutter/material.dart';
import 'glass_container.dart';

class GlassCircleIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const GlassCircleIcon({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  State<GlassCircleIcon> createState() => GlassCircleIconState();
}

class GlassCircleIconState extends State<GlassCircleIcon> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Listener(
      onPointerDown: (_) => setState(() => _scale = 0.92),
      onPointerUp: (_) => setState(() => _scale = 1.0),
      onPointerCancel: (_) => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: GestureDetector(
          onTap: widget.onTap,
          child: GlassContainer(
            showShadow: false, // 👈 usually better for small icons
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 42,
              width: 42,
              child: Center(
                child: Icon(
                  widget.icon,
                  color: theme.colorScheme.onSurface,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}