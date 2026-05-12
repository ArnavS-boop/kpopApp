import 'package:flutter/material.dart';

class FeaturedCollection {
  final String id;
  final String slug;
  final String title;
  final String? subtitle;

  final String? backgroundUrl;
  final String? overlayHex;
  final List<Color>? gradient;

  /// 🔹 NEW STYLE OPTIONS
  final String? fontFamily;
  final Color? titleColor;
  final Color? subtitleColor;

  const FeaturedCollection({
    required this.id,
    required this.slug,
    required this.title,
    this.subtitle,
    this.backgroundUrl,
    this.overlayHex,
    this.gradient,
    this.fontFamily,
    this.titleColor,
    this.subtitleColor,
  });
}