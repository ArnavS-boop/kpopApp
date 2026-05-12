import 'package:antipattern/widgets/glass_container.dart';
import 'package:antipattern/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class SearchAndFilterRow extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final VoidCallback onOpenFilters;

  const SearchAndFilterRow({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onOpenFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSearchBar(
            controller: controller,
            onChanged: onSearch,
          ),
        ),
        const SizedBox(width: 12),
        _FilterButton(onTap: onOpenFilters),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final VoidCallback onTap;
  const _FilterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: BorderRadius.circular(100),
        padding: EdgeInsets.zero,
        tint: null,        // neutral surface
        showShadow: true,  // subtle elevation
        child: SizedBox(
          height: 42,
          width: 42,
          child: Center(
            child: Icon(
              Icons.filter_list_rounded,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}