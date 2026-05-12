import 'package:antipattern/models/featured_banner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antipattern/theme/app_theme.dart';

class BannerGrid extends StatelessWidget {
  final List<FeaturedBanner> banners;
  final int crossAxisCountVariable;
  final int? maxImages;

  const BannerGrid({
    super.key,
    required this.banners,
    required this.crossAxisCountVariable,
    this.maxImages,
  });

  @override
  Widget build(BuildContext context) {
    final visibleBanners =
        maxImages != null && maxImages! < banners.length
            ? banners.take(maxImages!).toList()
            : banners;

    return SizedBox(
      height: 350,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCountVariable,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
        itemCount: visibleBanners.length,
        itemBuilder: (context, index) {
          final banner = visibleBanners[index];

          return Padding(
            padding: const EdgeInsets.all(8),
            child: AspectRatio(
              aspectRatio: 1,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
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