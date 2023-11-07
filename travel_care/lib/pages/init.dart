import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/pages/home.dart';
import 'package:travel_care/pages/login.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  bool isLogged = false;

  Future<bool> checkIsLogged() async {
    var currentUser = await ParseUser.currentUser() as ParseUser;
    if (currentUser != null) {
      isLogged = true;
    }
    return isLogged;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: checkIsLogged(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator()),
              );
            default:
              if (!isLogged) {
                return const Scaffold(
                  body: LoginPage(),
                );
              } else {
                return const Scaffold(
                  body: HomePage(),
                );
              }
          }
        });
  }
}
