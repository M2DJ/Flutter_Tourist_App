import 'package:flutter/material.dart';
import 'package:my_governate_app/services/auth_service.dart';
import 'package:my_governate_app/Intro/splash_screen.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          "Log out",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: const Text(
          "Are you sure you want to log out? You'll need to login again to use the app.",
          style: TextStyle(
              fontSize: 12, color: Color.fromARGB(255, 135, 135, 135))),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xff5A91F7),
                  )),
              foregroundColor: const Color(0xff5A91F7),
              fixedSize: const Size.fromWidth(110),
              backgroundColor: Colors.white),
          child: const Text(
            "Cancel",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              final authService = AuthService();
              await authService.signOut();
              
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                  (route) => false,
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error logging out: $e')),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xff5A91F7),
                  )),
              foregroundColor: Colors.white,
              fixedSize: const Size.fromWidth(110),
              backgroundColor: const Color.fromARGB(255, 72, 126, 226)),
          child: const Text("Log out",
              style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
