import 'package:flutter/material.dart';
import 'package:travel_care/pages/home.dart';
import 'package:travel_care/pages/notification.dart';
import 'package:travel_care/pages/profile.dart';
import 'package:travel_care/pages/travel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/notification': (context) => const NotificationPage(),
        '/profile': (context) => const ProfilePage(),
        '/travel': (context) => const TravelPage(),
      },
    );
  }
}
