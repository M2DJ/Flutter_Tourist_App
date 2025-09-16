import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopOut extends StatelessWidget {
  const PopOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              backgroundColor: const Color(0xFF0D6EFD),
              child: Image.asset(
                'assets/images/Email (1).png',
                height: 26,
                width: 26,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Check your email",
              style: GoogleFonts.inter(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              "We have sent password recovery instruction to your email",
              style: GoogleFonts.inter(
                  color: const Color(0xff7D848D), fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
