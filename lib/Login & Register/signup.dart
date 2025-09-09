import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_governate_app/Login%20&%20Register/signin.dart';
import 'package:my_governate_app/app_styles.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final fnameController = TextEditingController();
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Sign up now",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Please fill the details and create account",
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
                    // full name
                    SizedBox(
                      width: 335,
                      height: 70,
                      child: TextFormField(
                        controller: fnameController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the Full Name';
                          }
                          return null;
                        },
                        decoration: AppStyles.inputDecoration(
                          hintText: 
                            "Leonardo Smith",
                           
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
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
                          hintText:
                            "www.uihut@gmail.com",
                            
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
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
                          } else if (value.length < 8) {
                            return 'Password must be 8 characters';
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

              SizedBox(height: 15),
              CustomButton(
                text: "Sign Up",
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
                    "Already have an account",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Color(0xff707B81),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signin()),
                      );
                    },
                    child: Text(
                      "Sign in",
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
    );
  }
}
