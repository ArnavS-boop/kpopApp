import 'package:antipattern/models/featured_banner.dart';
import 'package:antipattern/pages/product_page.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:antipattern/widgets/showcase.dart';
import 'package:flutter/material.dart';

import 'package:antipattern/models/sellers.dart';
import 'package:antipattern/models/profile.dart';
import 'package:go_router/go_router.dart';
import 'package:antipattern/models/photocards.dart';
import 'package:antipattern/models/reviews.dart';

// WIDGETS
import 'package:antipattern/widgets/seller_header.dart';
import 'package:antipattern/widgets/banner_grid.dart';
import 'package:antipattern/widgets/photocard_scroller.dart';
import 'package:antipattern/widgets/review_preview_card.dart';
import 'package:antipattern/widgets/reputation_review_section.dart';

// UNIVERSAL ACTION BAR + MENU
import 'package:antipattern/widgets/universal_action_bar.dart';
import 'package:antipattern/widgets/universal_bottom_sheet_menu.dart';

// BACKGROUND
import 'package:antipattern/widgets/app_background.dart';


class SellerPage extends StatelessWidget {
  final String sellerId;

  const SellerPage({super.key, required this.sellerId});

Seller? get seller {
  try {
    return dummySellers.firstWhere((s) => s.id == sellerId);
  } catch (_) {
    return null;
  }
}
  List<Listings> get listings =>
      dummyListings.where((p) => p.sellerName == sellerId).toList();
  List<Review> get reviews => dummyReviews;

@override
Widget build(BuildContext context) {
  final currentSeller = seller;

  if (currentSeller == null) {
    return const Scaffold(
      body: Center(
        child: Text("Seller not found"),
      ),
    );
  }

  return Scaffold(
    backgroundColor: Colors.transparent,
    body: AppBackground(
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------- SELLER HEADER --------------------
                SellerHeader(seller: currentSeller),

                // Quick actions: view profile and edit (if owner)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push('/profile/${currentSeller.id}'),
                          child: GlassContainer(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: const Center(child: Text('View Profile')),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (currentSeller.id == currentUserProfile.id)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to the edit page. Integrate backend
                              // persistence after the edit flow completes.
                              context.push('/seller/${currentSeller.id}/edit', extra: currentSeller);
                            },
                            child: GlassContainer(
                              tint: const Color(0xFFB590F7),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Center(child: Text('Edit Sales Profile')),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),

                // -------------------- SHOWCASE --------------------
                const SectionTitle("Showcase"),

                if (listings.isNotEmpty)
                  SellerShowcase(listing: listings.first)
                else
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("No listings yet."),
                  ),

                const SizedBox(height: 20),
                const Divider(height: 1),

                // -------------------- LISTINGS --------------------
                const SectionTitle("Listings"),

                if (listings.isNotEmpty)
                  BannerGrid(
                    banners: featuredBanners,
                    crossAxisCountVariable: 2,
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("No listings available."),
                  ),

                const SizedBox(height: 16),
                const Divider(height: 1),

                // -------------------- REVIEWS --------------------
                const SectionTitle("Seller Reviews"),

                ReputationReviewSection(
                  summary: dummySummary,
                  reviews: reviews,
                ),

                ReviewPreviewCard(
                  reviews: reviews,
                  totalCount: reviews.length,
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),

                // -------------------- SIMILAR LISTINGS --------------------
                const SectionTitle("Similar Listings"),

                PhotocardScroller(
                  photocards: dummyListings,
                  maxCards: 12,
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),

          TopOverlayActionBar(
            onMenu: () {
              showUniversalBottomMenu(context, [
                BottomMenuItem(
                  icon: Icons.share_rounded,
                  label: "Share Seller",
                  onTap: () {},
                ),
                BottomMenuItem(
                  icon: Icons.flag_rounded,
                  label: "Report Seller",
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
        ],
      ),
    ),
  );
}
}