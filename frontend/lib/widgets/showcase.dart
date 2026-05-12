import 'package:flutter/material.dart';
import 'package:antipattern/theme/app_theme.dart';
import 'package:antipattern/models/photocards.dart';
import 'package:antipattern/skeleton/card_skeleton.dart';

class SellerShowcase extends StatelessWidget {
  final Listings listing;

  const SellerShowcase({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 6, child: _SoftInfoCard(listing: listing)),
          const SizedBox(width: 12),
          Expanded(flex: 4, child: ShowcaseCard(listing: listing)),
        ],
      ),
    );
  }
}

//
// =======================================================
// LEFT SIDE — EXPANDABLE TEXT (LIKE PRODUCT DETAILS)
// =======================================================
//
class _SoftInfoCard extends StatelessWidget {
  final Listings listing;

  const _SoftInfoCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = appTokens(context);
    final colorScheme = Theme.of(context).colorScheme;

    // ---- Neutral glass palette (same as Showcase theme) ----
    final bg = tokens.glassBackground;
    final border = tokens.glassBorder;
    final textSecondary = colorScheme.onSurface.withOpacity(0.60);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
            colors: [
            bg,
            bg.withOpacity(isDark ? 0.05 : 0.25),
          ],
        ),
        border: Border.all(width: 1.1, color: border),
        boxShadow: [
            BoxShadow(
            color: tokens.glassShadow,
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label("Name", textSecondary),
          _ExpandableText(listing.title),

          _divider(textSecondary),

          _label("Description", textSecondary),
          _ExpandableText(listing.description),

          _divider(textSecondary),

          _label("Group", textSecondary),
          _ExpandableText(listing.group ?? "Unknown"),

          _divider(textSecondary),

          _label("Tags", textSecondary),
          _ExpandableText((listing.tags).join(", ")),
        ],
      ),
    );
  }

  Widget _label(String t, Color c) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          t,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: c,
          ),
        ),
      );

  Widget _divider(Color textSecondary) => Container(
        height: 1,
        margin: const EdgeInsets.only(bottom: 10, top: 8),
        color: textSecondary.withOpacity(0.25),
      );
}

//
// =======================================================
// EXPANDABLE TEXT USING ANIMATEDCROSSFADE
// (IDENTICAL BEHAVIOR TO PRODUCT DETAILS)
// =======================================================
//

class _ExpandableText extends StatefulWidget {
  final String text;
  const _ExpandableText(this.text);

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => expanded = !expanded),
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 200),
        crossFadeState:
            expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstChild: Text(
          widget.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.80),
            height: 1.32,
          ),
        ),
        secondChild: Text(
          widget.text,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.80),
            height: 1.32,
          ),
        ),
      ),
    );
  }
}

//
// =======================================================
// RIGHT SIDE — CARD WITH INSTANT SKELETON + BOUNCE
// =======================================================
//

class ShowcaseCard extends StatefulWidget {
  final Listings listing;

  const ShowcaseCard({super.key, required this.listing});

  @override
  State<ShowcaseCard> createState() => _ShowcaseCardState();
}

class _ShowcaseCardState extends State<ShowcaseCard>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _shadow;
  late Animation<double> _overlay;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _scale = Tween(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _shadow = Tween(begin: 22.0, end: 6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _overlay = Tween(begin: 0.0, end: 0.10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _pressDown(TapDownDetails _) => _controller.forward();
  void _pressUp([_]) => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final tokens = appTokens(context);

    return GestureDetector(
      onTapDown: _pressDown,
      onTapUp: _pressUp,
      onTapCancel: _pressUp,

      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {

          return Transform.scale(
            scale: _scale.value,

            /// ⭐ AspectRatio MUST wrap everything
            child: AspectRatio(
              aspectRatio: 0.62,

              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: _shadow.value,
                      offset: Offset(0, _shadow.value / 2),
                    ),
                  ],
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),

                  /// Stack is safe NOW because height is fixed
                  child: Stack(
                    children: [

                      /// IMAGE
                      Positioned.fill(
                        child: Image.network(
                          widget.listing.imageUrls.first,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const CardSkeleton();
                          },
                          errorBuilder: (_, __, ___) => Container(
                            color: tokens.placeholder,
                          ),
                        ),
                      ),

                      /// PRESS OVERLAY
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: _overlay.value,
                            child: Container(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}