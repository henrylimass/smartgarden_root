import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool filled;

  const PillButton._({
    required this.label,
    required this.onPressed,
    required this.filled,
  });

  factory PillButton.filled({
    required String label,
    required VoidCallback? onPressed,
  }) =>
      PillButton._(label: label, onPressed: onPressed, filled: true);

  factory PillButton.white({
    required String label,
    required VoidCallback? onPressed,
  }) =>
      PillButton._(label: label, onPressed: onPressed, filled: false);

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.montserratAlternates(
      fontSize: 15,
      fontWeight: FontWeight.w700,
    );

    final background = filled ? const Color.fromRGBO(253, 185, 79, 1) : Colors.white;
    final foreground = filled ? Colors.black : Colors.black87;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: filled ? 2 : 0,
          shadowColor: Colors.black45,
          backgroundColor: background,
          foregroundColor: foreground,
          shape: const StadiumBorder(),
        ),
        child: Text(label, style: baseStyle),
      ),
    );
  }
}
