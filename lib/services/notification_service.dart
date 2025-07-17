import '../models/violation.dart';

class NotificationService {
  static final List<NotificationItem> _notifications = [];

  // إضافة إشعار جديد
  static void addNotification(NotificationItem notification) {
    _notifications.insert(0, notification);
  }

  // الحصول على جميع الإشعارات
  static List<NotificationItem> getAllNotifications() {
    return _notifications;
  }

  // الحصول على الإشعارات غير المقروءة
  static List<NotificationItem> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }

  // تحديد إشعار كمقروء
  static void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  // تحديد جميع الإشعارات كمقروءة
  static void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  // محاكاة إشعار مخالفة جديدة
  static void simulateNewViolationNotification(Violation violation) {
    final notification = NotificationItem(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: 'مخالفة جديدة',
      message: 'تم تسجيل مخالفة جديدة: ${violation.type}',
      timestamp: DateTime.now(),
      type: NotificationType.newViolation,
      relatedViolationId: violation.id,
      isRead: false,
    );
    addNotification(notification);
  }

  // محاكاة إشعار تذكير بالدفع
  static void simulatePaymentReminderNotification(Violation violation) {
    final notification = NotificationItem(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: 'تذكير بالدفع',
      message: 'لديك مخالفة غير مدفوعة: ${violation.type}',
      timestamp: DateTime.now(),
      type: NotificationType.paymentReminder,
      relatedViolationId: violation.id,
      isRead: false,
    );
    addNotification(notification);
  }

  // إضافة بيانات وهمية للإشعارات
  static void initializeMockNotifications() {
    final mockNotifications = [
      NotificationItem(
        id: 'notif_1',
        title: 'مخالفة جديدة',
        message: 'تم تسجيل مخالفة تجاوز السرعة على طريق الملك فهد',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.newViolation,
        relatedViolationId: 'V001',
        isRead: false,
      ),
      NotificationItem(
        id: 'notif_2',
        title: 'تذكير بالدفع',
        message: 'لديك مخالفة غير مدفوعة منذ 3 أيام',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.paymentReminder,
        relatedViolationId: 'V003',
        isRead: false,
      ),
      NotificationItem(
        id: 'notif_3',
        title: 'تم الدفع بنجاح',
        message: 'تم دفع مخالفة الوقوف الخاطئ بنجاح',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.paymentConfirmation,
        relatedViolationId: 'V002',
        isRead: true,
      ),
    ];

    _notifications.addAll(mockNotifications);
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final String? relatedViolationId;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.relatedViolationId,
    required this.isRead,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    String? relatedViolationId,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      relatedViolationId: relatedViolationId ?? this.relatedViolationId,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum NotificationType {
  newViolation,
  paymentReminder,
  paymentConfirmation,
  general,
}

