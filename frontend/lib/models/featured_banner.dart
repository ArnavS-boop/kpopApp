class FeaturedBanner {
  final String imageUrl;
  final String slug;

  const FeaturedBanner({
    required this.imageUrl,
    required this.slug,
  });
}

final List<FeaturedBanner> featuredBanners = const [
  FeaturedBanner(
    imageUrl: "https://i.pinimg.com/736x/6e/a7/20/6ea72050cafb77d066c861f47b0850b8.jpg",
    slug: "le-sserafim-spotlight",
  ),
  FeaturedBanner(
    imageUrl: "https://www.rappler.com/tachyon/2021/10/k-pop-photocards-papels.jpeg?resize=2048%2C1536&zoom=1",
    slug: "rare-cards",
  ),
  FeaturedBanner(
    imageUrl: "https://pbs.twimg.com/media/GRBIC-WWAAAoYR8?format=jpg&name=4096x4096",
    slug: "twice-collection",
  ),
];