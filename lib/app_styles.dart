import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// font colors app
class AppColors {
  static const blue = Color(0xFF0D6EFD);
  static const lightBlue = Color(0xFF3174F0);
  static const white = Colors.white;
  static const black = Colors.black;
  static const grey = Color(0xff7D848D);
}

// // font styles + common widgets
class AppTextStyles {
  static TextStyle title({
    required double fontSize,
    Color color = AppColors.blue,
  }) {
    return GoogleFonts.sourceSans3(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle body({
    required double fontSize,
    Color color = AppColors.blue,
  }) {
    return GoogleFonts.sourceSans3(fontSize: fontSize, color: color);
  }

  static TextStyle button({
    required double fontSize,
    Color color = AppColors.white,
  }) {
    return GoogleFonts.sourceSans3(fontSize: fontSize, color: color);
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Size size;
  final double textSize;
  final double borderRadius;
  final VoidCallback? onPressed;
   CustomButton({
    required this.size,
    required this.borderRadius,
    required this.onPressed,
    required this.text,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0D6EFD),
        padding: const EdgeInsets.all(5),
        elevation: 4,
        fixedSize: size,
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(color: Colors.white, fontSize: textSize),
      ),
    );
  }
}

class AppStyles {
  static InputDecoration inputDecoration({
    Widget? suffixIcon,
    String? hintText,
    Widget? hint,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Color(0xffF7F7F9),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color.fromARGB(255, 180, 180, 180),
        fontSize: 14,
      ),

      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFF7F7F9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFF7F7F9), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    );
  }
}

class SocialCircle extends StatelessWidget {
  final Color borderColor;
  final Color backgroundColor;
  final Widget child;
  final double radius;

  const SocialCircle({
    super.key,
    required this.child,
    this.radius = 15,
    this.borderColor = const Color(0xff3D4DA6),
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: borderColor, shape: BoxShape.circle),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }
}