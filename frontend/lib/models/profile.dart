class ProfileData {
  final String id;
  final String username;
  final String? bio;
  final String? avatarUrl;
  final DateTime joinedAt;

  final double rating;
  final int reviewCount;
  final int salesCount;
  final String? location;
  final String? responseTime;

  final bool isSeller;

  const ProfileData({
    required this.id,
    required this.username,
    required this.joinedAt,
    required this.rating,
    required this.reviewCount,
    required this.salesCount,
    required this.isSeller,
    this.bio,
    this.avatarUrl,
    this.location,
    this.responseTime,
  });
}

// Temporary mock for the current signed-in user.
// Replace with real auth-backed profile when wiring backend.
final ProfileData currentUserProfile = ProfileData(
  id: "bangtantradehub",
  username: "Your Username",
  joinedAt: DateTime(2025, 1),
  rating: 4.8,
  reviewCount: 12,
  salesCount: 5,
  isSeller: true,
  bio: "Collector",
  location: "Chennai",
);