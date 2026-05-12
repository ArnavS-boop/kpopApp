import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final VoidCallback onChangeAvatar;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.avatarUrl,
    required this.onChangeAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 42,
                // TODO: Handle remote avatar loading/fallback and avoid
                //       passing raw URLs directly. Consider using an
                //       abstraction that returns ImageProvider and
                //       supports local placeholders.
                backgroundImage: NetworkImage(avatarUrl),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onChangeAvatar,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                    ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 16,
                        // use onPrimary to ensure contrast on primary
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              username,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
