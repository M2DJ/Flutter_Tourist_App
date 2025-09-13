import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:goverment_app/Profile/edit_profile.dart';
import 'package:goverment_app/app_styles.dart';

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
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.notification_add_outlined, color: Colors.blue),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),

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

                SizedBox(height: 30),
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
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: const Color(0xffABABAB),
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
                          prefixIcon: Icon(
                            Icons.local_phone_outlined,
                            color: const Color(0xffABABAB),
                          ),
                          hintText: "+93123135",
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
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            color: const Color(0xffABABAB),
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

                SizedBox(height: 10),
                CustomButton(
                  text: "Edit Profile",
                  size: Size(327, 48),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const EditProfile(),
                    //   ),
                    // );
                  },
                  textSize: 16,
                  borderRadius: 10,
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
