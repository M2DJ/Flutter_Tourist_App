import 'package:flutter/material.dart';
import 'package:my_governate_app/about/about_screen.dart';
import 'package:my_governate_app/help_and_support/help_and_support.dart';
import 'package:my_governate_app/logout/logout_dialog.dart';
import 'package:my_governate_app/map_screen/map_screen.dart';
import 'package:my_governate_app/widgets/custom_list_tile.dart';
import 'package:my_governate_app/services/auth_service.dart';
import 'package:my_governate_app/models/user_model.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _authService.getCurrentUserData();
      setState(() {
        _currentUser = userData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xff5A91F7),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 23, bottom: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: _currentUser?.profileImage != null 
                          ? NetworkImage(_currentUser!.profileImage!)
                          : const AssetImage("assets/images/myProfile.png") as ImageProvider,
                      child: _currentUser?.profileImage == null 
                          ? Image.asset("assets/images/myProfile.png")
                          : null,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    // Dynamic user data from Firebase
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Column(
                            children: [
                              Text(
                                _currentUser?.name ?? "مستخدم",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18),
                              ),
                              Text(
                                _currentUser?.city ?? "غير محدد",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                            ],
                          )
                  ],
                ),
              )),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const MapScreen();
                },
              ));
            },
            child: const CustomListTile(
                title: "Map",
                icon: Icon(
                  Icons.location_on,
                  color: Colors.white,
                )),
          ),
          const Divider(
            color: Color(0xffD4D6DD),
            endIndent: 10,
            indent: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const AboutScreen();
                },
              ));
            },
            child: const CustomListTile(
                title: "About",
                icon: Icon(
                  Icons.info,
                  color: Colors.white,
                )),
          ),
          const Divider(
            color: Color(0xffD4D6DD),
            endIndent: 10,
            indent: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const HelpSupportPage();
                },
              ));
            },
            child: const CustomListTile(
                title: "Help & Support",
                icon: Icon(
                  Icons.question_mark_outlined,
                  color: Colors.white,
                )),
          ),
          const Divider(
            color: Color(0xffD4D6DD),
            endIndent: 10,
            indent: 10,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const LogoutDialog();
                },
              );
            },
            child: const CustomListTile(
                title: "Logout",
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
