import 'dart:math' as math;
import 'package:flutter/material.dart';

class CardSkeleton extends StatefulWidget {
  const CardSkeleton({super.key});

  @override
  State<CardSkeleton> createState() => _CardSkeletonState();
}

class _CardSkeletonState extends State<CardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900), // ⭐ slower, more premium
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.62,
      child: LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final highlightWidth = math.max(w, h) * 1.8; // ⭐ slightly wider

        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // softened pastel base
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF1E7FF),
                      Color(0xFFEDE4FF),
                      Color(0xFFF5EEFF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final t = (_controller.value * 2) - 1;
                  final dx = t * (w + highlightWidth) / 2;

                  return Transform.translate(
                    offset: Offset(dx, 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Transform.rotate(
                        angle: -0.33,
                        child: Container(
                          width: highlightWidth,
                          height: h * 1.3,

                          // ⭐ NEW, MORE PROMINENT SHINE
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.00),
                                Colors.white.withOpacity(0.18), // brighter
                                Colors.white.withOpacity(0.35), // ⭐ stronger core
                                Colors.white.withOpacity(0.18),
                                Colors.white.withOpacity(0.00),
                              ],
                              stops: const [0.20, 0.40, 0.50, 0.60, 0.80],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // micro overlay to keep the palette soft
              Container(
                color: Colors.white.withOpacity(0.02),
              )
            ],
          ),
        );
      }),
    );
  }
}
