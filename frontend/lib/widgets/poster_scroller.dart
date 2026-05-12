import 'package:antipattern/models/featured_banner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antipattern/theme/app_theme.dart';

class PosterScroller extends StatelessWidget {
  final List<FeaturedBanner> banners;
  final int? maxImages;

  const PosterScroller({
    super.key,
    required this.banners,
    this.maxImages,
  });

  static const double _posterAspectRatio = 2 / 3;

  @override
  Widget build(BuildContext context) {
    final visibleBanners =
        maxImages != null && maxImages! < banners.length
            ? banners.take(maxImages!).toList()
            : banners;

    final screenWidth = MediaQuery.of(context).size.width;
    const viewportFraction = 0.80;

    final posterWidth = screenWidth * viewportFraction;
    final posterHeight = posterWidth / _posterAspectRatio;

    return SizedBox(
      height: posterHeight,
      child: PageView.builder(
        controller: PageController(viewportFraction: viewportFraction),
        padEnds: false,
        clipBehavior: Clip.none,
        itemCount: visibleBanners.length,
        itemBuilder: (context, index) {
          final banner = visibleBanners[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: posterWidth,
              height: posterHeight,
              child: Material(
                elevation: 10,
                shadowColor: Colors.black,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    context.push('/featured/${banner.slug}');
                  },
                  splashColor: appTokens(context).splash,
                  highlightColor: Colors.transparent,
                  child: Ink.image(
                    image: NetworkImage(banner.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}