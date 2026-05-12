import 'package:flutter/material.dart';

// Centralized theme tokens and ThemeData builders.
// TODO: Expand tokens as the app needs more semantic colors.

@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  final Color glassBackground;
  final Color glassBorder;
  final Color barrier;
  final Color actionOverlay;
  final Color destructive;
  final Color splash;
  final Color placeholder;
  final Color glassShadow;

  const AppTokens({
    required this.glassBackground,
    required this.glassBorder,
    required this.barrier,
    required this.actionOverlay,
    required this.destructive,
    required this.splash,
    required this.placeholder,
    required this.glassShadow,
  });

  @override
  AppTokens copyWith({
    Color? glassBackground,
    Color? glassBorder,
    Color? barrier,
    Color? actionOverlay,
    Color? destructive,
    Color? splash,
    Color? placeholder,
    Color? glassShadow,
  }) {
    return AppTokens(
      glassBackground: glassBackground ?? this.glassBackground,
      glassBorder: glassBorder ?? this.glassBorder,
      barrier: barrier ?? this.barrier,
      actionOverlay: actionOverlay ?? this.actionOverlay,
      destructive: destructive ?? this.destructive,
      splash: splash ?? this.splash,
      placeholder: placeholder ?? this.placeholder,
      glassShadow: glassShadow ?? this.glassShadow,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      glassBackground: Color.lerp(glassBackground, other.glassBackground, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      barrier: Color.lerp(barrier, other.barrier, t)!,
      actionOverlay: Color.lerp(actionOverlay, other.actionOverlay, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      splash: Color.lerp(splash, other.splash, t)!,
      placeholder: Color.lerp(placeholder, other.placeholder, t)!,
      glassShadow: Color.lerp(glassShadow, other.glassShadow, t)!,
    );
  }
}

ThemeData buildLightTheme() {
  final base = ThemeData.light();

  const tokens = AppTokens(
    glassBackground: Color.fromRGBO(255, 255, 255, 0.25),
    glassBorder: Color.fromRGBO(255, 255, 255, 0.45),
    barrier: Color.fromRGBO(0, 0, 0, 0.55),
    actionOverlay: Color.fromRGBO(0, 0, 0, 0.45),
    destructive: Colors.redAccent,
    splash: Color.fromRGBO(0, 150, 136, 0.1),
    placeholder: Color(0xFFEEEEEE),
    glassShadow: Color.fromRGBO(0, 0, 0, 0.25),
  );

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: const Color(0xFF0066CC),
      secondary: const Color(0xFF00BFA5),
      surface: Colors.white,
      onSurface: Colors.black87,
    ),
    textTheme: base.textTheme.apply(bodyColor: Colors.black87),
    extensions: [tokens],
  );
}

ThemeData buildDarkTheme() {
  final base = ThemeData.dark();

  const tokens = AppTokens(
    glassBackground: Color.fromRGBO(255, 255, 255, 0.07),
    glassBorder: Color.fromRGBO(255, 255, 255, 0.12),
    barrier: Color.fromRGBO(0, 0, 0, 0.85),
    actionOverlay: Color.fromRGBO(0, 0, 0, 0.45),
    destructive: Colors.redAccent,
    splash: Color.fromRGBO(0, 150, 136, 0.08),
    placeholder: Color(0xFF1F1F1F),
    glassShadow: Color.fromRGBO(0, 0, 0, 0.4),
  );

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: const Color(0xFF66A6FF),
      secondary: const Color(0xFF4DD0E1),
      surface: const Color(0xFF121212),
      onSurface: Colors.white,
    ),
    textTheme: base.textTheme.apply(bodyColor: Colors.white),
    extensions: [tokens],
  );
}

// Convenience getter
AppTokens appTokens(BuildContext context) {
  final ext = Theme.of(context).extension<AppTokens>();
  if (ext == null) throw Exception('AppTokens not found in ThemeData.extensions');
  return ext;
}
