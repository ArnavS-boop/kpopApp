import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:antipattern/widgets/universal_action_bar.dart';
import 'package:antipattern/models/photocards.dart';

class EditPhotocardPage extends StatefulWidget {
  final Listings listing;

  const EditPhotocardPage({
    super.key,
    required this.listing,
  });

  @override
  State<EditPhotocardPage> createState() => _EditPhotocardPageState();
}

class _EditPhotocardPageState extends State<EditPhotocardPage> {
  // TAG STATE
  final Set<String> selectedTags = {};
  String tagSearch = '';
  late final List<String> allTags;

  // FORM
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _itemNameController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;

  final ImagePicker _picker = ImagePicker();
  // images may be either String (url/path) or File for newly added
  final List<dynamic> _images = [];

  @override
  void initState() {
    super.initState();

    // Prefill controllers from provided listing
    _itemNameController = TextEditingController(text: widget.listing.itemName);
    _titleController = TextEditingController(text: widget.listing.title);
    _descriptionController = TextEditingController(text: widget.listing.description);
    _priceController = TextEditingController(text: widget.listing.price.toString());

    // Populate tags and master tag list
    selectedTags.addAll(widget.listing.tags);

    final tagSet = <String>{};
    for (final item in dummyListings) {
      for (final t in item.tags) {
        final clean = t.trim();
        if (clean.isNotEmpty) tagSet.add(clean);
      }
    }
    allTags = tagSet.toList()..sort();

    // Initialize images from listing URLs
    _images.addAll(widget.listing.imageUrls);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  void _removeImageAt(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    if (_images.isEmpty) {
      _showSnack("Add at least one image");
      return;
    }

    final parsedPrice = double.tryParse(_priceController.text.trim());
    if (parsedPrice == null || parsedPrice <= 0) {
      _showSnack("Enter a valid price");
      return;
    }

    // Map images to string paths/urls
    final imageUrls = _images.map<String>((img) {
      if (img is File) return img.path;
      return img.toString();
    }).toList();

    final updated = Listings(
      id: widget.listing.id,
      title: _titleController.text.trim(),
      itemName: _itemNameController.text.trim(),
      sellerName: widget.listing.sellerName,
      description: _descriptionController.text.trim(),
      price: parsedPrice,
      imageUrls: imageUrls,
      location: widget.listing.location,
      tags: selectedTags.toList(),
      group: widget.listing.group,
      member: widget.listing.member,
      album: widget.listing.album,
      era: widget.listing.era,
      version: widget.listing.version,
      cardType: widget.listing.cardType,
      rarity: widget.listing.rarity,
      deliversTo: widget.listing.deliversTo,
      shippingMethod: widget.listing.shippingMethod,
      language: widget.listing.language,
      verifiedSeller: widget.listing.verifiedSeller,
    );

    Navigator.pop(context, updated);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
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
                  padding: const EdgeInsets.fromLTRB(16, 100, 16, 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Edit Listing",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildImageSection(),
                        const SizedBox(height: 24),

                        _glassField("Title", controller: _titleController),
                        _glassField("Item Name", controller: _itemNameController),
                        _glassField("Description",
                            controller: _descriptionController, maxLines: 4),
                        _glassField(
                          "Price",
                          controller: _priceController,
                          keyboard: TextInputType.number,
                        ),

                        const SizedBox(height: 20),

                        _buildTagSection(),

                        const SizedBox(height: 30),

                        _saveButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
                      TopOverlayActionBar(
              title: widget.listing.itemName,
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildTagSection() {
    final filtered = allTags.where((tag) {
      if (tagSearch.isEmpty) return true;
      return tag.toLowerCase().contains(tagSearch.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tags",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),

        GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: TextField(
            onChanged: (v) => setState(() => tagSearch = v),
            decoration: const InputDecoration(
              hintText: "Search tags…",
              border: InputBorder.none,
              isCollapsed: true,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: filtered.map((tag) {
            final selected = selectedTags.contains(tag);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (selected) {
                    selectedTags.remove(tag);
                  } else {
                    selectedTags.add(tag);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: selected
                      ? const Color(0xFFB590F7)
                      : Colors.white.withOpacity(0.9),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFFB590F7)
                        : Colors.black.withOpacity(0.08),
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _glassField(
    String label, {
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboard,
          validator: (value) => value == null || value.trim().isEmpty ? "Required" : null,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Images",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ..._images.asMap().entries.map(
              (entry) {
                final idx = entry.key;
                final file = entry.value;

                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: file is File
                          ? Image.file(
                              file,
                              width: 90,
                              height: 130,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              file.toString(),
                              width: 90,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => _removeImageAt(idx),
                        child: GlassContainer(
                          borderRadius: BorderRadius.circular(999),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            GestureDetector(
              onTap: _pickImage,
              child: GlassContainer(
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.all(20),
                child: const Icon(Icons.add_photo_alternate_rounded),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _saveButton() {
    return GestureDetector(
      onTap: _save,
      child: GlassContainer(
        borderRadius: BorderRadius.circular(24),
        tint: const Color(0xFFB590F7),
        shadowOverride: const Color(0xFFB590F7).withOpacity(0.35),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: const Center(
          child: Text(
            "Save Changes",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
