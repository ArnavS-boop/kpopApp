import 'package:flutter/material.dart';
import 'package:antipattern/models/sellers.dart';
import 'package:antipattern/theme/app_theme.dart';
import 'glass_container.dart';

class SellerHeader extends StatefulWidget {
  final Seller seller;

  const SellerHeader({super.key, required this.seller});

  @override
  State<SellerHeader> createState() => _SellerHeaderState();
}

class _SellerHeaderState extends State<SellerHeader> {
  bool bioExpanded = false;

  @override
  Widget build(BuildContext context) {
    final seller = widget.seller;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tokens = appTokens(context);
    final colorScheme = theme.colorScheme;

    final textPrimary = colorScheme.onSurface;
    final textSecondary = colorScheme.onSurface.withOpacity(0.60);
    final accent = colorScheme.secondary;

    // 🌸 SAME warm glow used in SellerShowcase
    final warmShadow = isDark
        ? const Color(0xFFB388FF).withOpacity(0.28)   // soft violet
        : const Color(0xFFFFB74D).withOpacity(0.22);  // soft amber

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------- BANNER + FLOATING AVATAR ----------------
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 180,
              width: double.infinity,
              child: seller.bannerImage != null
                  ? Image.network(seller.bannerImage!, fit: BoxFit.cover)
                  : Container(color: tokens.placeholder),
            ),

            // Floating avatar with warm glow ring
            Positioned(
              bottom: -45,
              left: 20,
              child: GlassContainer(
                borderRadius: BorderRadius.circular(100),
                padding: const EdgeInsets.all(3),
                tint: null,
                shadowOverride: warmShadow,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: seller.profileImage.isNotEmpty
                      ? NetworkImage(seller.profileImage)
                      : null,
                  backgroundColor: Colors.transparent,
                  child: seller.profileImage.isEmpty
                      ? Text(
                          seller.username[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 30,
                            color: textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 60),

        // ---------------- SELLER GLASS CARD ----------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GlassContainer(
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.all(18),
              tint: null,
              shadowOverride: warmShadow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME + RATING
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          seller.username,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: accent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            seller.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // BIO
                  GestureDetector(
                    onTap: () =>
                        setState(() => bioExpanded = !bioExpanded),
                    child: AnimatedCrossFade(
                      duration:
                          const Duration(milliseconds: 240),
                      crossFadeState: bioExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: Text(
                        seller.bio,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.45,
                          color: textSecondary,
                        ),
                      ),
                      secondChild: Text(
                        seller.bio,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.45,
                          color: textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}