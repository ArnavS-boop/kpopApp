import 'package:antipattern/models/photocards.dart';
import 'package:antipattern/models/sellers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsSection extends StatefulWidget {
  final Listings product;

  const ProductDetailsSection({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsSection> createState() => _ProductDetailsSectionState();
}

class _ProductDetailsSectionState extends State<ProductDetailsSection> {
  bool nameExpanded = false;
  bool descExpanded = false;
  bool sellerBioExpanded = false;

  final GlobalKey _descKey = GlobalKey();

  Future<void> _scrollToExpanded() async {
    await Future.delayed(const Duration(milliseconds: 80));
    final ctx = _descKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  Seller? findSeller(String sellerName) {
    try {
      return dummySellers.firstWhere((s) => s.id == sellerName);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final seller = findSeller(product.sellerName);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // -------------------------------
    // Glass colors
    // -------------------------------
    final bg = isDark
        ? Colors.white.withOpacity(0.07)
        : Colors.white.withOpacity(0.65);

    final border = isDark
        ? Colors.white.withOpacity(0.12)
        : Colors.black.withOpacity(0.06);


    final textPrimary = isDark
        ? Colors.white.withOpacity(0.95)
        : Colors.black.withOpacity(0.95);

    final textSecondary = isDark
        ? Colors.white.withOpacity(0.60)
        : Colors.black.withOpacity(0.60);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // ---- Glass background (no blur inside card) ----
            Container(
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
                border: Border.all(color: border, width: 1.1),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.25)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LABELS
                  Row(
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 14,
                          color: textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Price",
                        style: TextStyle(
                          fontSize: 14,
                          color: textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // TITLE + PRICE
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => nameExpanded = !nameExpanded),
                          child: AnimatedCrossFade(
                            duration: const Duration(milliseconds: 200),
                            crossFadeState: nameExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: Text(
                              product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            secondChild: Text(
                              product.title,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "\$${product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 22,
                          color: isDark
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // SELLER SECTION
                  if (seller != null)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              context.push('/seller/${seller.id}'),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                Colors.white.withOpacity(isDark ? 0.1 : 0.4),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundImage: seller.profileImage.isNotEmpty
                                  ? NetworkImage(seller.profileImage)
                                  : null,
                              child: seller.profileImage.isEmpty
                                  ? Text(
                                      seller.username[0].toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => context.push(
                                  '/seller/${seller.id}',
                                  extra: seller,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        seller.username,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: isDark
                                          ? const Color(0xFF8CEFFF)
                                          : const Color(0xFF00B7FF),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      seller.rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 4),

                              // BIO
                              GestureDetector(
                                onTap: () => setState(() =>
                                    sellerBioExpanded = !sellerBioExpanded),
                                child: AnimatedCrossFade(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  crossFadeState: sellerBioExpanded
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  firstChild: Text(
                                    seller.bio,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: textSecondary,
                                    ),
                                  ),
                                  secondChild: Text(
                                    seller.bio,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      "Seller info unavailable",
                      style: TextStyle(color: textSecondary),
                    ),

                  const SizedBox(height: 22),

                  Divider(
                    color: textSecondary.withOpacity(0.25),
                    thickness: 1,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 14,
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // DESCRIPTION WITH MASK FADE
                  GestureDetector(
                    onTap: () async {
                      setState(() => descExpanded = !descExpanded);
                      if (descExpanded) _scrollToExpanded();
                    },
                    child: Stack(
                      key: _descKey,
                      children: [
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 240),
                          crossFadeState: descExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: _maskedText(
                            product.description,
                            textPrimary,
                          ),
                          secondChild: Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.45,
                              color: textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  // TRUE MASK FADE → no color, no opacity, pure alpha mask
  // -----------------------------------------------------------
  Widget _maskedText(String text, Color textColor) {
    return ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white,
            Colors.transparent,
          ],
          stops: [0.0, 0.7, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: Text(
        text,
        maxLines: 4,
        overflow: TextOverflow.fade,
        style: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: textColor,
        ),
      ),
    );
  }
}
