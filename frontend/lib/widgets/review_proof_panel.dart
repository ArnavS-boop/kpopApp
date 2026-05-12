import 'dart:ui';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class ReviewProofPanel extends StatelessWidget {
  final bool verifiedPurchase;
  final double reviewerTrust;

  const ReviewProofPanel({
    super.key,
    required this.verifiedPurchase,
    required this.reviewerTrust,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final text = isDark
        ? Colors.white.withOpacity(0.85)
        : Colors.black.withOpacity(0.85);

     return ClipRRect(
  borderRadius: BorderRadius.circular(14),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
    child: GlassContainer(
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.all(12),

      tint: null,

      shadowOverride: isDark
          ? Colors.blueGrey.withOpacity(0.28)
          : Colors.blue.withOpacity(0.18),

      showShadow: false, // small panel shouldn't float

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(
            Icons.verified_rounded,
            verifiedPurchase
                ? "Verified purchase"
                : "Unverified",
            text,
          ),
          const SizedBox(height: 6),
          _row(
            Icons.shield_rounded,
            "Reviewer trust: ${(reviewerTrust * 100).round()}%",
            text,
          ),
        ],
      ),
    ),
  ),
);
  }

  Widget _row(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
