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
            var pessoa = snapshot.data;
              return AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blue,
                title: Text(
                  pessoa!.cadastroCompleto!
                  ? 'Olá, ${getFirstName(pessoa.nomeCompleto) ?? "Prezado Usário"}!'
                  : 'Complete seu cadastro',
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

  logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: const Text(
                  'Você realmente deseja sair?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Não',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await pessoaController.logout(context);
            },
            child: const Text(
              'Sim',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
