class Seller {
  final String id;
  final String username;
  final String profileImage;
  final String? bannerImage;  // optional
  final String bio;
  final double rating;
  final int totalSales;

  Seller({
    required this.id,
    required this.username,
    required this.profileImage,
    this.bannerImage,     // optional
    required this.bio,
    required this.rating,
    required this.totalSales,
  });

  Null get ratingCount => null;
}

// TODO: `Seller` model currently contains a placeholder `ratingCount` getter
//       returning `null` with type `Null`. Consider replacing with a proper
//       `int? ratingCount` field or removing it if unused. Validate types.


final dummySellers = [
  // TODO: These are hardcoded dummy sellers for local development.
  //       Remove or replace with fixtures loaded from a JSON file or
  //       a mock API. Avoid shipping hardcoded external image URLs;
  //       instead use local assets or a configurable data source.
  Seller(
    id: "kpopvault",
    username: "kpopvault",
    profileImage: "https://i.pravatar.cc/150?img=12",
    bannerImage: "https://picsum.photos/id/1015/900/300",
    bio: "Trusted seller of K-pop merch since 2020.",
    rating: 4.9,
    totalSales: 240,
  ),
  Seller(
    id: "mintlover07",
    username: "mintlover07",
    profileImage: "https://i.pravatar.cc/150?img=32",
    bannerImage: "https://picsum.photos/id/1024/900/300",
    bio: "Collector of NewJeans, IVE, and LE SSERAFIM.",
    rating: 4.8,
    totalSales: 180,
  ),
  Seller(
    id: "stay4ever",
    username: "stay4ever",
    profileImage: "https://i.pravatar.cc/150?img=58",
    bannerImage: "https://picsum.photos/id/1044/900/300",
    bio: "Stray Kids enthusiast — trading since 2019.",
    rating: 4.7,
    totalSales: 310,
  ),
  Seller(
    id: "starshoppe",
    username: "starshoppe",
    profileImage: "https://i.pravatar.cc/150?img=33",
    bannerImage: "https://picsum.photos/id/1060/900/300",
    bio: "Selling exclusive K-pop PCs and albums. raaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhhhhhhhhhhwooooooooooooo",
    rating: 4.6,
    totalSales: 150,
  ),
  Seller(
    id: "bangtantradehub",
    username: "bangtantradehub",
    profileImage: "https://i.pravatar.cc/150?img=44",
    bannerImage: "https://picsum.photos/id/1037/900/300",
    bio: "Verified BTS collector & reseller.",
    rating: 4.95,
    totalSales: 520,
  ),
  Seller(
    id: "once4life",
    username: "once4life",
    profileImage: "https://i.pravatar.cc/150?img=77",
    bannerImage: "https://picsum.photos/id/1040/900/300",
    bio: "TWICE collector — trading photocards worldwide.",
    rating: 4.85,
    totalSales: 390,
  ),
];
