
import 'package:antipattern/widgets/glass_circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:antipattern/models/photocards.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/search_bar.dart';
import 'package:antipattern/widgets/wishlist_item_card.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final TextEditingController _controller = TextEditingController();
  String query = "";

  // TEMP wishlist
  List<Listings> get _wishlist => dummyListings.take(8).toList();

  List<Listings> get _filteredWishlist {
    if (query.isEmpty) return _wishlist;

    return _wishlist.where((item) {
      final q = query.toLowerCase();
      return item.title.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q) ||
          (item.group ?? "").toLowerCase().contains(q) ||
          item.sellerName.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredWishlist;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Column(
              children: [
                // ───────── HEADER ─────────
                Row(
                  children: [
                    GlassCircleIcon(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => context.pop(),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: AppSearchBar(
                        controller: _controller,
                        hint: "Search wishlist...",
                        onChanged: (value) {
                          setState(() => query = value.trim());
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                  ],
                ),

                const SizedBox(height: 20),

                // ───────── CONTENT ─────────
                Expanded(
                  child: results.isEmpty
                      ? Center(
                          child: Text(
                            "Your wishlist is empty",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 30),
                          itemCount: results.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, i) =>
                              WishlistItemCard(item: results[i]),
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
