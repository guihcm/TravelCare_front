import 'package:flutter/material.dart';
import 'package:travel_care/components/myAppBar.dart';
import 'package:travel_care/components/myNavBar.dart';
import 'package:travel_care/pages/notification.dart';
import 'package:travel_care/pages/profile.dart';
import 'package:travel_care/pages/request.dart';
import 'package:travel_care/pages/travel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List _pages = [
    const TravelPage(),
    const NotificationPage(),
    const ProfilePage(),
    const RequestPage(),
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      bottomNavigationBar: MyNavBar(_selectedIndex, _selectPage),
      body: _pages[_selectedIndex],
    );
  }
}
