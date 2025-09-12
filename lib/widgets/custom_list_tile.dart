import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String? title;
  final Icon icon;
  const CustomListTile({super.key, this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title!,
          style: const TextStyle(
              color: Color(0xff006FFD), fontWeight: FontWeight.w500)),
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: const Color.fromARGB(255, 146, 165, 190),
        child: icon,
      ),
    );
  }
}
