import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_governate_app/Login%20&%20Register/forget_pass.dart';
import 'package:my_governate_app/Login%20&%20Register/signup.dart';
import 'package:my_governate_app/app_styles.dart';
import 'package:my_governate_app/main_screens/home.dart';
import 'package:my_governate_app/services/auth_service.dart';
import 'package:my_governate_app/theme/app_theme.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _authService = AuthService();

  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _authService
          .signIn(
        email: emailController.text,
        password: passController.text,
      )
          .then((user) {
        if (user != null && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
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
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
                Image.asset(
                  'assets/images/signin.jpg',
                  height: 300,
                  width: 300,
                ),
                Text(
                  "Sign in now",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Please sign in to continue our app",
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
                      const SizedBox(height: 19),
                      Text(
                        "Email Address",
                        style: AppTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
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

                      const SizedBox(height: 30),

                      // Password
                      Text(
                        "Password",
                        style: AppTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      SizedBox(
                        width: 335,
                        height: 70,
                        child: TextFormField(
                          obscureText: _isObscure,
                          cursorColor: Colors.black,
                          controller: passController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your password';
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
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: Color(0xFF0D6EFD),
                              )),
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
                          color: const Color(0xFF0D6EFD),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: _isLoading ? "Signing In..." : "Sign In",
                  size: const Size(327, 48),
                  onPressed: _isLoading ? null : _signIn,
                  textSize: 16,
                  borderRadius: 10,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don't have an account?",
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
                            builder: (context) =>
                                const SignUp(selectedCity: ''),
                          ),
                        );
                      },
                      child: Text(
                        "Sign up",
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
                    // google
                    SocialCircle(
                      child: Image.asset(
                        'assets/images/Frame 4.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 30),

                    // Facebook icon
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
