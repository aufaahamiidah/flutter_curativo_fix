import 'package:flutter/material.dart';

class EmergencyKitDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final String imageAsset;
  final List<Map<String, String>> steps;

  const EmergencyKitDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.steps,
  });

  @override
  State<EmergencyKitDetailPage> createState() => _EmergencyKitDetailPageState();
}

class _EmergencyKitDetailPageState extends State<EmergencyKitDetailPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final List<Map<String, String>> cardItems;

  @override
  void initState() {
    super.initState();
    cardItems = widget.steps;

    _pageController.addListener(() {
      final next = _pageController.page?.round() ?? 0;
      if (_currentPage != next) {
        setState(() => _currentPage = next);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000054),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: cardItems.length,
            itemBuilder: (context, index) {
              final item = cardItems[index];

              return Center(
                child: SizedBox(
                  width: 330,
                  height: 620,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Gambar full atas
                        if (item['imageAsset'] != null &&
                            item['imageAsset']!.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.asset(
                              item['imageAsset']!,
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                        // Konten teks
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? '',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  item['description'] ?? '',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Tombol tutup
          Positioned(
            top: 40,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // Indikator titik
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                cardItems.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
