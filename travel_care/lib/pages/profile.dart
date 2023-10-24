import 'package:flutter/material.dart';
import 'package:travel_care/pages/cadastro.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          const Text("Perfil"),
          ElevatedButton(
              child: const Text("Cadastro"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CadastroPage()));
              }),
        ]),
      ),
    );
  }
}
