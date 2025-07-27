import 'package:flutter/material.dart';

class ScanInstructionCard extends StatelessWidget {
  final List<String> instructions;
  final String title;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;

  const ScanInstructionCard({
    Key? key,
    required this.instructions,
    this.title = 'Tips Pindai Luka',
    this.icon = Icons.lightbulb_outline,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF0F8FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF000080).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? const Color(0xFF000080),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF000080),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...instructions.map(
            (instruction) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFF000080),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      instruction,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF555555),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}