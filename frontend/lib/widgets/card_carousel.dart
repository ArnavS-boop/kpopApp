import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PhotoCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final double height;

  const PhotoCarousel({
    super.key,
    required this.imageUrls,
    this.height = 350,
  });

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
  constraints: BoxConstraints(maxHeight: widget.height),
  child: ShaderMask(
    shaderCallback: (Rect rect) {
      return const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.black,
          Colors.black,
          Colors.transparent,
        ],
        stops: [0.0, 0.1, 0.9, 1.0],
      ).createShader(rect);
    },
    blendMode: BlendMode.dstIn,
    child: PageView.builder(
      controller: _pageController,
      itemCount: widget.imageUrls.length,
      itemBuilder: (context, index) {
        final url = widget.imageUrls[index];
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        );
      },
    ),
  ),
),

        const SizedBox(height: 12),
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
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
