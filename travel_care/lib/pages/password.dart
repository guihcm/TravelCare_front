import 'package:flutter/material.dart';
import 'package:travel_care/controllers/pessoa_controller.dart';
import 'package:travel_care/helpers/validation_helper.dart';

class PasswordPage extends StatefulWidget {
  PasswordPage(this.email, {super.key});

  String? email;

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final pessoaController = PessoaController();

  var controllerEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerEmail.text = widget.email ?? "";
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Redefinir Senha"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  ClipRRect(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Recuperação de Senha',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Informe seu e-mail para recuperação!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Ex: seuemail@email.com',
                      labelText: "E-mail",
                    ),
                    validator: (text) {
                      return validateEmptyField(text);
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      bool edit = controllerEmail.text == "" ? true : false;
                      if (_formKey.currentState!.validate()) {
                        pessoaController.recuperarSenha(context, controllerEmail, edit);
                      }
                    },
                    child: const Text(
                      'Enviar',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
