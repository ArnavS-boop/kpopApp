import 'package:antipattern/models/photocards.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class OrderButton extends StatefulWidget {
  final Listings product;

  const OrderButton({super.key, required this.product});

  @override
  State<OrderButton> createState() => OrderButtonState();
}

class OrderButtonState extends State<OrderButton> {
  double _scale = 1.0;

  void _down() => setState(() => _scale = 0.94);
  void _up() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _down(),
      onPointerUp: (_) => _up(),
      onPointerCancel: (_) => _up(),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: GestureDetector(
          onTap: () {
            debugPrint("Ordering ${widget.product.title}");
            // TODO: integrate order flow
          },
          child: GlassContainer(
            borderRadius: BorderRadius.circular(20),
            tint: null,
            showShadow: false,
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 10,
            ),
            child: const Text(
              "Order Now",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}