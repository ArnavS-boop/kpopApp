import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:antipattern/widgets/universal_action_bar.dart';
import 'package:antipattern/models/photocards.dart';
import 'package:antipattern/theme/app_theme.dart';

class ManageListingsPage extends StatelessWidget {
  final String sellerId;

  const ManageListingsPage({
    super.key,
    required this.sellerId,
  });

  @override
  Widget build(BuildContext context) {
    // TEMP — replace with backend fetch later
    final sellerListings = dummyListings
        .where((l) => l.sellerName == sellerId)
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 100, 16, 40),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const _SectionTitle(
                          "Manage Listings"),

                      const SizedBox(height: 16),

                      if (sellerListings.isEmpty)
                        const Text("No listings yet.")
                      else
                        ...sellerListings.map(
                          (listing) =>
                              _ListingCard(
                                listing: listing,
                                sellerId: sellerId,
                              ),
                        ),

                      const SizedBox(height: 30),

                      _AddListingButton(
                        sellerId: sellerId,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const TopOverlayActionBar(),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
// LISTING CARD
///////////////////////////////////////////////////////////////////////////

class _ListingCard extends StatelessWidget {
  final Listings listing;
  final String sellerId;

  const _ListingCard({
    required this.listing,
    required this.sellerId,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = appTokens(context);
    final colorScheme =
        Theme.of(context).colorScheme;

    final textPrimary = colorScheme.onSurface;
    final textSecondary =
        colorScheme.onSurface.withOpacity(0.65);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(22),
          onTap: () {
            context.pushNamed(
              'product',
              pathParameters: {
                'id': listing.id
              },
              extra: listing,
            );
          },
          child: GlassContainer(
            borderRadius:
                BorderRadius.circular(22),
            padding: EdgeInsets.zero,
            tint: null,
            showShadow: true,
            child: SizedBox(
              height: 150,
              child: Row(
                children: [
                  ////////////////////////////////////////////////////////////
                  // LEFT CONTENT
                  ////////////////////////////////////////////////////////////

                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 18,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            listing.title,
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w700,
                              color:
                                  textPrimary,
                            ),
                          ),

                          const SizedBox(
                              height: 6),

                          Text(
                            "₹${listing.price}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  textPrimary,
                            ),
                          ),

                          const SizedBox(
                              height: 6),

                          Text(
                            "Active • ${listing.sellerName}",
                            style: TextStyle(
                              fontSize: 12.5,
                              color:
                                  textSecondary,
                            ),
                          ),

                          const Spacer(),

                          ////////////////////////////////////////////////////
                          // ACTION BUTTONS
                          ////////////////////////////////////////////////////

                          Row(
                            children: [
                              _SmallActionButton(
                                label: "Edit",
                                onTap: () {
                                  context.push(
                                    "/seller/$sellerId/edit/${listing.id}",
                                    extra:
                                        listing,
                                  );
                                },
                              ),

                              const SizedBox(
                                  width: 12),

                              _SmallActionButton(
                                label:
                                    "Delete",
                                destructive:
                                    true,
                                onTap: () =>
                                    _showDeleteDialog(
                                        context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  ////////////////////////////////////////////////////////////
                  // RIGHT IMAGE
                  ////////////////////////////////////////////////////////////

                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                              12),
                      child: AspectRatio(
                        aspectRatio: 0.62,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      16),
                          child: Container(
                            color: tokens
                                .placeholder,
                            child:
                                Image.network(
                              listing
                                  .imageUrls
                                  .first,
                              fit: BoxFit
                                  .cover,
                              loadingBuilder:
                                  (context,
                                      child,
                                      progress) {
                                if (progress ==
                                    null) {
                                  return child;
                                }

                                return const Center(
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth:
                                        2,
                                  ),
                                );
                              },
                              errorBuilder:
                                  (_, __,
                                          ___) =>
                                      Icon(
                                Icons
                                    .broken_image_rounded,
                                color: colorScheme
                                    .onSurface
                                    .withOpacity(
                                        0.3),
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
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////////
  // DELETE CONFIRMATION
  /////////////////////////////////////////////////////////////////////////

  void _showDeleteDialog(
      BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:
            const Text("Delete Listing"),
        content: const Text(
            "Are you sure you want to delete this listing?"),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: backend delete call
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                  color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
// SMALL GLASS BUTTON
///////////////////////////////////////////////////////////////////////////

class _SmallActionButton
    extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  const _SmallActionButton({
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius:
            BorderRadius.circular(14),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),
        tint: destructive
            ? colorScheme.error
                .withOpacity(0.15)
            : null,
        showShadow: false,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.w600,
            color: destructive
                ? colorScheme.error
                : colorScheme
                    .onSurface,
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
// ADD LISTING BUTTON
///////////////////////////////////////////////////////////////////////////

class _AddListingButton
    extends StatelessWidget {
  final String sellerId;

  const _AddListingButton({
    required this.sellerId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
            "/seller/$sellerId/create");
      },
      child: GlassContainer(
        borderRadius:
            BorderRadius.circular(24),
        tint:
            const Color(0xFFB590F7),
        shadowOverride:
            const Color(0xFFB590F7)
                .withOpacity(0.35),
        padding:
            const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: const Center(
          child: Text(
            "Add New Listing",
            style: TextStyle(
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
// SECTION TITLE
///////////////////////////////////////////////////////////////////////////

class _SectionTitle
    extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight:
            FontWeight.w800,
      ),
    );
  }
}