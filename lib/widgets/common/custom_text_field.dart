import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final bool isPassword;
  final ValueChanged<bool>? onToggleVisibility;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.onToggleVisibility, 
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isVisible; 

  @override
  void initState() {
    super.initState();
    _isVisible = !widget.isPassword;
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
    widget.onToggleVisibility?.call(_isVisible);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0), 
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFCCCCCC)),
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword && !_isVisible, 
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Color(0xFFA0A0A0)),
          prefixIcon: Icon(widget.icon, color: const Color(0xFFA0A0A0)),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFFA0A0A0),
                  ),
                  onPressed: _toggleVisibility, 
                )
              : null,
          border: InputBorder.none, 
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
        ),
        style: const TextStyle(color: Color(0xFF333333)),
      ),
    );
  }
}
