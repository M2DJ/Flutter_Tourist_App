import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';
import 'package:my_governate_app/app_styles.dart';
import 'package:my_governate_app/notification/notification_screens.dart';
import 'package:my_governate_app/profile/utilis.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Uint8List? _image;
  final _formKey = GlobalKey<FormState>();

  final fameController = TextEditingController();
  final lameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();
  bool _isObscure = true;

  Future<void> selectImage() async {
    final Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
           onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const NotificationScreen();
                  },
                ));
              },
            icon: Image.asset(
              'assets/icons/image.png',
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      "assets/images/Ellipse 37.png",
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                        Positioned(
                          left: 92,
                          top: 94,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                              border: Border.all(width: 2, color: Colors.white),
                            ),
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Text(
                      "Ahmed Ezz",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      buildLabel("First Name"),
                      const SizedBox(width: 58),
                      buildLabel("Second Name"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                          controller: fameController,
                          decoration: AppStyles.inputDecoration(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter last name';
                            }
                            return null;
                          },
                          controller: lameController,
                          decoration: AppStyles.inputDecoration(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Email
                  buildLabel("Email"),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
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
                        color: Color(0xffABABAB),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Phone Number
                  buildLabel("Phone Number"),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the phone number';
                      } else if (value.length < 11) {
                        return 'Invalid Phone Number';
                      }

                      return null;
                    },
                    decoration: AppStyles.inputDecoration(
                      hintText: "+201145687786",
                      prefixIcon: const Icon(
                        Icons.local_phone_outlined,
                        color: Color(0xffABABAB),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password
                  buildLabel("Your Password"),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
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
                        hintText: "***********",
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          color: Color(0xffABABAB),
                        ),
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

                  const SizedBox(height: 20),

                  buildLabel("Government"),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    decoration: AppStyles.inputDecoration(),
                    items: [
                      "Cairo",
                      "Alexandria",
                      "Giza",
                      "Aswan",
                      "Luxor",
                      "Suez",
                    ].map((gov) {
                      return DropdownMenuItem(value: gov, child: Text(gov));
                    }).toList(),
                    onChanged: (value) {},
                    validator: (value) =>
                        value == null ? 'Please select your government' : null,
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: CustomButton(
                      text: "Edit Profile",
                      size: const Size(327, 48),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          fameController.clear();
                          lameController.clear();
                          emailController.clear();
                          phoneController.clear();
                          passController.clear();
                        }
                      },
                      textSize: 16,
                      borderRadius: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }
}
