import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antipattern/theme/app_theme.dart';
import 'package:antipattern/models/photocards.dart';
import 'glass_container.dart';

class WishlistItemCard extends StatelessWidget {
  final Listings item;

  const WishlistItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final tokens = appTokens(context);
    final colorScheme = Theme.of(context).colorScheme;

    final textPrimary = colorScheme.onSurface;
    final textSecondary = colorScheme.onSurface.withOpacity(0.65);

    return GestureDetector(
      onTap: () {
        context.push(
          "/product/${item.id}",
          extra: item,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GlassContainer(
          borderRadius: BorderRadius.circular(20),
          padding: EdgeInsets.zero,
          tint: null,           // ❄ neutral surface
          showShadow: true,     // default neutral elevation shadow
          child: SizedBox(
            height: 140,
            child: Row(
              children: [
                // LEFT TEXT CONTENT
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "\$${item.price}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "${item.sellerName} • ⭐4",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: textSecondary,
                          ),
                        ),

                        const Spacer(),

                        GestureDetector(
                          onTap: () {
                            // remove from wishlist later
                          },
                          child: Text(
                            "Remove",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.error,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // RIGHT IMAGE
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AspectRatio(
                        aspectRatio: 0.62,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(16),
                          child: Container(
                            color: tokens.placeholder,
                            child: Image.network(
                              item.imageUrls.first,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, progress) {
                                if (progress == null) {
                                  return child;
                                }
                                return const Center(
                                  child: SizedBox(
                                    width: 26,
                                    height: 26,
                                    child:
                                        CircularProgressIndicator(
                                            strokeWidth: 2.2),
                                  ),
                                );
                              },
                              errorBuilder:
                                  (_, __, ___) => Center(
                                child: Icon(
                                  Icons
                                      .broken_image_rounded,
                                  size: 28,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.35),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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