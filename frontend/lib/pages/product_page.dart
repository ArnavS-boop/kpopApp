  import 'dart:ui';

import 'package:antipattern/models/featured_banner.dart';
import 'package:antipattern/models/reviews.dart';
import 'package:antipattern/widgets/chat_button.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:antipattern/widgets/order_button.dart';
  import 'package:antipattern/widgets/product_details.dart';
  import 'package:antipattern/widgets/reputation_review_section.dart';
  import 'package:antipattern/widgets/review_preview_card.dart';
  import 'package:flutter/material.dart';
  import 'package:antipattern/models/photocards.dart';

  // widgets
  import 'package:antipattern/widgets/card_carousel.dart';
  import 'package:antipattern/widgets/photocard_scroller.dart';
  import 'package:antipattern/widgets/poster_scroller.dart';
  import 'package:antipattern/widgets/banner_grid.dart';

  // UNIVERSAL BAR + MENU
  import 'package:antipattern/widgets/universal_action_bar.dart';
  import 'package:antipattern/widgets/universal_bottom_sheet_menu.dart';

  // ⭐ ADDED BACKGROUND WIDGET
  import 'package:antipattern/widgets/app_background.dart';

  class ProductPage extends StatelessWidget {
    final Listings product;

    const ProductPage({super.key, required this.product});

    @override
    Widget build(BuildContext context) {
      bool isMissing = product.title == "Not Found";

      if (isMissing) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "This product does not exist.",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Go Back"),
                )
              ],
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: Colors.transparent,

        // ⭐ WRAPPED EVERYTHING WITH BACKGROUND
        body: AppBackground(
          child: Stack(
            children: [
              // ---------------- BACKGROUND CONTENT ----------------
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------------- MAIN CAROUSEL ----------------
                      SizedBox(
                        height: 380,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: PhotoCarousel(
                                imageUrls: product.imageUrls,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(),
                      const SizedBox(height: 20),

                      // ---------------- PRODUCT DETAILS ----------------
                      ProductDetailsSection(product: product),

                      // ---------------- SIMILAR CARDS ----------------
                      const SectionTitle("Similar Cards"),
                      PhotocardScroller(
                        photocards: dummyListings,
                        maxCards: 10,
                      ),

                      const Divider(),

                      // ---------------- POSTERS ----------------
                      const SectionTitle("Posters"),
                      PosterScroller(
                        banners: featuredBanners,
                        maxImages: 10,
                      ),

                      const Divider(),

                      const SectionTitle("Ratings"),
                      ReputationReviewSection(
                        summary: dummySummary,
                        reviews: dummyReviews,
                      ),

                      ReviewPreviewCard(
                        reviews: dummyReviews,
                        totalCount: dummyReviews.length,
                      ),

                      const Divider(),

                      // ---------------- MORE FROM THIS SELLER ----------------
                      const SectionTitle("More From This Seller"),
                      BannerGrid(
                        banners: featuredBanners,
                        crossAxisCountVariable: 2,
                      ),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),

              // ------------------------------------------------------
              // TOP OVERLAY BUTTON BAR (back & menu)
              // ------------------------------------------------------
              TopOverlayActionBar(
                onMenu: () {
                  showUniversalBottomMenu(context, [
                    BottomMenuItem(
                      icon: Icons.share_rounded,
                      label: "Share Product",
                      onTap: () {},
                    ),
                    BottomMenuItem(
                      icon: Icons.flag_rounded,
                      label: "Report Listing",
                      onTap: () {},
                    ),
                    BottomMenuItem(
                      icon: Icons.feedback_rounded,
                      label: "Send Feedback",
                      onTap: () {},
                    ),
                  ]);
                },
              ),

              /// ------------------------------------------------------
              /// FLOATING ORDER BAR
              /// ------------------------------------------------------
              Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: ClipRRect( // 👈 THIS FIXES IT
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: GlassContainer(
                        borderRadius: BorderRadius.circular(28),
                        tint: const Color(0xFFB590F7),
                        shadowOverride:
                            const Color(0xFFB590F7).withOpacity(0.35),
                        showShadow: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "\$${product.price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ChatButton(product: product),


                            const SizedBox(width: 12),
                            OrderButton(product: product),
                          ],
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
      );
    }
  }

  class SectionTitle extends StatelessWidget {
    final String text;
    const SectionTitle(this.text, {super.key});

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
