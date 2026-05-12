
class Review {
  final String username;
  final String avatar;
  final String text;
  final double stars;
  final double weight; // weighted reputation impact 0.1 – 1.5
  final bool verifiedPurchase;
  final List<String> stamps; // Gitcoin-like stamps
  final DateTime date;

  Review({
    required this.username,
    required this.avatar,
    required this.text,
    required this.stars,
    required this.weight,
    required this.verifiedPurchase,
    required this.stamps,
    required this.date,
  });
}

class RatingSummary {
  final double weightedAverage;
  final double rawAverage;
  final Map<int, int> distribution; // {5: xx, 4: xx...}

  RatingSummary({
    required this.weightedAverage,
    required this.rawAverage,
    required this.distribution,
  });
}


final RatingSummary dummySummary = RatingSummary(
  weightedAverage: 4.7,
  rawAverage: 4.9,
  distribution: {5: 120, 4: 18, 3: 2, 2: 1, 1: 0},
);

final List<Review> dummyReviews = [
  // TODO: Dummy reviews use `DateTime.now()` and hardcoded avatar URLs.
  //       For deterministic tests and predictable UI, load fixed timestamps
  //       and move remote images to configurable test fixtures or assets.
  Review(
    username: "minji",
    avatar: "https://i.pravatar.cc/150?img=3",
    text: "Card arrived in perfect condition!! Seller was super sweet 💗",
    stars: 5,
    weight: 1.2,
    verifiedPurchase: true,
    stamps: ["Identity", "Reliable", "Active"],
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Review(
    username: "soobinlover",
    avatar: "https://i.pravatar.cc/150?img=12",
    text: "Good packing, arrived safely.",
    stars: 4,
    weight: 0.9,
    verifiedPurchase: true,
    stamps: ["Reliable"],
    date: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Review(
    username: "whatthehelly",
    avatar: "https://i.pravatar.cc/150?img=12",
    text: "Good packing, arrived safely.",
    stars: 4,
    weight: 0.9,
    verifiedPurchase: true,
    stamps: ["Reliable"],
    date: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Review(
    username: "soobinlover",
    avatar: "https://i.pravatar.cc/150?img=12",
    text: "Good packing, arrived safely.",
    stars: 4,
    weight: 0.9,
    verifiedPurchase: true,
    stamps: ["Reliable"],
    date: DateTime.now().subtract(const Duration(days: 5)),
  ),
];
