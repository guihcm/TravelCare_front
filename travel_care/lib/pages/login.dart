import 'package:flutter/material.dart';
import 'package:travel_care/components/myAppBar.dart';
import 'package:travel_care/pages/cadastro.dart';
import 'package:travel_care/pages/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.black,
        //appBar: const MyAppBar("TRAVELCARE"),
        body: Center(
            child: Form(
                key: _formKey,
                child: Column(children: [
                  const SizedBox(height: 50),

                  // logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),

                  const SizedBox(height: 50),

                  // welcome back, you've been missed!
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    width: 305,
                    child: Stack(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(230, 230, 230, 100),
                            hintText: 'Digite seu login',
                            labelText: "Login",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 305,
                    child: Stack(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(230, 230, 230, 100),
                            hintText: 'Digite sua senha',
                            labelText: "Senha",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //height: 350.0,
                    width: 305,
                    child: Column(children: [
                      CheckboxListTile(
                        title: const Text("Salvar dados de acesso!"),
                        value: _isChecked,
                        onChanged: (val) {
                          setState(() {
                            _isChecked = val!;
                          });
                        },
                      )
                    ]),
                  ),

                  SizedBox(height: 10),

                  Text('Esqueceu a senha? Clique aqui!'),
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage())),
                      child: const Text('Entrar')),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'OU',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    child: Text('Não possui uma conta? Cadastre-se!'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CadastroPage())),
                  ),

                  SizedBox(height: 20),
                ]))));
  }
}
