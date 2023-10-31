// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/components/myDialog.dart';
import 'package:travel_care/pages/login.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final controllerNome = TextEditingController();
  final controllerCPF = TextEditingController();
  final controllerDataNascimento = TextEditingController();
  final controllerEndereco = TextEditingController();
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  
  late DateTime _dataNascimento;

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
                      const SizedBox(height: 40),
                      Container(
                        width: 305,
                        //height: 326,
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: controllerNome,
                              //keyboardType: TextInputType.datetime,
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
                              controller: controllerCPF,
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
                              controller: controllerDataNascimento,
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(
                                hintText: 'Digite sua data de nascimento',
                                labelText: "Data de nascimento",
                                suffixIcon: Icon(Icons.calendar_month),
                              ),
                              validator: (text) {
                                return validateEmptyField(text);
                              },
                              onTap: () => selectDate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 305,
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: controllerEndereco,
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
                              keyboardType: TextInputType.emailAddress,
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
                      const SizedBox(height: 20),
                      Container(
                          margin: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Voltar',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ))),
                              const Spacer(),
                              ElevatedButton(
                                  child: const Text('Salvar',
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      salvarUsuario();
                                    }
                                  }),
                            ],
                          )),
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

    final nome = controllerNome.text.trim();
    final cpf = controllerCPF.text.trim();
    final dataNascimetnto = DateTime.parse(_dataNascimento.toString());
    final endereco = controllerEndereco.text.trim();
    final email = controllerEmail.text.trim();
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser.createUser(username, password, email);

    user.set<String>("nomeCompleto", nome);
    user.set<String>("CPF", cpf);
    user.set<DateTime>("dataNascimento", dataNascimetnto);
    user.set<String>("endereco", endereco);

    var response = await user.signUp();

    if (response.success) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
                "Cadastro realizado com sucesso!",
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginPage())));
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog("Algo deu errado. Tente novamente.",
                () => Navigator.of(context).pop());
          });
    }
  }

  Future selectDate() async {
    FocusScope.of(context).requestFocus(FocusNode());

    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null) {
      _dataNascimento = picked;
      controllerDataNascimento.text =
          "${picked.day.toString()}-${picked.month.toString()}-${picked.year.toString()}";
    }
  }
}
