import 'package:antipattern/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class GlassField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const GlassField({super.key, 
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}