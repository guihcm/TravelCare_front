import 'package:flutter/material.dart';
import 'package:travel_care/controllers/pessoa_controller.dart';
import 'package:travel_care/pages/home.dart';
import 'package:travel_care/pages/login.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  
  final pessoaContoller = PessoaController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: pessoaContoller.checkIsLogged(),
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
              bool? logged = snapshot.data;
              if (logged == null || !logged) {
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
