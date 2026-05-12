import 'package:flutter/material.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:antipattern/widgets/universal_action_bar.dart';
import 'package:antipattern/models/profile.dart';
import 'package:go_router/go_router.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool get isSeller => profile.isSeller;

  late ProfileData profile;

  @override
  void initState() {
    super.initState();

    // TEMP mock — replace with backend fetch later
    profile = ProfileData(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 100, 16, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AccountHeader(profile: profile),

                      const SizedBox(height: 28),

                      const _SectionTitle("Account"),

                      _AccountTile(
                        icon: Icons.edit_rounded,
                        title: "Edit Profile",
                        onTap: () async {
                          final updated =
                              await context.push<ProfileData>(
                            "/account/edit",
                            extra: profile,
                          );

                          if (updated != null) {
                            setState(() {
                              profile = updated;
                            });
                          }
                        },
                      ),

                      _AccountTile(
                        icon: Icons.shopping_bag_outlined,
                        title: "My Orders",
                        onTap: () => context.push("/orders"),
                      ),

                      _AccountTile(
                        icon: Icons.favorite_border_rounded,
                        title: "Wishlist",
                        onTap: () => context.push("/wishlist"),
                      ),

                      _AccountTile(
                        icon: Icons.settings_rounded,
                        title: "Settings",
                        onTap: () => context.push("/account/settings"),
                      ),

                      const SizedBox(height: 30),

                      if (isSeller) ...[
                        const _SectionTitle("Seller Tools"),

                        _AccountTile(
                          icon: Icons.inventory_2_outlined,
                          title: "Manage Listings",
                          onTap: () =>
                              context.push("/seller/${profile.id}/listings"),
                        ),

                        _AccountTile(
                          icon: Icons.analytics_outlined,
                          title: "Sales Analytics",
                          onTap: () => context.push("/seller/${profile.id}/analytics"),
                        ),

                        _AccountTile(
                          icon: Icons.storefront_outlined,
                          title: "My Storefront",
                          onTap: () => context.push("/seller/${profile.id}"),
                        ),

                        const SizedBox(height: 24),
                      ] else ...[
                        const _SectionTitle("Start Selling"),
                        const SizedBox(height: 8),
                        const _BecomeSellerCTA(),
                        const SizedBox(height: 24),
                      ],
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

class _AccountHeader extends StatelessWidget {
  final ProfileData profile;

  const _AccountHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push("/profile/${profile.id}"),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(28),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 38,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Member since ${profile.joinedAt.year}",
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _AccountTile({
    required this.icon,
    required this.title,
    required this.onTap,
    bool isDestructive = false,
  }) : isDestructive = isDestructive;

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: GlassContainer(
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: textColor),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _BecomeSellerCTA extends StatelessWidget {
  const _BecomeSellerCTA();

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(24),
      tint: const Color(0xFFB590F7),
      shadowOverride: const Color(0xFFB590F7).withOpacity(0.35),
      padding: const EdgeInsets.all(20),
      child: const Text(
        "Open Your Store",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}