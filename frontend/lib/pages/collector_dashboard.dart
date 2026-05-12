import 'package:flutter/material.dart';
import 'package:antipattern/widgets/app_background.dart';

/// Collector Dashboard scaffold with placeholder widgets.
/// Replace each placeholder with the real widget implementation in subsequent steps.
class CollectorDashboardPage extends StatelessWidget {
  const CollectorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
            child: Column(
              children: [
                // ---------- Header row: Title + quick actions ----------
                _HeaderRow(),

                const SizedBox(height: 18),

                // ---------- Scrollable content ----------
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top tiles: Collection overview (small cards)
                        CollectionOverviewSection(),

                        const SizedBox(height: 14),

                        // Two-column band: Set completions (left) + Wishlist summary (right)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Expanded(flex: 6, child: SetCompletionSection()),
                            SizedBox(width: 12),
                            Expanded(flex: 4, child: WishlistSummary()),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Incoming / Outgoing quick status
                        IncomingOutgoingSection(),

                        const SizedBox(height: 14),

                        // Activity graph + Insights side-by-side
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Expanded(flex: 6, child: ActivityGraph()),
                            SizedBox(width: 12),
                            Expanded(flex: 4, child: InsightsSection()),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Recently added scroller (horizontal)
                        RecentlyAddedScroller(),

                        const SizedBox(height: 14),

                        // Achievements (full width)
                        AchievementsSection(),

                        const SizedBox(height: 14),

                        // Recommendations (grid or list)
                        RecommendationsSection(),

                        const SizedBox(height: 18),

                        // Backup / Export
                        BackupExportSection(),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small header row with page title + placeholder CTA buttons
class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        Text(
          "My Collection",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const Spacer(),
        // Quick action placeholders (export, import, settings)
        _SmallGlassButton(icon: Icons.upload_file, label: "Export", onTap: () {}),
        const SizedBox(width: 10),
        _SmallGlassButton(icon: Icons.download, label: "Import", onTap: () {}),
        const SizedBox(width: 10),
        _SmallGlassButton(icon: Icons.tune_rounded, label: "Filters", onTap: () {}),
      ],
    );
  }
}

class _SmallGlassButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SmallGlassButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final base = isDark ? Colors.white.withOpacity(0.10) : Colors.white.withOpacity(0.55);
    final edge = isDark ? Colors.white.withOpacity(0.22) : Colors.white.withOpacity(0.40);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: [base, base.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: edge, width: 1.0),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.onSurface),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: theme.colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}

/// ---------------------- Placeholder Sections ----------------------
/// Each section is a small glass-styled container that displays the widget name.
/// We'll replace them with full implementations later.

Widget _glassPlaceholder(BuildContext context, String title, {double minHeight = 100, Widget? childHint}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final bg = isDark ? Colors.white.withOpacity(0.07) : Colors.white.withOpacity(0.65);
  final border = isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.06);

  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [bg, bg.withOpacity(isDark ? 0.05 : 0.22)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: border, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.18) : Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: childHint ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 8),
              Text(
                "Placeholder — will become \"$title\" widget",
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              ),
            ],
          ),
    ),
  );
}

/// Collection overview: top tiles (small cards row)
class CollectionOverviewSection extends StatelessWidget {
  const CollectionOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    // small tiles in a horizontal row
    return SizedBox(
      height: 92,
      child: Row(
        children: [
          Expanded(child: _glassPlaceholder(context, "Total Cards", minHeight: 72)),
          const SizedBox(width: 12),
          Expanded(child: _glassPlaceholder(context, "Rarity Breakdown", minHeight: 72)),
          const SizedBox(width: 12),
          Expanded(child: _glassPlaceholder(context, "Groups Count", minHeight: 72)),
        ],
      ),
    );
  }
}

/// Set completion section placeholder (left column)
class SetCompletionSection extends StatelessWidget {
  const SetCompletionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _glassPlaceholder(context, "Set & Album Completions", minHeight: 220);
  }
}

/// Wishlist summary (right column)
class WishlistSummary extends StatelessWidget {
  const WishlistSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return _glassPlaceholder(context, "Wishlist Summary", minHeight: 220);
  }
}

/// Incoming/outgoing quick status
class IncomingOutgoingSection extends StatelessWidget {
  const IncomingOutgoingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _glassPlaceholder(context, "Incoming / Outgoing (trades & deliveries)", minHeight: 110);
  }
}

/// Activity graph placeholder
class ActivityGraph extends StatelessWidget {
  const ActivityGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return _glassPlaceholder(context, "Activity Graph (daily/weekly)", minHeight: 220);
  }
}

/// Insights section placeholder
class InsightsSection extends StatelessWidget {
  const InsightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _glassPlaceholder(context, "Collection Insights (smart stats)", minHeight: 220);
  }
}

/// Recently added scroller placeholder
class RecentlyAddedScroller extends StatelessWidget {
  const RecentlyAddedScroller({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "Recently added",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              return SizedBox(width: 120, child: _glassPlaceholder(context, "Card $i", minHeight: 120));
            },
          ),
        ),
      ],
    );
  }
}

/// Achievements placeholder
class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _glassPlaceholder(context, "Achievements & Milestones", minHeight: 120);
  }
}

/// Recommendations placeholder
class RecommendationsSection extends StatelessWidget {
  const RecommendationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _glassPlaceholder(context, "Recommendations & Suggestions", minHeight: 140);
  }
}

/// Backup / export placeholder
class BackupExportSection extends StatelessWidget {
  const BackupExportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _glassPlaceholder(context, "Backup & Export", minHeight: 96);
  }
}
