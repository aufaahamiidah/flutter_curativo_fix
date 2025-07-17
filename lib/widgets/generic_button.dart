import 'package:flutter/material.dart';

enum ButtonType {
  elevated,   // Tombol dengan elevasi (background solid)
  outlined,   // Tombol dengan border (background transparan)
  text,       // Tombol teks saja
}

class GenericButton extends StatelessWidget {
  final String text; // Teks yang ditampilkan di tombol
  final VoidCallback onPressed; // Fungsi yang dijalankan saat tombol ditekan
  final ButtonType type; // Tipe tombol (elevated, outlined, text)
  final Color? backgroundColor; // Warna latar belakang tombol (opsional)
  final Color? textColor; // Warna teks tombol (opsional)
  final Color? borderColor; // Warna border tombol (khusus untuk outlined, opsional)
  final double? fontSize; // Ukuran font teks (opsional)
  final FontWeight? fontWeight; // Ketebalan font teks (opsional)
  final EdgeInsetsGeometry? padding; // Padding internal tombol (opsional)
  final BorderRadius? borderRadius; // Radius sudut tombol (opsional)

  const GenericButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.elevated, // Default ke ElevatedButton
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Menentukan padding default jika tidak disediakan
    final effectivePadding = padding ?? const EdgeInsets.symmetric(vertical: 16.0);
    // Menentukan border radius default jika tidak disediakan
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(10.0);

    switch (type) {
      case ButtonType.elevated:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? const Color(0xFF000080), // Default biru gelap
            foregroundColor: textColor ?? Colors.white, // Default teks putih
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: effectiveBorderRadius,
            ),
            elevation: 0, // Mengatur elevasi default ke 0
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 18, // Default ukuran font 18
              fontWeight: fontWeight ?? FontWeight.bold, // Default tebal
              color: textColor ?? Colors.white, // Pastikan warna teks konsisten
            ),
          ),
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? Colors.white, // Default teks putih
            side: BorderSide(
              color: borderColor ?? Colors.white, // Default border putih
              width: 2,
            ),
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: effectiveBorderRadius,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 18, // Default ukuran font 18
              fontWeight: fontWeight ?? FontWeight.bold, // Default tebal
              color: textColor ?? Colors.white, // Pastikan warna teks konsisten
            ),
          ),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? const Color(0xFF000080), // Default teks biru gelap
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: effectiveBorderRadius,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 18, // Default ukuran font 18
              fontWeight: fontWeight ?? FontWeight.bold, // Default tebal
              color: textColor ?? const Color(0xFF000080), // Pastikan warna teks konsisten
            ),
          ),
        );
      default:
        // Fallback jika tipe tidak dikenal, bisa dilemparkan error atau default ke ElevatedButton
        return ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
        );
    }
  }
}
