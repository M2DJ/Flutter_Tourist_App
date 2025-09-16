import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_governate_app/Login%20&%20Register/signin.dart';
import 'package:my_governate_app/Login%20&%20Register/signup.dart';
import 'package:my_governate_app/app_styles.dart';
import 'package:my_governate_app/providers/app_state_provider.dart';
import 'package:provider/provider.dart';

class GovernmentSelectionScreen extends StatefulWidget {
  const GovernmentSelectionScreen({super.key});

  @override
  State<GovernmentSelectionScreen> createState() =>
      _GovernmentSelectionScreenState();
}

class _GovernmentSelectionScreenState extends State<GovernmentSelectionScreen> {
  final List<String> governments = [
    "Cairo",
    "Alexandria",
    "Giza",
    "Aswan",
    "Luxor",
    "Suez",
  ];
  String? selectedGovernment;

  @override
  Widget build(BuildContext context) {
    var stateProvider = context.watch<AppStateProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/image 28.png',
                  height: 30,
                  width: 29,
                ),
                const SizedBox(width: 10),
                Text(
                  "MyGov",
                  style: GoogleFonts.inter(
                    color: const Color(0xFF3174F0),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80),

            Image.asset(
              'assets/images/Rectangle 14.png',
              height: 196,
              width: 377,
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Choose your government",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xff3174F0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                focusColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
              ),
              items: governments.map((gov) {
                return DropdownMenuItem(value: gov, child: Text(gov));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGovernment = value;
                  stateProvider.selectState(selectedGovernment!);
                });
              },
            ),
            const SizedBox(height: 25),
            const SizedBox(height: 15),
            CustomButton(
              text: "Sign In",
              size: const Size(327, 48),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Signin()),
                );
              },
              textSize: 16,
              borderRadius: 10,
            ),

            const SizedBox(height: 10),
            CustomButton(
              text: "Sign Up",
              size: const Size(327, 48),
              onPressed: () {
                if (selectedGovernment == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('الرجاء اختيار المدينة أولاً'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SignUp(selectedCity: selectedGovernment!),
                  ),
                );
              },
              textSize: 16,
              borderRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
