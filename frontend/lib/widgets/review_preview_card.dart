import 'dart:ui';
import 'package:antipattern/models/reviews.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'glass_container.dart';

class ReviewPreviewCard extends StatefulWidget {
  final List<Review> reviews;
  final int totalCount;

  const ReviewPreviewCard({
    super.key,
    required this.reviews,
    required this.totalCount,
  });

  @override
  State<ReviewPreviewCard> createState() => _ReviewPreviewCardState();
}

class _ReviewPreviewCardState extends State<ReviewPreviewCard> {
  bool expandedPreview = false;
  final Map<int, bool> expandedReview = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final neonIce =
        isDark ? const Color(0xFF99EDFF) : const Color(0xFF62DFFF);

    final shadowColor = isDark
        ? Colors.blueGrey.withOpacity(0.28)
        : Colors.blue.withOpacity(0.18);

    final textPrimary = isDark
        ? Colors.white.withOpacity(0.95)
        : Colors.black.withOpacity(0.90);

    final textSecondary = isDark
        ? Colors.white.withOpacity(0.65)
        : Colors.black.withOpacity(0.60);

    final firstThree = widget.reviews.take(3).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: GlassContainer(
            borderRadius: BorderRadius.circular(22),
            padding: const EdgeInsets.all(18),

            // Neutral ice surface
            tint: null,

            // Cool blue shadow
            shadowOverride: shadowColor,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                GestureDetector(
                  onTap: () =>
                      context.push("/reviews", extra: widget.reviews),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reviews",
                        style: TextStyle(
                          fontSize: 20,
                          color: textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: neonIce,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                ..._buildPreviewList(
                  firstThree,
                  context,
                  textPrimary,
                  textSecondary,
                  neonIce,
                ),

                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () =>
                      context.push("/reviews", extra: widget.reviews),
                  child: Text(
                    "View more reviews (${widget.totalCount})",
                    style: TextStyle(
                      fontSize: 14,
                      color: neonIce,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // PREVIEW VS EXPANDED
  // ------------------------------------------------------------------
  List<Widget> _buildPreviewList(
    List<Review> items,
    BuildContext context,
    Color textPrimary,
    Color textSec,
    Color neon,
  ) {
    final reviewList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        items.length,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildSingleReview(
            items[i],
            i,
            textPrimary,
            textSec,
            neon,
            previewMode: !expandedPreview,
          ),
        ),
      ),
    );

    if (expandedPreview) return [reviewList];

    return [
      GestureDetector(
        onTap: () => setState(() => expandedPreview = true),
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.black,
                Colors.transparent,
              ],
              stops: [0.0, 0.65, 1.0],
            ).createShader(bounds);
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 170),
            child: SingleChildScrollView(
              physics:
                  const NeverScrollableScrollPhysics(),
              child: reviewList,
            ),
          ),
        ),
      ),
    ];
  }

  // ------------------------------------------------------------------
  // SINGLE REVIEW
  // ------------------------------------------------------------------
  Widget _buildSingleReview(
    Review r,
    int index,
    Color primary,
    Color secondary,
    Color neon, {
    required bool previewMode,
  }) {
    final isExpanded = expandedReview[index] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () =>
              context.push("/buyer/${r.username}"),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage:
                    NetworkImage(r.avatar),
              ),
              const SizedBox(width: 8),
              Text(
                r.username,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
              if (r.verifiedPurchase)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.verified_rounded,
                    size: 14,
                    color: neon,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        Row(
          children: List.generate(
            5,
            (i) => Icon(
              i < r.stars
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              size: 16,
              color: neon,
            ),
          ),
        ),

        const SizedBox(height: 6),

        GestureDetector(
          onTap: () => setState(() =>
              expandedReview[index] = !isExpanded),
          child: AnimatedCrossFade(
            duration:
                const Duration(milliseconds: 200),
            firstChild: _truncateText(
              r.text,
              primary,
              maxLines: previewMode ? 3 : 4,
            ),
            secondChild: Text(
              r.text,
              style: TextStyle(color: primary),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ),
      ],
    );
  }

  Widget _truncateText(
    String text,
    Color color, {
    int maxLines = 3,
  }) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color),
    );
  }
}