import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antipattern/widgets/glass_container.dart';

class ListingCard extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String? subtitle;
  final double price;

  const ListingCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    this.subtitle,
    required this.price,
  });

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  double _scale = 1.0;

  void _down() => setState(() => _scale = 0.94);
  void _up() => setState(() => _scale = 1.0);

  void _openProduct(BuildContext context) {
    try {
      context.push('/product/${widget.id}');
    } catch (_) {
      try {
        Navigator.of(context).pushNamed('/product/${widget.id}');
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _openProduct(context),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Listener(
          onPointerDown: (_) => _down(),
          onPointerUp: (_) => _up(),
          onPointerCancel: (_) => _up(),
          child: GlassContainer(
            padding: const EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(18),
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,

                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: Colors.grey.shade200,
                        );
                      },

                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.broken_image_rounded,
                            size: 28,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? Colors.white.withOpacity(0.92)
                          : Colors.black.withOpacity(0.88),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                if (widget.subtitle != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white.withOpacity(0.60)
                            : Colors.black.withOpacity(0.55),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                const Spacer(),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '\$${widget.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? const Color(0xFF99EDFF)
                          : const Color(0xFF009A78),
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
}
