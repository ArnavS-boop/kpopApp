import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antipattern/theme/app_theme.dart';
import 'package:antipattern/models/photocards.dart';
import 'glass_container.dart';

class OrderItemCard extends StatelessWidget {
  final Listings item;

  const OrderItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final tokens = appTokens(context);
    final colorScheme = Theme.of(context).colorScheme;

    final textPrimary = colorScheme.onSurface;
    final textSecondary = colorScheme.onSurface.withOpacity(0.65);

    /// TEMP status logic (replace later with real order model)
    final status = _mockStatus(item.id);

    final statusColor = _statusColor(status, colorScheme);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(20),
        padding: EdgeInsets.zero,
        showShadow: true,
        child: SizedBox(
          height: 170,
          child: Row(
            children: [

              /// LEFT TEXT CONTENT
              Expanded(
                flex: 6,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// TITLE
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

                      /// PRICE
                      Text(
                        "\$${item.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// SELLER
                      Text(
                        "Seller: ${item.sellerName}",
                        style: TextStyle(
                          fontSize: 12.5,
                          color: textSecondary,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// STATUS BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: statusColor.withOpacity(0.15),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),

                      const Spacer(),

                      /// TRACK ORDER BUTTON
                      GestureDetector(
                        onTap: () {
                          context.push(
                            "/track/${item.id}",
                            extra: item,
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_shipping_rounded,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Track order",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// RIGHT IMAGE
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AspectRatio(
                      aspectRatio: 0.62,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          color: tokens.placeholder,
                          child: Image.network(
                            item.imageUrls.first,
                            fit: BoxFit.cover,
                            loadingBuilder:
                                (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.2),
                                ),
                              );
                            },
                            errorBuilder:
                                (_, __, ___) => Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                size: 28,
                                color: colorScheme.onSurface
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
    );
  }

  /// TEMP mock status
  String _mockStatus(String id) {
    final index = id.hashCode % 4;
    switch (index) {
      case 0:
        return "Processing";
      case 1:
        return "Shipped";
      case 2:
        return "Out for delivery";
      default:
        return "Delivered";
    }
  }

  Color _statusColor(String status, ColorScheme scheme) {
    switch (status) {
      case "Processing":
        return Colors.orange;
      case "Shipped":
        return Colors.blue;
      case "Out for delivery":
        return Colors.purple;
      case "Delivered":
        return Colors.green;
      default:
        return scheme.primary;
    }
  }
}