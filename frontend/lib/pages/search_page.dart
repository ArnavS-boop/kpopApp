
import 'dart:ui';

import 'package:antipattern/models/photocards.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/listing_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Accent colors
const Color _purpleAccent = Color(0xFFB590F7); // tags, meta tags, proofs
const Color _yellowAccent = Color(0xFFF5D565); // sort-by
const Color _blueAccent = Color(0xFF00C8FF);   // verified seller only

class SearchPage extends StatefulWidget {
  final String initialQuery;

  const SearchPage({
    super.key,
    this.initialQuery = '',
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // ----------------------------------------------------------
  // SEARCH + SORT + PRICE
  // ----------------------------------------------------------
  late TextEditingController _searchController;

  String query = '';
  double minPrice = 0;
  double maxPrice = _priceMax;
  static const double _priceMin = 0;
  static const double _priceMax = 5000;

  String sortBy = "Relevance";

  // ----------------------------------------------------------
  // FILTER STATE
  // ----------------------------------------------------------
  bool onlyVerified = false;
  bool onlyProofs = false;

  String? selectedLocation;
  final Set<String> selectedShipsTo = {};
  final Set<String> selectedShippingMethods = {};
  final Set<String> selectedLanguages = {};

  final Set<String> selectedTags = {};
  final Set<String> selectedGroups = {};
  final Set<String> selectedMembers = {};
  final Set<String> selectedAlbums = {};
  final Set<String> selectedEras = {};
  final Set<String> selectedCardTypes = {};
  final Set<String> selectedRarities = {};

  // ----------------------------------------------------------
  // TAG SEARCH FIELDS (inside filter sheet)
  // ----------------------------------------------------------
  String tagSearch = '';
  String groupSearch = '';
  String memberSearch = '';
  String albumSearch = '';
  String eraSearch = '';
  String raritySearch = '';
  String cardTypeSearch = '';

  // ----------------------------------------------------------
  // DERIVED MASTER LISTS (from dummyListings)
  // ----------------------------------------------------------
  late final List<String> allLocations;
  late final List<String> allShipsTo;
  late final List<String> allShippingMethods;
  late final List<String> allLanguages;
  late final List<String> allTags;
  late final List<String> allGroups;
  late final List<String> allMembers;
  late final List<String> allAlbums;
  late final List<String> allEras;
  late final List<String> allCardTypes;
  late final List<String> allRarities;

  @override
  void initState() {
    super.initState();
    query = widget.initialQuery;
    _searchController = TextEditingController(text: widget.initialQuery);

    // Build master sets from dummyListings
    final locSet = <String>{};
    final shipToSet = <String>{};
    final shipMethodSet = <String>{};
    final langSet = <String>{};
    final tagSet = <String>{};
    final groupSet = <String>{};
    final memberSet = <String>{};
    final albumSet = <String>{};
    final eraSet = <String>{};
    final cardTypeSet = <String>{};
    final raritySet = <String>{};

    for (final item in dummyListings) {
      if (item.location.trim().isNotEmpty) {
        locSet.add(item.location.trim());
      }
      for (final d in item.deliversTo) {
        if (d.trim().isNotEmpty) shipToSet.add(d.trim());
      }
      if ((item.shippingMethod ?? '').trim().isNotEmpty) {
        shipMethodSet.add(item.shippingMethod!.trim());
      }
      if ((item.language ?? '').trim().isNotEmpty) {
        langSet.add(item.language!.trim());
      }
      for (final t in item.tags) {
        final clean = t.trim();
        if (clean.isNotEmpty) tagSet.add(clean);
      }
      if ((item.group ?? '').trim().isNotEmpty) groupSet.add(item.group!.trim());
      if ((item.member ?? '').trim().isNotEmpty) {
        memberSet.add(item.member!.trim());
      }
      if ((item.album ?? '').trim().isNotEmpty) albumSet.add(item.album!.trim());
      if ((item.era ?? '').trim().isNotEmpty) eraSet.add(item.era!.trim());
      if ((item.cardType ?? '').trim().isNotEmpty) {
        cardTypeSet.add(item.cardType!.trim());
      }
      if ((item.rarity ?? '').trim().isNotEmpty) {
        raritySet.add(item.rarity!.trim());
      }
    }

    allLocations = locSet.toList()..sort();
    allShipsTo = shipToSet.toList()..sort();
    allShippingMethods = shipMethodSet.toList()..sort();
    allLanguages = langSet.toList()..sort();
    allTags = tagSet.toList()..sort();
    allGroups = groupSet.toList()..sort();
    allMembers = memberSet.toList()..sort();
    allAlbums = albumSet.toList()..sort();
    allEras = eraSet.toList()..sort();
    allCardTypes = cardTypeSet.toList()..sort();
    allRarities = raritySet.toList()..sort();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // FILTERED RESULTS
  // ----------------------------------------------------------
  List<Listings> get _filteredResults {
    final q = query.toLowerCase();

    List<Listings> list = dummyListings.where((item) {
      // TEXT SEARCH
      final textHit = q.isEmpty ||
          item.title.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q) ||
          item.itemName.toLowerCase().contains(q) ||
          (item.group ?? '').toLowerCase().contains(q) ||
          (item.member ?? '').toLowerCase().contains(q);

      if (!textHit) return false;

      // PRICE (top end can be "unbounded")
      final priceOkLower = item.price >= minPrice;
      final priceOkUpper =
          (maxPrice >= _priceMax) ? true : item.price <= maxPrice;
      if (!priceOkLower || !priceOkUpper) return false;

      // VERIFIED
      if (onlyVerified && !item.verifiedSeller) return false;

      // PROOFS
      if (onlyProofs) {
        final hasProof = item.tags.any(
          (t) => t.toLowerCase() == 'proofs' || t.toLowerCase().contains('proof'),
        );
        if (!hasProof) return false;
      }

      // LOCATION
      if (selectedLocation != null && selectedLocation!.isNotEmpty) {
        if (item.location != selectedLocation) return false;
      }

      // DELIVERS TO
      if (selectedShipsTo.isNotEmpty) {
        final hit =
            item.deliversTo.any((d) => selectedShipsTo.contains(d.trim()));
        if (!hit) return false;
      }

      // SHIPPING METHODS
      if (selectedShippingMethods.isNotEmpty) {
        final method = item.shippingMethod;
        if (method == null ||
            !selectedShippingMethods.contains(method.trim())) {
          return false;
        }
      }

      // LANGUAGES
      if (selectedLanguages.isNotEmpty) {
        final lang = item.language;
        if (lang == null || !selectedLanguages.contains(lang.trim())) {
          return false;
        }
      }

      // GENERAL TAGS
      if (selectedTags.isNotEmpty) {
        final tagHit = item.tags.any((t) => selectedTags.contains(t.trim()));
        if (!tagHit) return false;
      }

      // GROUP / MEMBER / ALBUM / ERA / CARD TYPE / RARITY
      bool matchOptionalSet(Set<String> selected, String? field) {
        if (selected.isEmpty) return true;
        if (field == null) return false;
        return selected.contains(field.trim());
      }

      if (!matchOptionalSet(selectedGroups, item.group)) return false;
      if (!matchOptionalSet(selectedMembers, item.member)) return false;
      if (!matchOptionalSet(selectedAlbums, item.album)) return false;
      if (!matchOptionalSet(selectedEras, item.era)) return false;
      if (!matchOptionalSet(selectedCardTypes, item.cardType)) return false;
      if (!matchOptionalSet(selectedRarities, item.rarity)) return false;

      return true;
    }).toList();

    // SORTING
    switch (sortBy) {
      case "Price: Low → High":
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case "Price: High → Low":
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case "Newest":
        list.shuffle(); // placeholder until you add timestamps
        break;
      case "Relevance":
      default:
        break;
    }

    return list;
  }

  // ----------------------------------------------------------
  // FILTER SHEET
  // ----------------------------------------------------------
void _openFilters() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (context) {

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {

          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;

          final sheetBg1 =
              isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.25);
          final sheetBg2 =
              isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.18);
          final borderColor =
              isDark ? Colors.white.withOpacity(0.30) : Colors.white.withOpacity(0.55);

          void update(VoidCallback fn) {
            setModalState(() {
              setState(fn);
            });
          }

          return DraggableScrollableSheet(
            initialChildSize: 0.78,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            builder: (_, controller) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [sheetBg1, sheetBg2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: borderColor, width: 1.3),
                    ),
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      children: [

                        /// TITLE ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Filters",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => update(() {
                                minPrice = _priceMin;
                                maxPrice = _priceMax;
                                sortBy = "Relevance";
                                onlyVerified = false;
                                onlyProofs = false;
                                selectedLocation = null;
                                selectedShipsTo.clear();
                                selectedShippingMethods.clear();
                                selectedLanguages.clear();
                                selectedTags.clear();
                                selectedGroups.clear();
                                selectedMembers.clear();
                                selectedAlbums.clear();
                                selectedEras.clear();
                                selectedCardTypes.clear();
                                selectedRarities.clear();
                                tagSearch = '';
                                groupSearch = '';
                                memberSearch = '';
                                albumSearch = '';
                                eraSearch = '';
                                raritySearch = '';
                                cardTypeSearch = '';
                              }),
                              child: const Text("Clear all"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// VERIFIED / PROOFS
                        Row(
                          children: [
                            _GlassTogglePill(
                              label: "Verified seller",
                              icon: Icons.verified_rounded,
                              selected: onlyVerified,
                              accentColor: _blueAccent,
                              onChanged: (v) => update(() => onlyVerified = v),
                            ),
                            const SizedBox(width: 12),
                            _GlassTogglePill(
                              label: "Proofs",
                              icon: Icons.photo_library_rounded,
                              selected: onlyProofs,
                              accentColor: _purpleAccent,
                              onChanged: (v) => update(() => onlyProofs = v),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        /// PRICE
                        _SectionLabel("Price (\$)"),
                        RangeSlider(
                          values: RangeValues(minPrice, maxPrice),
                          min: _priceMin,
                          max: _priceMax,
                          divisions: 50,
                          onChanged: (range) =>
                              update(() {
                                minPrice = range.start;
                                maxPrice = range.end;
                              }),
                        ),

                        const SizedBox(height: 16),

                        /// SORT
                        _SectionLabel("Sort by"),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            "Relevance",
                            "Price: Low → High",
                            "Price: High → Low",
                            "Newest",
                          ].map((s) {
                            return _SelectableChip(
                              label: s,
                              selected: sortBy == s,
                              accentColor: _yellowAccent,
                              onTap: () => update(() => sortBy = s),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 18),

                        /// LOCATION
                        _SectionLabel("Seller location"),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: allLocations.map((loc) {
                            final selected = selectedLocation == loc;
                            return _SelectableChip(
                              label: loc,
                              selected: selected,
                              accentColor: _purpleAccent,
                              onTap: () => update(() {
                                selectedLocation = selected ? null : loc;
                              }),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 22),

                        /// META TAG EXAMPLE
                        _buildMetaTagSection(
                          title: "Group",
                          allValues: allGroups,
                          searchValue: groupSearch,
                          selectedSet: selectedGroups,
                          onSearchChanged: (v) =>
                              update(() => groupSearch = v.toLowerCase()),
                          setModalState: setModalState,
                        ),

                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}

Widget _buildMetaTagSection({
  required String title,
  required List<String> allValues,
  required String searchValue,
  required ValueChanged<String> onSearchChanged,
  required Set<String> selectedSet,
  required StateSetter setModalState,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _SectionLabel(title),
      const SizedBox(height: 6),

      _MiniSearchField(
        hint: "Search $title…",
        onChanged: (v) => setModalState(() {
          setState(() => onSearchChanged(v));
        }),
      ),

      const SizedBox(height: 8),

      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: allValues
            .where((v) =>
                searchValue.isEmpty ? true : v.toLowerCase().contains(searchValue))
            .map((v) {

          final selected = selectedSet.contains(v);

          return _SelectableChip(
            label: v,
            selected: selected,
            accentColor: _purpleAccent,
            onTap: () {
              setModalState(() {
                setState(() {
                  if (selected) {
                    selectedSet.remove(v);
                  } else {
                    selectedSet.add(v);
                  }
                });
              });
            },
          );
        }).toList(),
      ),
    ],
  );
}

  // ----------------------------------------------------------
  // UI
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final results = _filteredResults;
    final theme = Theme.of(context);

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Column(
              children: [
                // HEADER ROW: back + search + filter
                Row(
                  children: [
                    _CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => context.pop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SearchFieldGlass(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() => query = value);
                        },
                        onSubmitted: (value) {
                          setState(() => query = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    _CircleIconButton(
                      icon: Icons.filter_list_rounded,
                      onTap: _openFilters,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // RESULTS
                Expanded(
                  child: results.isEmpty
                      ? Center(
                          child: Text(
                            "No results found",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.62,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                          itemCount: results.length,
                          itemBuilder: (_, i) {
                            final item = results[i];
                            return ListingCard(
                              id: item.id,
                              title: item.title,
                              subtitle: item.description,
                              imageUrl: item.imageUrls.isNotEmpty
                                  ? item.imageUrls.first
                                  : '',
                              price: item.price,
                            );
                          },
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

// ----------------------------------------------------------
// SMALL UI PIECES
// ----------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _MiniSearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const _MiniSearchField({
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
            isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.03),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(Icons.search_rounded,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.6)),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isCollapsed: true,
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton> {
  double _scale = 1.0;

  void _down() => setState(() => _scale = 0.92);
  void _up() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final base =
        isDark ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.45);
    final edge =
        isDark ? Colors.white.withOpacity(0.25) : Colors.white.withOpacity(0.55);
    final gloss =
        isDark ? Colors.white.withOpacity(0.06) : Colors.white.withOpacity(0.25);

    return Listener(
      onPointerDown: (_) => _down(),
      onPointerUp: (_) => _up(),
      onPointerCancel: (_) => _up(),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: edge, width: 1.2),
              gradient: LinearGradient(
                colors: [base, base.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 16,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [gloss, Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    widget.icon,
                    size: 20,
                    color: theme.colorScheme.onSurface,
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

class _SearchFieldGlass extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const _SearchFieldGlass({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final base =
        isDark ? Colors.white.withOpacity(0.10) : Colors.white.withOpacity(0.55);
    final edge =
        isDark ? Colors.white.withOpacity(0.22) : Colors.white.withOpacity(0.40);

    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: edge, width: 1.1),
        gradient: LinearGradient(
          colors: [base, base.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(Icons.search_rounded,
              size: 18,
              color: theme.colorScheme.onSurface.withOpacity(0.7)),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.9),
              ),
              decoration: InputDecoration(
                hintText: "Search photocards, sellers, tags...",
                border: InputBorder.none,
                isCollapsed: true,
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                onChanged('');
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurface.withOpacity(0.55),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Generic chip that can be styled via accentColor
class _SelectableChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color accentColor; // purple / yellow depending on context

  const _SelectableChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.accentColor,
  });

  @override
  State<_SelectableChip> createState() => _SelectableChipState();
}

class _SelectableChipState extends State<_SelectableChip> {
  double _scale = 1.0;

  void _down() => setState(() => _scale = 0.94);
  void _up() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Strong visual difference between selected & not
    final Color bg = widget.selected
        ? (isDark
            ? widget.accentColor.withOpacity(0.9)
            : widget.accentColor.withOpacity(0.95))
        : (isDark
            ? Colors.white.withOpacity(0.04)
            : Colors.white.withOpacity(0.9));

    final Color border = widget.selected
        ? widget.accentColor
        : (isDark
            ? Colors.white.withOpacity(0.18)
            : Colors.black.withOpacity(0.08));

    // Text color – yellow wants dark text on light
    final bool useDarkTextOnAccent =
        widget.accentColor == _yellowAccent && !isDark;

    final Color textColor = widget.selected
        ? (useDarkTextOnAccent ? Colors.black : Colors.white)
        : theme.colorScheme.onSurface.withOpacity(0.78);

    final Color checkColor =
        useDarkTextOnAccent ? Colors.black : Colors.white;

    return Listener(
      onPointerDown: (_) => _down(),
      onPointerUp: (_) => _up(),
      onPointerCancel: (_) => _up(),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 110),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: bg,
              border: Border.all(color: border, width: 1.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.selected) ...[
                  Icon(Icons.check_rounded,
                      size: 14, color: checkColor),
                  const SizedBox(width: 4),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        widget.selected ? FontWeight.w600 : FontWeight.w400,
                    color: textColor,
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

class _GlassTogglePill extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final ValueChanged<bool> onChanged;
  final Color accentColor; // blue for verified, purple for proofs

  const _GlassTogglePill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onChanged,
    required this.accentColor,
  });

  @override
  State<_GlassTogglePill> createState() => _GlassTogglePillState();
}

class _GlassTogglePillState extends State<_GlassTogglePill> {
  double _scale = 1.0;

  void _down() => setState(() => _scale = 0.94);
  void _up() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = widget.selected
        ? (isDark
            ? widget.accentColor.withOpacity(0.9)
            : widget.accentColor.withOpacity(0.95))
        : (isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.9));

    final Color border = widget.selected
        ? widget.accentColor
        : (isDark
            ? Colors.white.withOpacity(0.18)
            : Colors.black.withOpacity(0.08));

    final Color iconTextColor =
        widget.selected ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.7);

    return Expanded(
      child: Listener(
        onPointerDown: (_) => _down(),
        onPointerUp: (_) => _up(),
        onPointerCancel: (_) => _up(),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 110),
          child: GestureDetector(
            onTap: () => widget.onChanged(!widget.selected),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: bg,
                border: Border.all(color: border, width: 1.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 16,
                    color: iconTextColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: iconTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}