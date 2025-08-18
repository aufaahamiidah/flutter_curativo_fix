import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';

class RecommendationList extends StatelessWidget {
  final List<String> recommendations;
  final Color? bulletColor;
  final TextStyle? textStyle;
  final double? spacing;
  final bool hasMoreRecommendations; // Parameter baru

  const RecommendationList({
    Key? key,
    required this.recommendations,
    this.bulletColor,
    this.textStyle,
    this.spacing,
    this.hasMoreRecommendations = false, // Default false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    if (recommendations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              localizations.noRecommendationsAvailable,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...recommendations.asMap().entries.map((entry) {
          final index = entry.key;
          final recommendation = entry.value;
          
          return Container(
            margin: EdgeInsets.only(
              bottom: index < recommendations.length - 1 ? (spacing ?? 12) : 0,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF000080).withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: bulletColor ?? const Color(0xFF000080),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    recommendation,
                    style: textStyle ?? const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF333333),
                      height: 1.5,
                    ),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        
        // Tambahkan indikator kelanjutan
        if (hasMoreRecommendations)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4299E1).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.more_horiz,
                  color: const Color(0xFF4299E1),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Masih ada rekomendasi lainnya. Scroll ke bawah untuk melihat lebih lengkap.",
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF4299E1),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: const Color(0xFF4299E1),
                  size: 20,
                ),
              ],
            ),
          ),
      ],
    );
  }
}