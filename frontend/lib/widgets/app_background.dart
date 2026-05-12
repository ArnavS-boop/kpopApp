import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final String? backgroundImageUrl;
  final String? overlayColorHex;

  /// NEW: gradient override
  final List<Color>? gradientOverride;

  const AppBackground({
    super.key,
    required this.child,
    this.backgroundImageUrl,
    this.overlayColorHex,
    this.gradientOverride,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    /// 🔹 IMAGE MODE
    if (backgroundImageUrl != null) {
      return Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              backgroundImageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  _buildGradient(brightness),
            ),
          ),
          if (overlayColorHex != null)
            Positioned.fill(
              child: Container(
                color: _hexToColor(overlayColorHex!),
              ),
            ),
          child,
        ],
      );
    }

    /// 🔹 GRADIENT MODE (default or override)
    return _buildGradient(brightness, child: child);
  }

  Widget _buildGradient(Brightness brightness, {Widget? child}) {
    final colors = gradientOverride ??
        (brightness == Brightness.dark
            ? const [Color(0xFF4E2AFF), Color(0xFF0A021A)]
            : const [Color(0xFFFFF4E8), Color(0xFFFFB4DA)]);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: child,
    );
  }

  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) {
      buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
    } else if (hex.length == 9) {
      buffer.write(hex.replaceFirst('#', ''));
    } else {
      return Colors.black.withOpacity(0.4);
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}