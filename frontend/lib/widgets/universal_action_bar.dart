import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:antipattern/widgets/glass_container.dart';

class TopOverlayActionBar extends StatefulWidget {
  final IconData backIcon;
  final IconData menuIcon;
  final VoidCallback? onMenu;
  final String? title; // ✅ NEW

  const TopOverlayActionBar({
    super.key,
    this.backIcon = Icons.arrow_back_ios_new_rounded,
    this.menuIcon = Icons.more_vert,
    this.onMenu,
    this.title, // ✅ NEW
  });

  @override
  State<TopOverlayActionBar> createState() => _TopOverlayActionBarState();
}

class _TopOverlayActionBarState extends State<TopOverlayActionBar> {
  bool _busy = false;

  Future<void> _handleBack(BuildContext ctx) async {
    if (_busy) return;

    setState(() => _busy = true);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final router = GoRouter.of(ctx);
        if (router.canPop()) {
          router.pop();
        } else if (Navigator.of(ctx).canPop()) {
          Navigator.of(ctx).pop();
        }
      } finally {
        await Future.delayed(const Duration(milliseconds: 250));
        if (mounted) setState(() => _busy = false);
      }
    });
  }

  void _handleMenu(BuildContext ctx) {
    if (_busy) return;
    widget.onMenu?.call();
  }

  @override
  Widget build(BuildContext context) {
    // Build the core bar content
    final bar = SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            /// BACK BUTTON
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _handleBack(context),
              child: _glassCircleButton(icon: widget.backIcon),
            ),

            /// TITLE (optional)
            if (widget.title != null) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ] else
              const Spacer(),

            /// MENU BUTTON (only if provided)
            if (widget.onMenu != null)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _handleMenu(context),
                child: _glassCircleButton(icon: widget.menuIcon),
              )
            else
              const SizedBox(width: 40), // keeps layout balanced
          ],
        ),
      ),
    );

    // If the bar is used inside a Stack, position it at the top.
    // Use the render-object tree to robustly detect an enclosing Stack.
    final inStack = context.findAncestorRenderObjectOfType<RenderStack>() != null;
    return inStack
        ? Positioned(top: 0, left: 0, right: 0, child: bar)
        : bar;
  }

  Widget _glassCircleButton({required IconData icon}) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlassContainer(
      borderRadius: BorderRadius.circular(100),
      padding: EdgeInsets.zero,
      tint: null,
      showShadow: true,
      child: SizedBox(
        height: 40,
        width: 40,
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}