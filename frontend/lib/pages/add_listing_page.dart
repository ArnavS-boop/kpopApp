import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:antipattern/widgets/universal_action_bar.dart';
import 'package:antipattern/models/photocards.dart';

class AddListingPage extends StatefulWidget {
  final String sellerId;

  const AddListingPage({
    super.key,
    required this.sellerId,
  });

  @override
  State<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  // ================= TAG STATE =================
  final Set<String> selectedTags = {};
  String tagSearch = '';
  late final List<String> allTags;

  // ================= FORM =================
  final _formKey = GlobalKey<FormState>();

  final _itemNameController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final List<File> _images = [];

  String? _selectedCondition;
  String? _selectedCategory;

  final List<String> _conditions = [
    "Mint",
    "Near Mint",
    "Good",
    "Used",
  ];

  final List<String> _categories = [
    "Photocard",
    "Album",
    "Merch",
    "Other",
  ];

  // ================= INIT =================
  @override
  void initState() {
    super.initState();

    final tagSet = <String>{};

    for (final item in dummyListings) {
      for (final t in item.tags) {
        final clean = t.trim();
        if (clean.isNotEmpty) tagSet.add(clean);
      }
    }

    allTags = tagSet.toList()..sort();
  }

  // ================= IMAGE PICK =================
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

  // ================= SUBMIT =================
  void _submit() {
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

    final listing = Listings(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      itemName: _itemNameController.text.trim(),
      sellerName: widget.sellerId,
      description: _descriptionController.text.trim(),
      price: parsedPrice,
      imageUrls: _images.map((f) => f.path).toList(),
      location: "",
      tags: selectedTags.toList(), // ✅ TAGS INCLUDED
    );

    Navigator.pop(context, listing);
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

  // ================= BUILD =================
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
                          "Create Listing",
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

                        _dropdownField(
                          label: "Condition",
                          value: _selectedCondition,
                          options: _conditions,
                          onChanged: (v) => setState(() => _selectedCondition = v),
                        ),

                        _dropdownField(
                          label: "Category",
                          value: _selectedCategory,
                          options: _categories,
                          onChanged: (v) => setState(() => _selectedCategory = v),
                        ),

                        const SizedBox(height: 20),

                        _buildTagSection(),

                        const SizedBox(height: 30),

                        _publishButton(),
                      ],
                    ),
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

  // ================= TAG UI =================
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
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400,
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

  // ================= COMMON UI =================
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
          validator: (value) =>
              value == null || value.trim().isEmpty ? "Required" : null,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required String? value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: const InputDecoration(border: InputBorder.none),
          hint: Text(label),
          items: options
              .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
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
            ..._images.map(
              (file) => ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  file,
                  width: 90,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            GestureDetector(
              onTap: _pickImage,
              child: GlassContainer(
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.all(20),
                child:
                    const Icon(Icons.add_photo_alternate_rounded),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _publishButton() {
    return GestureDetector(
      onTap: _submit,
      child: GlassContainer(
        borderRadius: BorderRadius.circular(24),
        tint: const Color(0xFFB590F7),
        shadowOverride:
            const Color(0xFFB590F7).withOpacity(0.35),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: const Center(
          child: Text(
            "Publish Listing",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}