import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool showShadow;
  final Color? tint;
  final Color? shadowOverride;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.padding,
    this.showShadow = true,
    this.tint,
    this.shadowOverride,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color effectiveTint = tint ?? Colors.white;

    final base = isDark
        ? effectiveTint.withOpacity(0.08)
        : effectiveTint.withOpacity(0.45);

    final deeper = isDark
        ? effectiveTint.withOpacity(0.04)
        : effectiveTint.withOpacity(0.28);

    final chromeBorder = isDark
        ? effectiveTint.withOpacity(0.30)
        : effectiveTint.withOpacity(0.55);

    final shadowColor = shadowOverride ??
    (tint != null
        ? effectiveTint.withOpacity(isDark ? 0.28 : 0.18)
        : Colors.black.withOpacity(isDark ? 0.6 : 0.18));

        
    final gloss = isDark
    ? effectiveTint.withOpacity(0.10)
    : effectiveTint.withOpacity(0.20);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 26,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(color: chromeBorder, width: 1.2),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [base, deeper],
          ),
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            children: [
              // Gloss highlight
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 28,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [gloss, Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),

              if (padding != null)
                Padding(
                  padding: padding!,
                  child: child,
                )
              else
                child,
            ],
          ),
        ),
      ),
    );
  }
}