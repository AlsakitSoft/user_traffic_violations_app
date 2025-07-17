import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TrafficViolationsApp());
}

class TrafficViolationsApp extends StatelessWidget {
  const TrafficViolationsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق المخالفات المرورية',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial', // يمكن تغييرها لخط عربي
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const HomeScreen(userId: 'USER001'),
      debugShowCheckedModeBanner: false,
    );
  }
}

