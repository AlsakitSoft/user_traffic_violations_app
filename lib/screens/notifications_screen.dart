import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import 'violation_details_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _notifications = NotificationService.getAllNotifications();
    });
  }

  void _markAsRead(NotificationItem notification) {
    NotificationService.markAsRead(notification.id);
    _loadNotifications();
  }

  void _markAllAsRead() {
    NotificationService.markAllAsRead();
    _loadNotifications();
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.newViolation:
        return Icons.warning;
      case NotificationType.paymentReminder:
        return Icons.payment;
      case NotificationType.paymentConfirmation:
        return Icons.check_circle;
      case NotificationType.general:
        return Icons.info;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.newViolation:
        return Colors.red;
      case NotificationType.paymentReminder:
        return Colors.orange;
      case NotificationType.paymentConfirmation:
        return Colors.green;
      case NotificationType.general:
        return Colors.blue;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('الإشعارات'),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'تحديد الكل كمقروء',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد إشعارات',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: notification.isRead ? Colors.white : Colors.blue[50],
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getNotificationColor(notification.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getNotificationIcon(notification.type),
                        color: _getNotificationColor(notification.type),
                        size: 24,
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.message,
                          style: TextStyle(
                            color: notification.isRead
                                ? Colors.grey[600]
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getTimeAgo(notification.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    trailing: notification.relatedViolationId != null
                        ? const Icon(Icons.arrow_forward_ios)
                        : null,
                    onTap: () {
                      if (!notification.isRead) {
                        _markAsRead(notification);
                      }
                      
                      if (notification.relatedViolationId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViolationDetailsScreen(
                              violationId: notification.relatedViolationId!,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // محاكاة إشعار جديد للاختبار
          NotificationService.addNotification(
            NotificationItem(
              id: 'test_${DateTime.now().millisecondsSinceEpoch}',
              title: 'إشعار تجريبي',
              message: 'هذا إشعار تجريبي لاختبار النظام',
              timestamp: DateTime.now(),
              type: NotificationType.general,
              isRead: false,
            ),
          );
          _loadNotifications();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إضافة إشعار تجريبي')),
          );
        },
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.add),
      ),
    );
  }
}

