import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Center(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Container(
                        width: 305,
                        //height: 326,
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: null,
                              //keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Digite seu nome completo',
                                labelText: "Nome Completo",
                                //prefixText: "DE - ",
                                //suffixIcon: Icon(Icons.airport_shuttle),
                              ),
                              validator: (text) {
                                return validateEmptyField(text);
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 305,
                        child: Stack(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Digite seu CPF',
                                labelText: "CPF",
                              ),
                              validator: (text) {
                                return validateEmptyField(text);
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 305,
                        child: Stack(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Digite sua data de nascimento',
                                labelText: "Data de nascimento",
                              ),
                              validator: (text) {
                                return validateEmptyField(text);
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 305,
                        child: Stack(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText:
                                    'Ex: Avenida Aguas Claras, 65, Centro',
                                labelText: "Endereço",
                              ),
                              validator: (text) {
                                return validateEmptyField(text);
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 305,
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: controllerEmail,
                              decoration: const InputDecoration(
                                hintText: 'Ex: seuemail@email.com',
                                labelText: "Email",
                              ),
                              validator: (text) {
                                return validateEmptyField(text);
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 305,
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: controllerUsername,
                              decoration: const InputDecoration(
                                hintText: 'Digite seu login',
                                labelText: "Login",
                              ),
                              validator: (text) {
                                return validateEmptyField(text);
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 305,
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: controllerPassword,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Digite sua senha',
                                labelText: "Senha",
                              ),
                              validator: (text) {
                                return validateEmptyField(text);
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 305,
                        child: Stack(
                          children: [
                            TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Digite sua senha novamente',
                                labelText: "Confirmar Senha",
                              ),
                              validator: (text) {
                                return validateEmptyField(text);
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                          height: 200,
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                  margin: const EdgeInsets.all(30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Voltar')),
                                      const Spacer(),
                                      ElevatedButton(
                                          child: const Text('Salvar'),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              salvarUsuario();

                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    //title: const Text("Cadastro de paciente:"),
                                                    content: const Text(
                                                        "Cadastro realizado com sucesso!"),
                                                    actions: <Widget>[
                                                      Center(
                                                          child: ElevatedButton(
                                                        child: const Text("Ok"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ))
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          }),
                                    ],
                                  )))),
                    ],
                  ))),
        ));
  }

  String? validateEmptyField(String? text) {
    if (text == null || text.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  void salvarUsuario() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (response.success) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      showError("Algo deu errado. Tente novamente.");
    }
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erro!"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
