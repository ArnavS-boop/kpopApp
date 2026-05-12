import 'package:antipattern/main.dart';
import 'package:antipattern/widgets/glass_side_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'glass_container.dart';

class AppSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hint;

  const AppSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hint = "Search...",
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  double _hamburgerScale = 1.0;
  double _searchScale = 1.0;

  static const double _barHeight = 36;

  void _submitSearch() {
    final q = widget.controller.text.trim();
    if (q.isEmpty) return;

    context.push('/search?query=${Uri.encodeComponent(q)}');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // ☰ MENU BUTTON
        Listener(
          onPointerDown: (_) => setState(() => _hamburgerScale = 0.94),
          onPointerUp: (_) => setState(() => _hamburgerScale = 1.0),
          onPointerCancel: (_) => setState(() => _hamburgerScale = 1.0),
          child: AnimatedScale(
            scale: _hamburgerScale,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: _glassCircleButton(
              icon: Icons.menu_rounded,
              onTap: () => showGlassSideMenu(
                context,
                onThemeChanged: (isDark) {
                  themeController.setTheme(isDark);
                },
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // 🔍 SEARCH FIELD
        Expanded(
          child: GlassContainer(
            borderRadius: BorderRadius.circular(20),
            padding: EdgeInsets.zero,
            tint: null,
            showShadow: true,
            child: SizedBox(
              height: _barHeight,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      onChanged: (v) {
                        widget.onChanged?.call(v);
                        setState(() {});
                      },
                      onSubmitted: (_) => _submitSearch(),
                      style: TextStyle(
                        fontSize: 13.5,
                        color:
                            colorScheme.onSurface.withOpacity(0.9),
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: widget.hint,
                        hintStyle: TextStyle(
                          color: colorScheme.onSurface
                              .withOpacity(0.5),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (widget.controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        widget.controller.clear();
                        widget.onChanged?.call('');
                        setState(() {});
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: colorScheme.onSurface
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // 🔎 SEARCH BUTTON
        Listener(
          onPointerDown: (_) => setState(() => _searchScale = 0.94),
          onPointerUp: (_) => setState(() => _searchScale = 1.0),
          onPointerCancel: (_) => setState(() => _searchScale = 1.0),
          child: AnimatedScale(
            scale: _searchScale,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: _glassCircleButton(
              icon: Icons.search_rounded,
              onTap: _submitSearch,
            ),
          ),
        ),
      ],
    );
  }

  Widget _glassCircleButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: BorderRadius.circular(100),
        padding: EdgeInsets.zero,
        tint: null,
        showShadow: true,
        child: SizedBox(
          height: _barHeight,
          width: _barHeight,
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}