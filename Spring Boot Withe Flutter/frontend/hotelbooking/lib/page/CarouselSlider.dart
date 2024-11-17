import 'dart:async';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _carouselIndex = 0;
  late PageController _pageController;
  Timer? _timer;

  // List of image URLs
  static const List<String> _images = [

  ];

  // List of text overlays for each image
  static const List<String> _texts = [
    "একমাত্র ভ্রমনেই রয়েছে আনন্দ আর অভিজ্ঞতার সমন্বয়",
    "ভ্রমন মানুষের জ্ঞানের পরিধি বৃদ্ধি করে",
    "কুসংস্কার, গোঁড়ামি এবং সংকীর্ণতার জন্য ভ্রমণ হলো মহা ঔষধ",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPageChange();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPageChange() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _carouselIndex = (_carouselIndex + 1) % _images.length;
      });
      _pageController.animateToPage(
        _carouselIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              // Carousel with images and text overlays
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 150, // Adjust height based on image size
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _carouselIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Image.network(
                            _images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  'Image not available',
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Text(
                              _texts[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Colors.black45,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
