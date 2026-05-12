import 'package:antipattern/pages/product_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/universal_action_bar.dart';
import 'package:antipattern/widgets/universal_bottom_sheet_menu.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:antipattern/widgets/reputation_review_section.dart';
import 'package:antipattern/widgets/review_preview_card.dart';
import 'package:antipattern/models/profile.dart';
import 'package:antipattern/models/reviews.dart';

class ProfileViewPage extends StatefulWidget {
  final String userId;

  const ProfileViewPage({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  ProfileData? profile;
  List<Review> reviews = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));

    profile = ProfileData(
      id: "bangtantradehub",
      username: "Your Username",
      joinedAt: DateTime(2025, 1),
      rating: 4.8,
      reviewCount: dummyReviews.length,
      salesCount: 12,
      isSeller: true,
      bio: "Collector & trader.",
      location: "Chennai",
    );

    reviews = dummyReviews;

    if (mounted) {
      setState(() => loading = false);
    }
  }

  void _openChat() {
    if (profile == null) return;
    final id = Uri.encodeComponent(profile!.id);
    context.push('/chat/$id');
  }

  void _openStore() {
    if (profile == null) return;
    context.push('/seller/${profile!.id}');
  }

  @override
  Widget build(BuildContext context) {
    if (loading || profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final p = profile!;

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

                  /// ---------------- HEADER ----------------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                    child: GlassContainer(
                      borderRadius: BorderRadius.circular(28),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// Avatar + Username
                          Row(
                            children: [
                              const CircleAvatar(radius: 42),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  p.username,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// ---- STATS ROW ----
                          Wrap(
                            spacing: 16,
                            runSpacing: 6,
                            children: [
                              _MetaText(
                                  text:
                                      "⭐ ${p.rating.toStringAsFixed(1)} (${p.reviewCount})"),
                              const _MetaText(text: "🛍 24 Purchases"),
                              const _MetaText(text: "❤️ 18 Wishlist"),
                              if (p.isSeller)
                                _MetaText(
                                    text:
                                        "📦 ${p.salesCount} Listings"),
                            ],
                          ),

                          const SizedBox(height: 12),

                          if (p.bio != null) Text(p.bio!),

                          const SizedBox(height: 10),

                          if (p.location != null)
                            _MetaText(text: "📍 ${p.location}"),

                          const SizedBox(height: 10),

                          Text(
                            "Member since ${p.joinedAt.year}",
                            style: const TextStyle(fontSize: 12),
                          ),

                          const SizedBox(height: 16),

                          /// ---- ACTION BUTTONS ----
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: _openChat, // ✅ FIXED
                                  child: GlassContainer(
                                    tint: const Color(0xFFB590F7),
                                    shadowOverride:
                                        const Color(0xFFB590F7)
                                            .withOpacity(0.35),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Chat",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              if (p.isSeller) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _openStore, // cleaner
                                    child: GlassContainer(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "View Store",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ---------------- BADGES ----------------
                  const SectionTitle("Badges"),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _BadgeChip(label: "Verified"),
                        _BadgeChip(label: "Top Collector"),
                        _BadgeChip(label: "Trusted Trader"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(height: 1),

                  /// ---------------- REVIEWS ----------------
                  const SectionTitle("Reviews"),

                  ReputationReviewSection(
                    summary: dummySummary,
                    reviews: reviews,
                  ),

                  ReviewPreviewCard(
                    reviews: reviews,
                    totalCount: reviews.length,
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
                    label: "Share Profile",
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
class _MetaText extends StatelessWidget {
  final String text;
  const _MetaText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.5,
        color: Theme.of(context)
            .colorScheme
            .onSurface
            .withOpacity(0.75),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  const _BadgeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(18),
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}