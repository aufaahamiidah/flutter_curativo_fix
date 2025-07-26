import 'package:flutter/material.dart';

class ConfidenceIndicator extends StatelessWidget {
  final double score;
  final String? label;
  final Color? progressColor;
  final Color? backgroundColor;
  final double height;

  const ConfidenceIndicator({
    Key? key,
    required this.score,
    this.label,
    this.progressColor,
    this.backgroundColor,
    this.height = 8,
  }) : super(key: key);

  Color _getScoreColor(double score) {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.6) return Colors.orange;
    return Colors.red;
  }

  String _getScoreLabel(double score) {
    if (score >= 0.8) return 'Tinggi';
    if (score >= 0.6) return 'Sedang';
    return 'Rendah';
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = progressColor ?? _getScoreColor(score);
    final scoreLabel = label ?? _getScoreLabel(score);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(score * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: scoreColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: scoreColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: scoreColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                scoreLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: scoreColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey[200],
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: score.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: scoreColor,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}