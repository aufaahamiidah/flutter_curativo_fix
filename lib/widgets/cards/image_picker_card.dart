import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';
import 'dart:io';

class ImagePickerCard extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTap;
  final String? hintText;
  final String? subtitle;
  final IconData hintIcon;
  final double height;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;

  const ImagePickerCard({
    Key? key,
    required this.imageFile,
    required this.onTap,
    this.hintText,
    this.subtitle,
    this.hintIcon = Icons.camera_alt_outlined,
    this.height = 250,
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor ?? const Color(0xFFE0E0E0),
            width: 2,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(16.0),
          color: backgroundColor ?? const Color(0xFFF8F9FA),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          image: imageFile != null
              ? DecorationImage(
                  image: FileImage(imageFile!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hintIcon,
                    size: 48,
                    color: const Color(0xFF9E9E9E),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    hintText ?? localizations.tapToSelectPhoto,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              )
            : null,
      ),
    );
  }
}