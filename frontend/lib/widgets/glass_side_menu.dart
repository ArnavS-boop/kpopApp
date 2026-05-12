import 'dart:ui';
import 'package:antipattern/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antipattern/theme/app_theme.dart';

void showGlassSideMenu(
  BuildContext context, {
  ProfileData? profile,
  required ValueChanged<bool> onThemeChanged,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: appTokens(context).barrier,
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, _, child) {
      final slide = Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      );

      return Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
          SlideTransition(
            position: slide,
            child: Align(
              alignment: Alignment.centerLeft,
                child: Material(
                type: MaterialType.transparency,
                child: _GlassMenuPanel(
                  profile: profile ?? currentUserProfile,
                  onThemeChanged: onThemeChanged,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _GlassMenuPanel extends StatelessWidget {
  final ProfileData profile;
  final ValueChanged<bool> onThemeChanged;

  const _GlassMenuPanel({
    required this.profile,
    required this.onThemeChanged,
  });

  bool get isSeller => profile.isSeller;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final tokens = appTokens(context);

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.72,
        height: double.infinity,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              decoration: BoxDecoration(
                color: tokens.glassBackground,
                border: Border(
                  right: BorderSide(
                    color: tokens.glassBorder,
                    width: 1.2,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: tokens.glassShadow,
                    blurRadius: 18,
                    offset: const Offset(4, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Future.delayed(const Duration(milliseconds: 80), () {
                        context.push('/account');
                      });
                    },
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?img=32',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NyanCat',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            Text(
                              'View Profile',
                              style: TextStyle(
                                fontSize: 13,
                                color: textColor.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  _menuItem(
                    context,
                    Icons.favorite_rounded,
                    'Wishlist',
                    () {
                      Navigator.of(context).pop();
                      Future.delayed(const Duration(milliseconds: 80), () {
                        context.push('/wishlist');
                      });
                    },
                  ),
                  _menuItem(
                    context,
                    Icons.receipt_long_rounded,
                    'Orders',
                    () {Navigator.of(context).pop();
                      Future.delayed(const Duration(milliseconds: 80), () {
                        context.push('/orders');
                      });
                    },
                  ),
                  _menuItem(
                    context,
                    Icons.chat_bubble_rounded,
                    'Messages',
                    () {
                      Navigator.of(context).pop();
                      Future.delayed(const Duration(milliseconds: 80), () {
                        context.push('/chat');
                      });
                    },
                  ),
                  // ================= ACCOUNT LINKS =================

                  _menuItem(
                    context,
                    Icons.edit_rounded,
                    'Edit Profile',
                    () {
                      Navigator.of(context).pop();
                      Future.delayed(const Duration(milliseconds: 80), () {
                        context.push('/account/edit');
                      });
                    },
                  ),

                  _menuItem(
                    context,
                    Icons.settings_rounded,
                    'Settings',
                    () {
                      Navigator.of(context).pop();
                      Future.delayed(const Duration(milliseconds: 80), () {
                        context.push('/account/settings');
                      });
                    },
                  ),

                  // ================= SELLER LINKS =================

                  if (isSeller) ...[

                    const Divider(),

                    _menuItem(
                      context,
                      Icons.inventory_2_outlined,
                      'Manage Listings',
                      () {
                        Navigator.of(context).pop();
                        Future.delayed(const Duration(milliseconds: 80), () {
                          context.push('/seller/${profile.id}/listings');
                        });
                      },
                    ),

                    _menuItem(
                      context,
                      Icons.analytics_outlined,
                      'Sales Analytics',
                      () {
                        Navigator.of(context).pop();
                        Future.delayed(const Duration(milliseconds: 80), () {
                          context.push('/seller/${profile.id}/analytics');
                        });
                      },
                    ),

                    _menuItem(
                      context,
                      Icons.storefront_outlined,
                      'My Storefront',
                      () {
                        Navigator.of(context).pop();
                        Future.delayed(const Duration(milliseconds: 80), () {
                          context.push('/seller/${profile.id}');
                        });
                      },
                    ),
                  ],

                  const Divider(),

                  Text(
                    'Theme',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _themeButton(
                        context,
                        'Light',
                        Icons.light_mode_rounded,
                        false,
                      ),
                      const SizedBox(width: 12),
                      _themeButton(
                        context,
                        'Dark',
                        Icons.dark_mode_rounded,
                        true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22, color: textColor),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeButton(
    BuildContext context,
    String label,
    IconData icon,
    bool isDark,
  ) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final tokens = appTokens(context);

    return Expanded(
      child: GestureDetector(
        onTap: () => onThemeChanged(isDark),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: tokens.glassBackground,
            border: Border.all(
              color: tokens.glassBorder,
              width: 1.0,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: textColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
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