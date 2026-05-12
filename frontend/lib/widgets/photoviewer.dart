import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PhotoViewer extends StatefulWidget {
  final List<String> imageUrls;

  const PhotoViewer({super.key, required this.imageUrls});

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              final imageUrl = widget.imageUrls[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,

                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          },

                          errorBuilder: (_, __, ___) {
                            return Container(
                              color: Colors.black12,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.broken_image_rounded,
                                size: 36,
                              ),
                            );
                          },
                        ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.imageUrls.length,
          effect: ExpandingDotsEffect(
            activeDotColor: Colors.purpleAccent,
            dotColor: Colors.grey.shade400,
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 3,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
