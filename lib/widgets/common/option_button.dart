import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const OptionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFE53E3E),
          size: 24,
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF999999),
        ),
        onTap: onTap,
      ),
    );
  }
}