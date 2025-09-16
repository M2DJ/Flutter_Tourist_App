import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_governate_app/models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  // Initialize with sample data for web platform
  void initializeWebNotifications() {
    if (kIsWeb) {
      _notifications = [
        NotificationModel(
          content: 'تم إضافة معبد الكرنك إلى قائمة الأماكن المفضلة لديك. استعد لرحلة رائعة!',
          imagePath: "assets/images/notify2.png",
          time: "منذ يومين",
          title: "مكان جديد مُضاف!"
        ),
        NotificationModel(
          content: "لا تفوت فرصة زيارة الأهرامات غداً. احجز تذكرتك الآن!",
          imagePath: "assets/images/notifyIcon.png",
          time: "منذ 4 أيام",
          title: "تذكير بالرحلة القادمة"
        ),
        NotificationModel(
          content: "اكتشف المتحف المصري الجديد وتمتع بالآثار الفرعونية الرائعة!",
          imagePath: "assets/images/notify3.png",
          time: "منذ يومين",
          title: "وجهة سياحية جديدة!"
        ),
        NotificationModel(
          content: "عروض خاصة على الرحلات النيلية! احجز الآن واستمتع بخصم 20%",
          imagePath: "assets/images/notify4.png",
          time: "منذ 5 أيام",
          title: "عروض حصرية!"
        ),
        NotificationModel(
          content: "شاركنا تقييمك لرحلة الإسكندرية الأخيرة وساعد المسافرين الآخرين",
          imagePath: "assets/images/notify5.png",
          time: "منذ يوم واحد",
          title: "قيّم تجربتك"
        ),
      ];
      notifyListeners();
    }
  }

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification); // Add to beginning of list
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void removeNotification(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      notifyListeners();
    }
  }

  bool get hasNotifications => _notifications.isNotEmpty;
  int get notificationCount => _notifications.length;
}
