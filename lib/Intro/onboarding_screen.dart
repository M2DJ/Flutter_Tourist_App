import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_governate_app/Intro/government_selection.dart';
import 'package:my_governate_app/app_styles.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController(initialPage: 0);
  int num = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            num = index + 1;
          });
        },
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "$num",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: "/3",
                              style: GoogleFonts.inter(
                                color: const Color(0xFFA0A0A1),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const GovernmentSelectionScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Skip",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  //first page
                  Image.asset(
                    'assets/images/image 1.png',
                    height: 206,
                    width: 206,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Welcome to MyGovernmate",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Discover all the hidden gems of your governorate in one place.",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xF3535353),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 90),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        effect: const ExpandingDotsEffect(
                          activeDotColor: Color(0xFF413F3F),
                          dotHeight: 5,
                          dotWidth: 5,
                          expansionFactor: 3,
                          spacing: 8,
                        ),
                      ),
                      const SizedBox(width: 70),
                      CustomButton(
                        text: 'Next',
                        size: const Size(80, 45),
                        onPressed: () {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        textSize: 18,
                        borderRadius: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Second page
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "$num",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: "/3",
                              style: GoogleFonts.inter(
                                color: const Color(0xFFA0A0A1),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const GovernmentSelectionScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Skip",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/images/image 2.png',
                    height: 206,
                    width: 206,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Know Your City Better",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Find places, events, and opportunities around you with ease.",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xf3535353),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          'Back',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffC4C4C4),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        effect: const ExpandingDotsEffect(
                          activeDotColor: Color(0xFF413F3F),
                          dotHeight: 5,
                          dotWidth: 5,
                          expansionFactor: 3,
                          spacing: 8,
                        ),
                      ),
                      CustomButton(
                        text: 'Next',
                        size: const Size(80, 45),
                        onPressed: () {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        textSize: 18,
                        borderRadius: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Third page with button
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "$num",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: "/3",
                              style: GoogleFonts.inter(
                                color: const Color(0xFFA0A0A1),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const GovernmentSelectionScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Skip",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/images/image 3.png',
                    height: 206,
                    width: 206,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Ready to Explore?",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Start your journey with MyGovernate and enjoy every corner of your city.",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xf3535353),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          'Back',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffC4C4C4),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        effect: const ExpandingDotsEffect(
                          activeDotColor: Color(0xFF413F3F),
                          dotHeight: 5,
                          dotWidth: 5,
                          expansionFactor: 3,
                          spacing: 8,
                        ),
                      ),
                      CustomButton(
                        text: 'Get Started',
                        size: const Size(120, 39),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const GovernmentSelectionScreen(),
                            ),
                          );
                        },
                        textSize: 15,
                        borderRadius: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
