import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;
              final isSpecial = item.isSpecial;

              return GestureDetector(
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSpecial ? 16 : 12,
                    vertical: isSpecial ? 8 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSpecial
                        ? const Color(0xFF00009C)
                        : (isSelected
                            ? selectedItemColor?.withOpacity(0.1)
                            : Colors.transparent),
                    borderRadius: BorderRadius.circular(isSpecial ? 12 : 8),
                    boxShadow: isSpecial
                        ? [
                            BoxShadow(
                              color: const Color(0xFF00009C).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        color: isSpecial
                            ? Colors.white
                            : (isSelected
                                ? selectedItemColor ?? const Color(0xFF00009C)
                                : unselectedItemColor ?? const Color(0xFF6D6D6D)),
                        size: isSpecial ? 24 : 22,
                      ),
                      if (!isSpecial) const SizedBox(height: 4),
                      if (!isSpecial)
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? selectedItemColor ?? const Color(0xFF00009C)
                                : unselectedItemColor ?? const Color(0xFF6D6D6D),
                          ),
                        ),
                      if (isSpecial) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;
  final bool isSpecial;

  const BottomNavItem({
    required this.icon,
    required this.label,
    this.isSpecial = false,
  });
}