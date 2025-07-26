import 'package:flutter/material.dart';

class BulletPoint extends StatelessWidget {
  final String text;
  final Color? bulletColor;
  final double? bulletSize;
  final TextStyle? textStyle;
  final double? spacing;

  const BulletPoint({
    Key? key,
    required this.text,
    this.bulletColor,
    this.bulletSize,
    this.textStyle,
    this.spacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacing ?? 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: bulletSize ?? 4,
            height: bulletSize ?? 4,
            decoration: BoxDecoration(
              color: bulletColor ?? const Color(0xFF000080),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: textStyle ??
                  const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF555555),
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}