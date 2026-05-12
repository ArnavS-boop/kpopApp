import 'package:flutter/material.dart';

class BottomMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  BottomMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

void showUniversalBottomMenu(BuildContext context, List<BottomMenuItem> items) {
  showModalBottomSheet(
    context: context,
    // Use theme surface so the bottom sheet respects light/dark mode.
    backgroundColor: Theme.of(context).colorScheme.surface,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------- CANCEL BUTTON (TOP LEFT) ----------
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0),
              ),
              child: const Text(
                "Cancel",
                // TODO: Localize this label and use theme for text color.
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 4),
            Divider(height: 1, thickness: 0.8, color: Theme.of(context).dividerColor),

            const SizedBox(height: 8),

            // ---------- MENU ITEMS ----------
            ...items.map((item) => Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.pop(context);
                    item.onTap();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Icon(item.icon,
                          size: 20,
                          color: Theme.of(context).iconTheme.color ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.85)),
                        const SizedBox(width: 14),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 14.5,
                            // TODO: Use theme text color tokens here.
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Divider between menu items
                Divider(
                  height: 1,
                  thickness: 0.6,
                  color: Theme.of(context).dividerColor,
                ),
              ],
            )),

            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
