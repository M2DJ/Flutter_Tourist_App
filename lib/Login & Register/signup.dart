import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_governate_app/Login%20&%20Register/signin.dart';
import 'package:my_governate_app/app_styles.dart';
import 'package:my_governate_app/services/auth_service.dart';
import 'package:my_governate_app/theme/app_theme.dart';

class SignUp extends StatefulWidget {
  final String selectedCity;
  const SignUp({super.key, required this.selectedCity});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final fnameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final _authService = AuthService();
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    fnameController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      _authService
          .signUp(
        email: emailController.text,
        password: passController.text,
        name: fnameController.text,
        city: widget.selectedCity,
      )
          .then((user) {
        if (user != null && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Signin()),
          );
        }
      }).catchError((e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }).whenComplete(() {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            // child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/signin.jpg',
                  height: 300,
                  width: 300,
                ),
                Text(
                  "Sign up now",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Please fill the details and create account",
                  style: GoogleFonts.inter(
                    color: const Color(0xff7D848D),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: AppTheme.bodyLarge,
                      ),
                      // full name
                      SizedBox(
                        width: 335,
                        height: 70,
                        child: TextFormField(
                          controller: fnameController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.name,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Please enter the Full Name'
                              : null,
                          decoration: AppStyles.inputDecoration(
                              hintText: "UserName",
                              prefixIcon: const Icon(
                                Icons.person_2_outlined,
                                color: Color(0xFF0D6EFD),
                              )),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Email",
                        style: AppTheme.bodyLarge,
                      ),
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
                              hintText: "Enter your email",
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Color(0xFF0D6EFD),
                              )),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Password",
                        style: AppTheme.bodyLarge,
                      ),
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
                              hintText: "Enter your password ",
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
                                color: Color(0xFF0D6EFD),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                CustomButton(
                  text: _isLoading ? "Signing Up..." : "Sign Up",
                  size: const Size(327, 48),
                  onPressed: !_isLoading ? _signUp : null,
                  textSize: 16,
                  borderRadius: 10,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Already have an account",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xff707B81),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signin()),
                        );
                      },
                      child: Text(
                        "Sign in",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF0D6EFD),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  "Or Connect ",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xff707B81),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SocialCircle(
                      child: Image.asset(
                        'assets/images/Frame 4.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 30),
                    const SocialCircle(
                      child: FaIcon(
                        FontAwesomeIcons.facebookF,
                        color: Color(0xff3D4DA6),
                        size: 30,
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
