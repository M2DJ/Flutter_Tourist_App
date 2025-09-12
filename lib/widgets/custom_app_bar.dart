import 'package:flutter/material.dart';
import 'package:my_governate_app/notification/notification_screens.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Builder(builder: (context) {
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
                      shape: BoxShape.rectangle),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 17,
                        child: Image.asset("assets/images/myProfile.png"),
                      ),
                      Text(
                        "Ahmed Ezz",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              );
            }),
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
                ))
          ],
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
