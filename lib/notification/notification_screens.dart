import 'package:flutter/material.dart';
import 'package:my_governate_app/models/notification_model.dart';
import 'package:my_governate_app/notification/custom_notification.dart';
import 'package:my_governate_app/notification/no_notifications.dart';
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    List<NotificationModel> notifications = [
      NotificationModel(
          content:
              'Added Gourmet Cheese to your kit. Next week just got tastier!',
          imagePath: "assets/images/notify2.png",
          time: "2 days ago",
          title: "Order Tweaked!"),
      NotificationModel(
        content: "Last chance to add a little extra to your Tuesday delivery.",
        imagePath: "assets/images/notifyIcon.png",
        time: "4 days ago",
        title: "Tomorrow's treats!",
      ),
      NotificationModel(
        content: "Your Exotic Veggie Platter is on the menu. Get excited!",
        imagePath: "assets/images/notify3.png",
        time: "2 days ago",
        title: "Thursday's Feast Awaits!",
      ),
      NotificationModel(
        content: "New menu items are in! What will you try next?",
        imagePath: "assets/images/notify4.png",
        time: "5 days ago",
        title: "Fresh Flavors Unveiled!",
      ),
      NotificationModel(
        content: "Tell us how the Veggie Platter did on the flavor front!",
        imagePath: "assets/images/notify5.png",
        time: "1 day ago",
        title: "Taste Satisfaction?",
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: notifications.isNotEmpty
                ? ListView.separated(
                    itemBuilder: (context, index) {
                      return CustomNotification(
                        title: notifications[index].title,
                        imagePath: notifications[index].imagePath,
                        time: notifications[index].time,
                        content: notifications[index].content,
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 19,
                    ),
                    itemCount: notifications.length,
                  )
                : const NoNotificationView(),
          )
        ],
      ),
    );
  }
}
