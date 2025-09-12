import 'package:flutter/material.dart';

class NoNotificationView extends StatelessWidget {
  const NoNotificationView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/noNotificationICon.png",
              scale: 2,
            ),
            const SizedBox(height: 10),
            const Text(
              "No Notifications",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 5),
            const Text(
              "We’ll let you know when there will be\n something to update you.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      );
  }
}
