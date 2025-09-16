import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_governate_app/app_styles.dart';
import 'package:my_governate_app/profile/edit_profile.dart';
import 'package:my_governate_app/services/auth_service.dart';
import 'package:my_governate_app/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_governate_app/profile/utilis.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  bool _isLoading = true;
  bool _isObscure = true;
  Uint8List? _image;
  String? _localImagePath;

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
        
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> selectImage() async {
    try {
      final Uint8List? img = await pickImage(ImageSource.gallery);
      if (img != null) {
        setState(() {
          _image = img;
        });

        // Upload image immediately after selection
        await _uploadAndUpdateProfileImage(img);
      }
    } catch (e) {
      print('Error selecting image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error selecting image')),
      );
    }
  }

  Future<void> _uploadAndUpdateProfileImage(Uint8List imageData) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in')),
        );
        return;
      }

      
      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');

      String? imageUrl;
      try {
        final uploadTask = storageRef.putData(imageData);
        final snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        print('Error uploading to Firebase Storage: $e');
        // Continue with local storage even if Firebase upload fails
      }

      // Update profile image in Firestore
      await _authService.updateUserData(
          profileImage: imageUrl, imageBytes: imageData);

      // Reload user data
      await _loadUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully')),
      );
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating profile image')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: _image != null
                                  ? MemoryImage(_image!)
                                  : (_localImagePath != null &&
                                          File(_localImagePath!).existsSync()
                                      ? FileImage(File(_localImagePath!))
                                      : (_currentUser?.profileImage != null
                                          ? NetworkImage(
                                                  _currentUser!.profileImage!)
                                              as ImageProvider
                                          : null)),
                              child: (_image == null &&
                                      (_localImagePath == null ||
                                          !File(_localImagePath!)
                                              .existsSync()) &&
                                      _currentUser?.profileImage == null)
                                  ? Image.asset(
                                      'assets/images/Ellipse 37.png',
                                      width: 139,
                                      height: 206,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 1.5),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        _currentUser?.name ?? "User",
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
                              readOnly: true,
                              controller: TextEditingController(
                                  text: _currentUser?.email ?? ""),
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
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                TextField(
                                  readOnly: true,
                                  controller: TextEditingController(
                                      text: _currentUser?.phone ?? ""),
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.phone,
                                  decoration: AppStyles.inputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.local_phone_outlined,
                                      color: Color(0xffABABAB),
                                    ),
                                    hintText: "Add phone number",
                                  ),
                                ),
                                if (_currentUser?.phone == null)
                                  Positioned(
                                    right: 10,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.add_circle,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EditProfile(),
                                          ),
                                        ).then((_) => _loadUserData());
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),
                          Text(
                            "Name",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xff262422),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // Name instead of Password
                          SizedBox(
                            width: 335,
                            height: 70,
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                  text: _currentUser?.name ?? ""),
                              cursorColor: Colors.black,
                              decoration: AppStyles.inputDecoration(
                                hintText: "Your name",
                                prefixIcon: const Icon(
                                  Icons.person_outline,
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
                              readOnly: true,
                              controller: TextEditingController(
                                  text: _currentUser?.city ?? ""),
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
                          ).then((_) => _loadUserData());
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
