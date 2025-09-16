import 'package:flutter/material.dart';
import 'package:my_governate_app/models/notification_model.dart';
import 'package:my_governate_app/notification/custom_notification.dart';
import 'package:my_governate_app/notification/no_notifications.dart';
import 'package:my_governate_app/providers/notification_provider.dart';
import 'package:my_governate_app/services/fcm_service.dart';
import 'package:provider/provider.dart';
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize FCM with notification provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      
      // Initialize web notifications if on web platform
      notificationProvider.initializeWebNotifications();
      
      // Initialize FCM for mobile platforms
      FCMService.initNotifications(notificationProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "الإشعارات",
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<NotificationProvider>(
                builder: (context, notificationProvider, child) {
                  final notifications = notificationProvider.notifications;
                  return notifications.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return CustomNotification(
                                title: notifications[index].title,
                                imagePath: notifications[index].imagePath,
                                time: notifications[index].time,
                                content: notifications[index].content,
                                onTap: () {
                                  _showNotificationDetails(context, notifications[index]);
                                },
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(
                              height: 12,
                            ),
                            itemCount: notifications.length,
                          ),
                        )
                      : const NoNotificationView();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, NotificationModel notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            notification.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (notification.imagePath.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      notification.imagePath,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                if (notification.imagePath.isNotEmpty) const SizedBox(height: 12),
                Text(
                  notification.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.time,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'إغلاق',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add action based on notification type
                _handleNotificationAction(notification);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('عرض التفاصيل'),
            ),
          ],
        );
      },
    );
  }

  void _handleNotificationAction(NotificationModel notification) {
    // Handle different notification actions based on title or content
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم فتح: ${notification.title}'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
