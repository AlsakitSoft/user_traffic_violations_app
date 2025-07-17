import 'package:flutter/material.dart';
import 'violations_list_screen.dart';
import 'statistics_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import '../services/api_service.dart'; // Import ApiService
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required String userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;
  String? _currentUserId; // To store the logged-in user ID
  final ApiService _apiService = ApiService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUserAndScreens();
    // تهيئة البيانات الوهمية للإشعارات
    NotificationService.initializeMockNotifications();
  }

  Future<void> _initializeUserAndScreens() async {
    // For demonstration, we'll try to log in a dummy user.
    // In a real app, this would come from a login screen or stored credentials.
    try {
      // Replace with actual login credentials or a way to get the user ID
      final loginResponse =
          await _apiService.login("ahmed@example.com", "hashedpassword123");
      if (loginResponse != null &&
          loginResponse.containsKey('userId') &&
          loginResponse.containsKey('token')) {
        // حفظ التوكن في ApiService
        _apiService.setAuthToken(loginResponse['token']);

        setState(() {
          _currentUserId = loginResponse['userId'];
          _screens = [
            ViolationsListScreen(userId: _currentUserId!),
            StatisticsScreen(userId: _currentUserId!),
            const NotificationsScreen(),
            ProfileScreen(userId: _currentUserId!),
          ];
          _isLoading = false;
        });

        // final loginResponse =
        //     await _apiService.login("citizen@example.com", "password123");
        // if (loginResponse != null && loginResponse.containsKey('userId')) {
        //   setState(() {
        //     _currentUserId = loginResponse['userId'];
        //     _screens = [
        //       ViolationsListScreen(userId: _currentUserId!),
        //       StatisticsScreen(userId: _currentUserId!),
        //       const NotificationsScreen(),
        //       ProfileScreen(userId: _currentUserId!),
        //     ];
        //     _isLoading = false;
        //   });
      } else {
        // Handle login failure or missing userId
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('فشل تسجيل الدخول أو الحصول على معرف المستخدم')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تسجيل الدخول: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentUserId == null) {
      return const Scaffold(
        body: Center(
            child: Text(
                'الرجاء تسجيل الدخول للمتابعة.')), // Or navigate to a login screen
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'المخالفات',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'الإحصائيات',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                // عرض نقطة حمراء إذا كان هناك إشعارات غير مقروءة
                if (NotificationService.getUnreadNotifications().isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'الإشعارات',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
        ],
      ),
    );
  }
}
