import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int lastPage;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final Color? buttonColor;
  final TextStyle? textStyle;

  const PaginationControls({
    Key? key,
    required this.currentPage,
    required this.lastPage,
    this.onPrevious,
    this.onNext,
    this.buttonColor,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lastPage <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavigationButton(
            icon: Icons.chevron_left,
            onPressed: currentPage > 1 ? onPrevious : null,
          ),
          const SizedBox(width: 16),
          Text(
            'Halaman $currentPage dari $lastPage',
            style: textStyle ?? const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(width: 16),
          _buildNavigationButton(
            icon: Icons.chevron_right,
            onPressed: currentPage < lastPage ? onNext : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onPressed != null 
            ? (buttonColor ?? const Color(0xFF000080))
            : Colors.grey[300],
        boxShadow: onPressed != null ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: onPressed != null ? Colors.white : Colors.grey[600],
          size: 18,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}