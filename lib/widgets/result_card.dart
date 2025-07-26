import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? contentColor;
  final Widget? customContent;
  final EdgeInsetsGeometry? padding;

  const ResultCard({
    Key? key,
    required this.title,
    this.content = '',
    this.icon,
    this.backgroundColor,
    this.titleColor,
    this.contentColor,
    this.customContent,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000080).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF000080),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: titleColor ?? const Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
          if (customContent != null) ...[
            const SizedBox(height: 16),
            customContent!,
          ] else if (content.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: contentColor ?? const Color(0xFF666666),
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}