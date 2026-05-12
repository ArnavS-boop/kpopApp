import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:antipattern/theme/app_theme.dart';

const Color purpleAccent = Color(0xFFB590F7);
const Color yellowAccent = Color(0xFFF5D565);
const Color blueAccent   = Color(0xFF00C8FF);

class SearchFilterMenu extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onClose;
  final Widget content;

  const SearchFilterMenu({
    super.key,
    required this.onClear,
    required this.onClose,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = appTokens(context);

    // TODO: Consider moving `purpleAccent`, `yellowAccent`, `blueAccent`
    //       into `AppTokens` if they are used across the app.

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
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
                  colors: [
                    tokens.glassBackground,
                    tokens.glassBackground.withOpacity(isDark ? 0.5 : 0.9),
                  ],
                ),
                border: Border.all(
                  color: tokens.glassBorder,
                  width: 1.2,
                ),
              ),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      width: 52,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: tokens.glassBackground.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filters",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: onClear,
                        child: const Text("Clear all"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  content,
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: onClose,
                    child: const Text("Apply filters"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
