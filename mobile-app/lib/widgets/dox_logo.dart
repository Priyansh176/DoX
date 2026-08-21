import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum DoxLogoSize { compact, standard, large }

class DoxLogo extends StatelessWidget {
  const DoxLogo({
    super.key,
    this.size = DoxLogoSize.standard,
    this.showText = true,
  });

  final DoxLogoSize size;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final double boxSize;
    final double fontSize;
    final double borderRadius;
    final double gap;

    switch (size) {
      case DoxLogoSize.compact:
        boxSize = 36;
        fontSize = 20;
        borderRadius = 10;
        gap = 10;
        break;
      case DoxLogoSize.standard:
        boxSize = 48;
        fontSize = 26;
        borderRadius = 14;
        gap = 12;
        break;
      case DoxLogoSize.large:
        boxSize = 100;
        fontSize = 44;
        borderRadius = 26;
        gap = 18;
        break;
    }

    final emblem = Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: const Color(0xFF303030),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF303030).withValues(alpha: 0.18),
            blurRadius: boxSize * 0.3,
            offset: Offset(0, boxSize * 0.1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          'assets/App_logo.jpeg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              Icons.local_hospital_rounded,
              size: boxSize * 0.55,
              color: const Color(0xFFFFD84D),
            ),
          ),
        ),
      ),
    );

    if (!showText) return emblem;

    final text = RichText(
      text: TextSpan(
        style: GoogleFonts.outfit(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: const Color(0xFF303030),
        ),
        children: const [
          TextSpan(text: 'Do'),
          TextSpan(
            text: 'X',
            style: TextStyle(color: Color(0xFFE5A800)),
          ),
        ],
      ),
    );

    if (size == DoxLogoSize.large) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          emblem,
          SizedBox(height: gap),
          text,
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        emblem,
        SizedBox(width: gap),
        text,
      ],
    );
  }
}
