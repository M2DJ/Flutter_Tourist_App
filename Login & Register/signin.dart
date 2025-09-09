import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:goverment_app/Login & Register/forget_pass.dart';
import 'package:goverment_app/app_styles.dart';
import 'package:goverment_app/Login & Register/signup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Sign in now",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Please sign in to continue our app",
                  style: GoogleFonts.inter(
                    color: Color(0xff7D848D),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 19),

                      // Email
                      SizedBox(
                        width: 335,
                        height: 70,
                        child: TextFormField(
                          controller: emailController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the email';
                            } else if (!value.contains('@')) {
                              return 'Invalid Email';
                            }
                            return null;
                          },
                          decoration: AppStyles.inputDecoration(
                            hint: Text(
                              "www.uihut@gmail.com",
                              style: GoogleFonts.inter(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Password
                      SizedBox(
                        width: 335,
                        height: 70,
                        child: TextFormField(
                          obscureText: _isObscure,
                          cursorColor: Colors.black,
                          controller: passController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the password';
                            }
                            return null;
                          },
                          decoration: AppStyles.inputDecoration(
                            hintText: "**************",
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPass(),
                          ),
                        );
                      },
                      child: Text(
                        "Forget Password?",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF0D6EFD),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                CustomButton(
                  text: "Sign In",
                  size: Size(327, 48),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      emailController.clear();
                      passController.clear();
                    }
                  },
                  textSize: 16,
                  borderRadius: 10,
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Color(0xff707B81),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF0D6EFD),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  "Or Connect ",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Color(0xff707B81),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // google
                    SocialCircle(
                      child: Image.asset(
                        'assets/images/Frame 4.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: 5),

                    // Facebook icon
                    SocialCircle(
                      child: FaIcon(
                        FontAwesomeIcons.facebookF,
                        color: Color(0xff3D4DA6),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
