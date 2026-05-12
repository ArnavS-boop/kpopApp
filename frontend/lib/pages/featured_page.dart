import 'package:antipattern/models/featured_collection.dart';
import 'package:antipattern/models/photocards.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/listing_card.dart';
import 'package:antipattern/widgets/universal_action_bar.dart';
import 'package:flutter/material.dart';

class FeaturedPage extends StatefulWidget {
  final String slug;

  const FeaturedPage({super.key, required this.slug});

  @override
  State<FeaturedPage> createState() => _FeaturedPageState();
}

class _FeaturedPageState extends State<FeaturedPage> {
  FeaturedCollection? collection;
  List<Listings> products = [];
  bool loading = true;
  bool notFound = false;

  @override
  void initState() {
    super.initState();
    _loadFeatured();
  }

  /// ----------------------------------------------------------
  /// MOCK FEATURED LOADER
  /// ----------------------------------------------------------
  Future<void> _loadFeatured() async {
    await Future.delayed(const Duration(milliseconds: 400));

    FeaturedCollection? loadedCollection;
    List<Listings> loadedProducts = [];

    switch (widget.slug) {
      case "le-sserafim-spotlight":
        loadedCollection = FeaturedCollection(
          id: "1",
          slug: widget.slug,
          title: "LE SSERAFIM Spotlight",
          subtitle: "Curated highlights",
          backgroundUrl: null,
          overlayHex: "#00000066",
          gradient: const [
            Color(0xFF1A1A40),
            Color(0xFF6A00FF),
          ],
          fontFamily: null,
          titleColor: Colors.white,
          subtitleColor: Colors.white70,
        );

        loadedProducts = dummyListings.take(6).toList();
        break;

      case "rare-cards":
        loadedCollection = FeaturedCollection(
          id: "2",
          slug: widget.slug,
          title: "Rare Photocards",
          subtitle: "Hard-to-find pieces",
          backgroundUrl: null,
          overlayHex: null,
          gradient: const [
            Color(0xFF2B0000),
            Color(0xFFFF3C38),
          ],
          fontFamily: null,
          titleColor: Colors.white,
          subtitleColor: Colors.white70,
        );

        loadedProducts = dummyListings.skip(2).take(6).toList();
        break;

      default:
        notFound = true;
    }

    if (mounted) {
      setState(() {
        collection = loadedCollection;
        products = loadedProducts;
        loading = false;
      });
    }
  }

  /// ----------------------------------------------------------
  /// BUILD
  /// ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return AppBackground(
      backgroundImageUrl: collection?.backgroundUrl,
      overlayColorHex: collection?.overlayHex,
      gradientOverride: collection?.gradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : notFound
                ? const Center(
                    child: Text(
                      "Featured collection not found",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Stack(
                    children: [
                      _buildContent(),
                      const TopOverlayActionBar(),
                    ],
                  ),
      ),
    );
  }

  /// ----------------------------------------------------------
  /// CONTENT
  /// ----------------------------------------------------------
  Widget _buildContent() {
    if (collection == null) {
      return const Center(child: Text("No collection"));
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 70), // space for overlay
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                collection!.title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      fontFamily: collection!.fontFamily,
                      color: collection!.titleColor ??
                          Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),

            /// SUBTITLE
            if (collection!.subtitle != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  collection!.subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontFamily: collection!.fontFamily,
                        color: collection!.subtitleColor ??
                            Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                      ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            /// GRID
            Expanded(
              child: products.isEmpty
                  ? const Center(
                      child: Text(
                        "No products in this collection",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.62,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        final item = products[i];

                        return ListingCard(
                          id: item.id,
                          title: item.title,
                          subtitle: item.description,
                          imageUrl: item.imageUrls.isNotEmpty
                              ? item.imageUrls.first
                              : '',
                          price: item.price,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}