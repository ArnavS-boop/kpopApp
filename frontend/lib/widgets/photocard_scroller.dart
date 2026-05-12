import 'package:antipattern/models/photocards.dart';
import 'package:flutter/material.dart';
import 'listing_card.dart';

class PhotocardScroller extends StatelessWidget {
  final List<Listings> photocards;
  final int? maxCards;

  const PhotocardScroller({
    super.key,
    required this.photocards,
    this.maxCards,
  });

  @override
  Widget build(BuildContext context) {
    final visibleCards = maxCards != null && maxCards! < photocards.length
        ? photocards.take(maxCards!).toList()
        : photocards;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12), // ← side padding
        itemCount: visibleCards.length,
        itemBuilder: (context, index) {
          final photocard = visibleCards[index];

          return Padding(
            padding: const EdgeInsets.only(right: 12), // ← spacing between cards
            child: SizedBox(
              width: 180,
              child: ListingCard(
                id: photocard.id,
                title: photocard.title,
                subtitle: photocard.description,
                imageUrl: photocard.imageUrls.first,
                price: photocard.price,
              ),
            ),
          );
        },
      ),
    );
  }
}
