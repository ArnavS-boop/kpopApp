import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:antipattern/models/reviews.dart';
import 'package:antipattern/widgets/review_filter_bar.dart';
import 'package:antipattern/widgets/review_proof_panel.dart';

class AllReviewsPage extends StatefulWidget {
  final List<Review> reviews;

  const AllReviewsPage({
    super.key,
    required this.reviews,
  });

  @override
  State<AllReviewsPage> createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends State<AllReviewsPage> {
  int? selectedStars;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final base = isDark
        ? Colors.white.withOpacity(0.07)
        : Colors.white.withOpacity(0.22);

    final border = isDark
        ? Colors.white.withOpacity(0.30)
        : Colors.white.withOpacity(0.55);

    final shadow = isDark
        ? Colors.blueGrey.withOpacity(0.28)
        : Colors.blue.withOpacity(0.18);

    final neon = isDark
        ? const Color(0xFF99EDFF)
        : const Color(0xFF62DFFF);

    final text = isDark
        ? Colors.white.withOpacity(0.95)
        : Colors.black.withOpacity(0.90);

    final filtered = selectedStars == null
      ? widget.reviews
      : widget.reviews
        .where((r) => r.stars.round() == selectedStars)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Reviews"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ReviewFiltersBar(
              selectedStars: selectedStars,
              onChanged: (v) => setState(() => selectedStars = v),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final r = filtered[i];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              base.withOpacity(0.26),
                              base.withOpacity(0.14),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: border, width: 1.3),
                          boxShadow: [
                            BoxShadow(
                              color: shadow,
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                        Row(
                                          children: [
                                            _stars(r.stars, neon),
                                            const SizedBox(width: 8),
                                            Text(
                                              r.stars.toStringAsFixed(1),
                                              style: TextStyle(
                                                color: text,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),

                            const SizedBox(height: 10),

                            Text(
                              r.text,
                              style: TextStyle(
                                color: text,
                                fontSize: 15,
                                height: 1.45,
                              ),
                            ),

                            const SizedBox(height: 12),

                            ReviewProofPanel(
                              verifiedPurchase: r.verifiedPurchase,
                              reviewerTrust: r.weight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stars(double rating, Color neon) {
    return Row(
      children: List.generate(
        5,
        (i) => Icon(
          i < rating.round()
              ? Icons.star_rounded
              : Icons.star_border_rounded,
          color: neon,
          size: 20,
        ),
      ),
    );
  }
}
