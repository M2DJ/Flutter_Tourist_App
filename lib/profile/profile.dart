import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_governate_app/app_styles.dart';
import 'package:my_governate_app/profile/edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 70,
                  child: Image.asset(
                    'assets/images/Ellipse 37.png',
                    width: 139,
                    height: 206,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Ahmed Ezz",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 19),
                    Text(
                      " Your Email",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xff262422),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Email
                    SizedBox(
                      width: 335,
                      height: 70,
                      child: TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        decoration: AppStyles.inputDecoration(
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xffABABAB),
                          ),
                          hintText: "xxx@gmail.com",
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    Text(
                      "Phone Number",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xff262422),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Phone
                    SizedBox(
                      width: 335,
                      height: 70,
                      child: TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.phone,
                        decoration: AppStyles.inputDecoration(
                          prefixIcon: const Icon(
                            Icons.local_phone_outlined,
                            color: Color(0xffABABAB),
                          ),
                          hintText: "+201145687786",
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    Text(
                      "Your Password",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xff262422),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Password
                    SizedBox(
                      width: 335,
                      height: 70,
                      child: TextField(
                        obscureText: _isObscure,
                        cursorColor: Colors.black,
                        decoration: AppStyles.inputDecoration(
                          hintText: "***********",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: Color(0xffABABAB),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Government",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xff262422),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Government
                    SizedBox(
                      width: 335,
                      height: 70,
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: AppStyles.inputDecoration(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: "Edit Profile",
                  size: const Size(327, 48),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfile(),
                      ),
                    );
                  },
                  textSize: 16,
                  borderRadius: 10,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
