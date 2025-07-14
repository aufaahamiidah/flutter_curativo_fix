import 'package:flutter/material.dart';
import '/screens/emergency_kit_detail.dart'; // Import halaman tujuan

class EmergencyKitCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;
  final List<Map<String, String>> steps;

  const EmergencyKitCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => EmergencyKitDetailPage(
                  title: title,
                  description: description,
                  imageAsset: imageAsset,
                  steps: steps,
                ),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.asset(
                imageAsset,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Label kecil
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text("Kit", style: TextStyle(fontSize: 12)),
              ),
            ),
            // Judul dan deskripsi
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.local_hospital, size: 14),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
