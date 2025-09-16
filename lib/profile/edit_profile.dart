import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_governate_app/app_styles.dart';
import 'package:my_governate_app/models/user_model.dart';
import 'package:my_governate_app/notification/notification_screens.dart';
import 'package:my_governate_app/profile/utilis.dart';
import 'package:my_governate_app/services/auth_service.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Uint8List? _image;
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
 
  UserModel? _currentUser;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _localImagePath;

  final fameController = TextEditingController();
  final lameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();
  String? _selectedCity;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userData = await _authService.getCurrentUserData();
      

      setState(() {
        _currentUser = userData;
        

        // Populate form fields with user data
        if (_currentUser != null) {
          // If name contains space, split it into first and last name
          if (_currentUser!.name != null && _currentUser!.name!.contains(' ')) {
            final nameParts = _currentUser!.name!.split(' ');
            fameController.text = nameParts[0];
            lameController.text = nameParts.sublist(1).join(' ');
          } else {
            fameController.text = _currentUser!.name ?? '';
            lameController.text = '';
          }

          emailController.text = _currentUser!.email;
          phoneController.text = _currentUser!.phone ?? '';
          _selectedCity = _currentUser!.city;
        }

        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading user data')),
        );
      }
    }
  }

  Future<void> selectImage() async {
    final Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  Future<String?> _uploadImage(Uint8List imageData) async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return null;

      

      // Then upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');

      try {
        final uploadTask = storageRef.putData(imageData);
        final snapshot = await uploadTask;
        final imageUrl = await snapshot.ref.getDownloadURL();
        return imageUrl;
      } catch (e) {
        print('Error uploading to Firebase Storage: $e');
        // Return null but still continue with local storage
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      String? imageUrl;

      // Upload image if selected
      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
      }

      // Combine first and last names
      final fullName = '${fameController.text} ${lameController.text}'.trim();

      // Update user profile with image bytes if available
      await _authService.updateUserData(
        name: fullName,
        city: _selectedCity,
        phone: phoneController.text.isEmpty ? null : phoneController.text,
        profileImage: imageUrl,
        imageBytes: _image,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
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
                                  : _localImagePath != null
                                      ? CircleAvatar(
                                          radius: 64,
                                          backgroundImage:
                                              FileImage(File(_localImagePath!)),
                                        )
                                      : _currentUser?.profileImage != null
                                          ? CircleAvatar(
                                              radius: 64,
                                              backgroundImage: NetworkImage(
                                                  _currentUser!.profileImage!),
                                            )
                                          : Container(
                                              width: 130,
                                              height: 130,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    spreadRadius: 2,
                                                    blurRadius: 10,
                                                    color: Colors.black
                                                        .withOpacity(0.1),
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
                                    border: Border.all(
                                        width: 2, color: Colors.white),
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
                            _currentUser?.name ?? "Edit Profile",
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
                          value: _selectedCity,
                          items: [
                            "Cairo",
                            "Alexandria",
                            "Giza",
                            "Aswan",
                            "Luxor",
                            "Suez",
                          ].map((gov) {
                            return DropdownMenuItem(
                                value: gov, child: Text(gov));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCity = value;
                            });
                          },
                          validator: (value) => value == null
                              ? 'Please select your government'
                              : null,
                        ),

                        const SizedBox(height: 30),

                        Center(
                          child: CustomButton(
                            text: _isSaving ? "Saving..." : "Save Changes",
                            size: const Size(327, 48),
                            onPressed: _isSaving ? null : _saveProfile,
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
