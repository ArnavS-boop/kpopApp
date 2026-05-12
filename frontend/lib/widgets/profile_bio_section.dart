import 'package:flutter/material.dart';

class ProfileBioSection extends StatefulWidget {
  final String bio;
  final VoidCallback onEdit;

  const ProfileBioSection({
    super.key,
    required this.bio,
    required this.onEdit,
  });

  @override
  State<ProfileBioSection> createState() => _ProfileBioSectionState();
}

class _ProfileBioSectionState extends State<ProfileBioSection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.85);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => expanded = !expanded),
            child: Text(
              widget.bio.isEmpty
                  ? "You haven’t added a bio yet."
                  : widget.bio,
              maxLines: expanded ? null : 3,
              overflow:
                  expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.35,
                color: textColor,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: widget.onEdit,
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text("Edit bio"),
            ),
          ),
        ],
      ),
    );
  }
}
