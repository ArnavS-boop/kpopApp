import 'package:antipattern/models/photocards.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatButton extends StatefulWidget {
  final Listings product;

  const ChatButton({super.key, required this.product});

  @override
  State<ChatButton> createState() => ChatButtonState();
}

class ChatButtonState extends State<ChatButton> {
  double _scale = 1.0;

  void _down() => setState(() => _scale = 0.92);
  void _up() => setState(() => _scale = 1.0);

  void _openChat() {
    final sellerId = widget.product.sellerName;

    context.push(
      '/chat/$sellerId',
    );
  }

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
          onTap: _openChat,
          child: GlassContainer(
            borderRadius: BorderRadius.circular(100),
            tint: const Color(0xFF00C8FF),
            shadowOverride:
                const Color(0xFF00C8FF).withOpacity(0.35),
            padding: const EdgeInsets.all(10),
            showShadow: true,
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}