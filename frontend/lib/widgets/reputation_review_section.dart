import 'dart:ui';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:antipattern/models/reviews.dart';

class ReputationReviewSection extends StatefulWidget {
  final RatingSummary summary;
  final List<Review> reviews;

  const ReputationReviewSection({
    super.key,
    required this.summary,
    required this.reviews,
  });

  @override
  State<ReputationReviewSection> createState() =>
      _ReputationReviewSectionState();
}

class _ReputationReviewSectionState extends State<ReputationReviewSection> {
  bool showAdvanced = false;

  @override
  Widget build(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  // Blue ice tint
  const iceTint = Color(0xFF62DFFF);

  final neonIce = isDark
      ? const Color(0xFF99EDFF)
      : iceTint;

  final textPrimary = isDark
      ? Colors.white.withOpacity(0.95)
      : Colors.black.withOpacity(0.90);

  final textSecondary = isDark
      ? Colors.white.withOpacity(0.65)
      : Colors.black.withOpacity(0.60);

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
        child: GlassContainer(
            borderRadius: BorderRadius.circular(24),
            padding: const EdgeInsets.all(20),

            // NO tint (keeps white ice)
            tint: null,

            // ✅ Custom cool shadow like original
            shadowOverride: isDark
                ? Colors.blueGrey.withOpacity(0.28)
                : Colors.blue.withOpacity(0.18),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(textPrimary, textSecondary, neonIce),
                const SizedBox(height: 20),
                _distributionChart(textPrimary, textSecondary, neonIce),
                const SizedBox(height: 14),
                _toggle(textPrimary),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 240),
                  firstChild: const SizedBox.shrink(),
                  secondChild: _breakdown(textPrimary, textSecondary),
                  crossFadeState:
                      showAdvanced
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                ),
              ],
            ),
          ),
      ),
    ),
  );
}
  // ---------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------
  Widget _header(Color primary, Color secondary, Color neon) {
    return Row(
      children: [
        Text(
          widget.summary.weightedAverage.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.w700,
            color: primary,
            height: 0.9,
          ),
        ),
        const SizedBox(width: 14),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  i < widget.summary.weightedAverage
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: neon,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text("Sybil-safe rating", style: TextStyle(color: secondary)),
          ],
        )
      ],
    );
  }

  // ---------------------------------------------------------
  // BAR DISTRIBUTION
  // ---------------------------------------------------------
  Widget _distributionChart(Color primary, Color secondary, Color neon) {
    final total = widget.summary.distribution.values.fold(0, (a, b) => a + b);

    return Column(
      children: List.generate(5, (i) {
        final stars = 5 - i;
        final count = widget.summary.distribution[stars] ?? 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(width: 32, child: Text("$stars★", style: TextStyle(color: secondary))),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : count / total,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.14),
                    valueColor: AlwaysStoppedAnimation(neon),
                  ),
                ),
              ),

              const SizedBox(width: 10),
              Text("$count", style: TextStyle(color: primary)),
            ],
          ),
        );
      }),
    );
  }

  // ---------------------------------------------------------
  // TOGGLE
  // ---------------------------------------------------------
  Widget _toggle(Color primary) {
    return GestureDetector(
      onTap: () => setState(() => showAdvanced = !showAdvanced),
      child: Row(
        children: [
          Icon(
            showAdvanced
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: primary,
            size: 24,
          ),
          Text(
            showAdvanced ? "Hide breakdown" : "Show breakdown",
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // BREAKDOWN PANEL
  // ---------------------------------------------------------
Widget _breakdown(Color primary, Color secondary) {
  return Padding(
    padding: const EdgeInsets.only(top: 16),
    child: GlassContainer(
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      showShadow: false, // nested glass should not float
      tint: const Color(0xFF62DFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _kv("Raw average",
              widget.summary.rawAverage.toStringAsFixed(2),
              primary,
              secondary),
          _kv("Weighted average",
              widget.summary.weightedAverage.toStringAsFixed(2),
              primary,
              secondary),
          const SizedBox(height: 12),
          Text("Factors",
              style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _factor("Verified purchases", secondary),
          _factor("Reviewer reliability", secondary),
          _factor("Vaeld trust scores", secondary),
          _factor("Anti-sybil modeling", secondary),
        ],
      ),
    ),
  );
}
  Widget _kv(String key, String val, Color primary, Color secondary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: TextStyle(color: secondary)),
          Text(val, style: TextStyle(color: primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _factor(String text, Color secondary) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text("• $text", style: TextStyle(color: secondary, fontSize: 14)),
    );
  }
}
