import 'package:flutter/material.dart';
import 'package:travel_care/pages/login.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.blue,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);

}
