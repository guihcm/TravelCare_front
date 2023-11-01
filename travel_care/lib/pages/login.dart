import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/components/myDialog.dart';
import 'package:travel_care/pages/cadastro.dart';
import 'package:travel_care/pages/password.dart';
import 'package:travel_care/pages/home.dart';
import 'package:travel_care/helpers/validation_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                
                      ClipRRect(
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 200,
                        ),
                      ),
                
                      const SizedBox(height: 25),
                
                      Text(
                        'Insira os seus dados de acesso!',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                        ),
                      ),
                
                      const SizedBox(height: 25),
                
                      Form(
                          key: _formKey,
                          child: Column(children: [
                
                            TextFormField(
                              controller: controllerUsername,
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
                              validator: (text) => validateEmptyField(text),
                            ),
                
                            const SizedBox(height: 20),
                
                            TextFormField(
                              controller: controllerPassword,
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
                              obscureText: true,
                              validator: (text) => validateEmptyField(text),
                            ),

                            const SizedBox(height: 20),
                
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Esqueceu a senha?',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 18,
                                    )),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  child: const Text(
                                    'Clique aqui',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PasswordPage())),
                                ),
                              ],
                            ),
                
                            const SizedBox(height: 30),
                
                            ElevatedButton(
                                onPressed: () => login(),
                                child: const Text('Entrar',
                                    style: TextStyle(
                                      fontSize: 22,
                                    ))),
                
                            const SizedBox(height: 30),
                
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      thickness: 1,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text(
                                      'OU',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      thickness: 1,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                
                            const SizedBox(height: 20),
                
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Não possui uma conta?',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 18,
                                    )),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  child: const Text(
                                    'Cadastre-se',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CadastroPage())),
                                ),
                              ],
                            ),
                
                            const SizedBox(height: 20),
                          ])),
                    ],
                  ),
                ))));
  }

  void login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (!context.mounted) return;

    if (response.success) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      String message = response.error!.message == "Invalid username/password."
                    ? "Login ou senha incorretos."
                    : "Algo deu errado. Tente novamente.";

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(message, () => Navigator.of(context).pop());
          });
    }
  }

}
