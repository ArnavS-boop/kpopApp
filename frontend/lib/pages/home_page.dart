import 'package:antipattern/models/featured_banner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antipattern/services/api.dart';

import 'package:antipattern/models/photocards.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/listing_card.dart';
import 'package:antipattern/widgets/poster_scroller.dart';
import 'package:antipattern/widgets/search_bar.dart';
import 'package:antipattern/widgets/glass_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final ApiService _apiService = ApiService();
  final int _pageSize = 20;
  int _page = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  final List<dynamic> _items = [];
  final List<dynamic> _serverItems = [];

  @override
  void initState() {
    super.initState();
    _loadNextPage();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 400) {
        _loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _loadNextPage() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    if (_serverItems.isEmpty) {
      try {
        final response = await _apiService.fetchListings();
        _serverItems.addAll(response);
      } catch (e) {
        // fallback to local mock listings when API is unavailable
        _serverItems.addAll(dummyListings);
      }
    }

    await Future.delayed(const Duration(milliseconds: 400));

    final start = _page * _pageSize;
    final next = _serverItems.skip(start).take(_pageSize).toList();

    setState(() {
      _page++;
      _items.addAll(next);
      _isLoading = false;
      if (next.length < _pageSize) _hasMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = (width ~/ 200).clamp(2, 6);

    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final textSecondary = textPrimary.withOpacity(0.6);

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // ───────── PREMIUM STICKY SEARCH ─────────
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: _PremiumSearchDelegate(
                  controller: searchController,
                ),
              ),

              // ───────── DISCOVER TITLE ─────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    "Discover",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ),
              ),

              // ───────── POSTER CAROUSEL ─────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: PosterScroller(
                    banners: featuredBanners,
                  ),
                ),
              ),

              // ───────── FEATURED HEADER ─────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 22, 16, 12),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Featured Listings",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Popular picks from collectors",
                            style: TextStyle(
                              fontSize: 13.5,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.push("/featured/le-sserafim-spotlight"),
                        child: Text(
                          "See all",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ───────── GRID ─────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = _items[index];
                      return ListingCard(
                        id: product.id,
                        title: product.title,
                        subtitle: product.description,
                        imageUrl: product.imageUrls.first,
                        price: product.price,
                      );
                    },
                    childCount: _items.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2 / 3,
                  ),
                ),
              ),

              if (_isLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumSearchDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;

  _PremiumSearchDelegate({required this.controller});

  static const double _height = 45; // MATCH search bar

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(26),
        tint: null,
        showShadow: overlapsContent,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: AppSearchBar(
          controller: controller,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _PremiumSearchDelegate oldDelegate) => false;
}