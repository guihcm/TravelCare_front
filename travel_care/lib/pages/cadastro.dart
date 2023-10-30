import 'package:flutter/material.dart';
import 'package:travel_care/components/myAppBar.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar("TRAVELCARE"),
        body: Center(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
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
                              hintText: 'Ex: Avenida Aguas Claras, 65, Centro',
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
                    Expanded(
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                                margin: const EdgeInsets.all(30),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
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
                                            //TODO Mandar para o backend

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
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
                ))));
  }

  String? validateEmptyField(String? text) {
    if (text == null || text.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }
}
