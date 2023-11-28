import 'package:flutter/material.dart';
import 'package:travel_care/controllers/pessoa_controller.dart';
import 'package:travel_care/models/pessoa.dart';
import 'package:travel_care/pages/complete.dart';
import 'package:travel_care/pages/home.dart';
import 'package:travel_care/pages/login.dart';
import 'package:travel_care/pages/profile.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  
  final pessoaContoller = PessoaController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pessoa?>(
        future: pessoaContoller.loggedUser(),
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
              Pessoa? pessoa = snapshot.data;
              if (pessoa == null) {
                return const Scaffold(
                  body: LoginPage(),
                );
              } else if (pessoa.cadastroCompleto == false) {
                return const Scaffold(
                  body: CompletePage(),
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


