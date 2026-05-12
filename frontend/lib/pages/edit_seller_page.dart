import 'package:flutter/material.dart';
import 'package:antipattern/models/sellers.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:antipattern/widgets/universal_action_bar.dart';

class EditSellerPage extends StatefulWidget {
  final Seller seller;

  const EditSellerPage({super.key, required this.seller});

  @override
  State<EditSellerPage> createState() => _EditSellerPageState();
}

class _EditSellerPageState extends State<EditSellerPage> {
  late TextEditingController usernameController;
  late TextEditingController bioController;
  late TextEditingController profileImageController;
  late TextEditingController bannerImageController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.seller.username);
    bioController = TextEditingController(text: widget.seller.bio);
    profileImageController =
        TextEditingController(text: widget.seller.profileImage);
    bannerImageController =
        TextEditingController(text: widget.seller.bannerImage ?? '');
  }

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    profileImageController.dispose();
    bannerImageController.dispose();
    super.dispose();
  }

  void _save() {
    final updated = Seller(
      id: widget.seller.id,
      username: usernameController.text.trim().isEmpty
          ? widget.seller.username
          : usernameController.text.trim(),
      profileImage: profileImageController.text.trim().isEmpty
          ? widget.seller.profileImage
          : profileImageController.text.trim(),
      bannerImage: bannerImageController.text.trim().isEmpty
          ? widget.seller.bannerImage
          : bannerImageController.text.trim(),
      bio: bioController.text.trim(),
      rating: widget.seller.rating,
      totalSales: widget.seller.totalSales,
    );

    // Return the updated seller to the caller. Integrate with backend
    // by uploading images first and then returning the remote URLs.
    Navigator.pop(context, updated);
  }

  Widget _field(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Edit Seller Profile',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _field('Display name', usernameController),
                          _field('Bio', bioController, maxLines: 4),
                          _field('Profile image URL', profileImageController),
                          _field('Banner image URL', bannerImageController),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: _save,
                      child: GlassContainer(
                        tint: const Color(0xFFB590F7),
                        shadowOverride:
                            const Color(0xFFB590F7).withOpacity(0.35),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: const Center(
                          child: Text(
                            'Save Changes',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            TopOverlayActionBar(),
          ],
        ),
      ),
    );
  }
}
