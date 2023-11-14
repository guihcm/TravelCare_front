import 'package:flutter/material.dart';
import 'package:travel_care/controllers/pessoa_controller.dart';
import 'package:travel_care/helpers/string_helper.dart';
import 'package:travel_care/models/pessoa.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}

class _MyAppBarState extends State<MyAppBar> {
  final pessoaController = PessoaController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pessoa?>(
        future: pessoaController.loggedUser(),
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
                  'Olá, ${getFirstName(snapshot.data?.nomeCompleto) ?? "Prezado Usário"}!',
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                      onPressed: () => pessoaController.logout(context),
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ))
                ],
              );
          }
        });
  }
}
