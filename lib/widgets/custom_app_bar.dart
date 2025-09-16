import 'package:flutter/material.dart';
import 'package:my_governate_app/notification/notification_screens.dart';
import 'package:my_governate_app/services/auth_service.dart';
import 'package:my_governate_app/models/user_model.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _authService.getCurrentUserData();
    if (mounted) {
      setState(() {
        _currentUser = userData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    width: 120,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xffF7F7F9),
                      borderRadius: BorderRadius.circular(23),
                      shape: BoxShape.rectangle,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 17,
                          backgroundImage: _currentUser?.profileImage != null 
                              ? NetworkImage(_currentUser!.profileImage!)
                              : const AssetImage("assets/images/myProfile.png") as ImageProvider,
                          child: _currentUser?.profileImage == null 
                              ? Image.asset("assets/images/myProfile.png")
                              : null,
                        ),
                        Text(
                          _currentUser?.name ?? "user",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const NotificationScreen();
                  },
                ));
              },
              child: Image.asset(
                "assets/icons/image.png",
                scale: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
