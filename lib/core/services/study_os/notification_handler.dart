import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  String? pendingScheduleStartId;
  String? pendingScheduleEndId;
  bool appJustLaunched = false;

  void onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;

    if (payload.startsWith('study_start:')) {
      pendingScheduleStartId = payload.substring('study_start:'.length);
    } else if (payload.startsWith('study_end:')) {
      pendingScheduleEndId = payload.substring('study_end:'.length);
    }
  }

  String? consumePendingStart() {
    final id = pendingScheduleStartId;
    pendingScheduleStartId = null;
    return id;
  }

  String? consumePendingEnd() {
    final id = pendingScheduleEndId;
    pendingScheduleEndId = null;
    return id;
  }
}
