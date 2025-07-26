import 'package:flutter/material.dart';
import '/widgets/emergency_card.dart';

class KitSliderSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> kitItems;
  final EdgeInsetsGeometry? padding;
  final double? height;

  const KitSliderSection({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.kitItems,
    this.padding,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6D6D6D),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: height ?? 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: kitItems.length,
            itemBuilder: (context, index) {
              final item = kitItems[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < kitItems.length - 1 ? 16 : 0,
                ),
                child: EmergencyKitCard(
                  title: item['title'] ?? '',
                  description: item['description'] ?? '',
                  imageAsset: item['imageAsset'] ?? '',
                  steps: List<Map<String, String>>.from(item['steps'] ?? []),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}