import 'dart:ui';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class ReviewFiltersBar extends StatelessWidget {
  final int? selectedStars;
  final ValueChanged<int?> onChanged;

  const ReviewFiltersBar({
    super.key,
    required this.selectedStars,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final neon = isDark
        ? const Color(0xFF99EDFF)
        : const Color(0xFF62DFFF);

    final text = isDark
        ? Colors.white.withOpacity(0.9)
        : Colors.black.withOpacity(0.9);

   return ClipRRect(
  borderRadius: BorderRadius.circular(18),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
    child: GlassContainer(
      borderRadius: BorderRadius.circular(18),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

      // ❄ Neutral ice surface
      tint: null,

      // ❄ Cool shadow like original system
      shadowOverride: isDark
          ? Colors.blueGrey.withOpacity(0.28)
          : Colors.blue.withOpacity(0.18),

      child: Row(
        children: [
          _chip(context, "All", null, neon, text),
          ...List.generate(
            5,
            (i) => _chip(context, "${5 - i}★", 5 - i, neon, text),
          ),
        ],
      ),
    ),
  ),
);
  }

  Widget _chip(
    BuildContext context,
    String label,
    int? value,
    Color neon,
    Color text,
  ) {
    final selected = selectedStars == value;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? neon.withOpacity(0.22) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? neon : text.withOpacity(0.35),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: text,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
