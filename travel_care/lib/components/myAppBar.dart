import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/components/myDialog.dart';
import 'package:travel_care/pages/login.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  ParseUser? currentUser;

  MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50.0);

  Future<ParseUser?> getUser() async {
    currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParseUser?>(
        future: widget.getUser(),
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
              return AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blue,
                title: Text(
                  'Olá, ${snapshot.data!.get<String>("nomeCompleto", defaultValue: "Prezado Usuário")}!',
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                      onPressed: () => logout(),
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ))
                ],
              );
          }
        });
  }

  Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout(deleteLocalUserData: false);

    if (!context.mounted) return;

    if (response.success ||
        response.error!.message == "Invalid session token") {
      user.deleteLocalUserData();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog("Algo deu errado. Tente novamente.",
                () => Navigator.of(context).pop());
          });
    }
  }
}
