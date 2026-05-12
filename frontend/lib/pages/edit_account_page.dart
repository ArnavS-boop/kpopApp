import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/universal_action_bar.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:antipattern/models/profile.dart';

class EditAccountPage extends StatefulWidget {
  final ProfileData profile;

  const EditAccountPage({
    super.key,
    required this.profile,
  });

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  late TextEditingController usernameController;
  late TextEditingController bioController;

  late String? selectedLocation;

  File? selectedAvatarFile;
  final ImagePicker _picker = ImagePicker();

  bool _isLocationOpen = false;

  final List<String> locationOptions = [
    "India",
    "USA",
    "UK",
    "South Korea",
    "Japan",
    "Singapore",
  ];

  @override
  void initState() {
    super.initState();

    usernameController =
        TextEditingController(text: widget.profile.username);

    bioController =
        TextEditingController(text: widget.profile.bio ?? '');

    selectedLocation = widget.profile.location;
  }

  Future<void> _pickAvatar() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (picked == null) return;

      final file = File(picked.path);

      final size = await file.length();
      const maxSize = 5 * 1024 * 1024; // 5MB

      if (size > maxSize) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image too large (max 5MB)")),
        );
        return;
      }

      setState(() {
        selectedAvatarFile = file;
      });
    } catch (e) {
      debugPrint("Avatar pick error: $e");
    }
  }

  void _save() {
    final updatedProfile = ProfileData(
      id: widget.profile.id,
      username: usernameController.text.trim(),
      bio: bioController.text.trim().isEmpty
          ? null
          : bioController.text.trim(),
      location: selectedLocation,
      avatarUrl: selectedAvatarFile != null
          ? selectedAvatarFile!.path // temporary until backend upload
          : widget.profile.avatarUrl,
      joinedAt: widget.profile.joinedAt,
      rating: widget.profile.rating,
      reviewCount: widget.profile.reviewCount,
      salesCount: widget.profile.salesCount,
      isSeller: widget.profile.isSeller,
      responseTime: widget.profile.responseTime,
    );

    Navigator.pop(context, updatedProfile);
  }

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Widget _field(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _locationDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isLocationOpen = !_isLocationOpen;
              });
            },
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedLocation ?? "Select Location",
                      style: TextStyle(
                        color: selectedLocation == null
                            ? Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6)
                            : Theme.of(context)
                                .colorScheme
                                .onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    _isLocationOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                  ),
                ],
              ),
            ),
          ),

          if (_isLocationOpen) ...[
            const SizedBox(height: 8),
            GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: locationOptions.map((loc) {
                  final isSelected = loc == selectedLocation;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLocation = loc;
                        _isLocationOpen = false;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        loc,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _avatarSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: _pickAvatar,
        child: GlassContainer(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundImage: selectedAvatarFile != null
                    ? FileImage(selectedAvatarFile!)
                    : (widget.profile.avatarUrl != null
                        ? NetworkImage(widget.profile.avatarUrl!)
                            as ImageProvider
                        : null),
                child: selectedAvatarFile == null &&
                        widget.profile.avatarUrl == null
                    ? const Icon(Icons.person, size: 30)
                    : null,
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  "Tap to upload profile picture",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(Icons.upload_rounded),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 100, 16, 40),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      GlassContainer(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            _avatarSection(),
                            _field("Username", usernameController),
                            _field("Bio", bioController,
                                maxLines: 3),
                            _locationDropdown(context),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      GestureDetector(
                        onTap: _save,
                        child: GlassContainer(
                          tint: const Color(0xFFB590F7),
                          shadowOverride:
                              const Color(0xFFB590F7)
                                  .withOpacity(0.35),
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: const Center(
                            child: Text(
                              "Save Changes",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const TopOverlayActionBar(),
          ],
        ),
      ),
    );
  }
}