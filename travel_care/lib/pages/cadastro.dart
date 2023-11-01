import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/components/myDialog.dart';
import 'package:travel_care/pages/login.dart';
import 'package:travel_care/helpers/validation_helper.dart';
import 'package:travel_care/helpers/date_helper.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final controllerNome = TextEditingController();
  final controllerCPF = TextEditingController();
  final controllerRG = TextEditingController();
  final controllerDataNascimento = TextEditingController();
  final controllerEndereco = TextEditingController();
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerPasswordConfirmation = TextEditingController();
  final controllerEmail = TextEditingController();

  late DateTime _dataNascimento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //const SizedBox(height: 40),

                      TextFormField(
                        controller: controllerNome,
                        decoration: const InputDecoration(
                          hintText: 'Digite seu nome completo',
                          labelText: "Nome Completo",
                        ),
                        validator: (text) {
                          return validateEmptyField(text);
                        },
                      ),

                      TextFormField(
                        controller: controllerCPF,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Digite seu CPF',
                          labelText: "CPF",
                        ),
                        validator: (text) {
                          return validateEmptyField(text);
                        },
                      ),

                      TextFormField(
                        controller: controllerRG,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Digite seu RG',
                          labelText: "RG",
                        ),
                        validator: (text) {
                          return validateEmptyField(text);
                        },
                      ),

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
                        onTap: () async {
                          _dataNascimento = await handleDate(
                              context, controllerDataNascimento);
                        },
                      ),

                      TextFormField(
                        controller: controllerEndereco,
                        decoration: const InputDecoration(
                          hintText: 'Ex: Avenida Aguas Claras, 65, Centro',
                          labelText: "Endereço",
                        ),
                        validator: (text) {
                          return validateEmptyField(text);
                        },
                      ),

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
                      ),

                      TextFormField(
                        controller: controllerUsername,
                        decoration: const InputDecoration(
                          hintText: 'Digite seu login',
                          labelText: "Login",
                        ),
                        validator: (text) {
                          return validateEmptyField(text);
                        },
                      ),

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
                      ),

                      TextFormField(
                        controller: controllerPasswordConfirmation,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Digite sua senha novamente',
                          labelText: "Confirmar Senha",
                        ),
                        validator: (text) {
                          return validateEmptyField(text);
                        },
                      ),

                      const SizedBox(height: 40),

                      Row(
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
                      ),
                    ],
                  ))),
        ));
  }

  void salvarUsuario() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nome = controllerNome.text.trim();
    final cpf = controllerCPF.text.trim();
    final rg = controllerRG.text.trim();
    final endereco = controllerEndereco.text.trim();
    final email = controllerEmail.text.trim();
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();
    final passwordConfirmation = controllerPasswordConfirmation.text.trim();

    if (password != passwordConfirmation) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
                "Senhas diferentes.", () => Navigator.of(context).pop());
          });
      return;
    }

    final user = ParseUser.createUser(username, password, email);

    user.set<String>("nomeCompleto", nome);
    user.set<String>("CPF", cpf);
    user.set<String>("RG", rg);
    user.set<DateTime>("dataNascimento", _dataNascimento);
    user.set<String>("endereco", endereco);

    var response = await user.signUp();

    if (!context.mounted) return;

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
            return MyDialog(
                response.error!.message ==
                        "Account already exists for this username."
                    ? "O login escolhido já existe."
                    : (response.error!.message ==
                            "Email address format is invalid."
                        ? "Formato inválido de e-mail."
                        : (response.error!.message ==
                                "Account already exists for this email address."
                            ? "O e-mail informado já existe."
                            : "Algo deu errado. Tente novamente.")),
                () => Navigator.of(context).pop());
          });
    }
  }
}
