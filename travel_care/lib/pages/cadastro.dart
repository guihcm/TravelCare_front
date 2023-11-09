import 'package:flutter/material.dart';
import 'package:travel_care/components/myDialog.dart';
import 'package:travel_care/models/pessoa.dart';
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

  static List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Cadastro de Usuário"),),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(30.0),
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

                      //TODO - CONCLUIR DROPDOWN DE CIDADE
                      DropdownButtonFormField<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        validator: (text) => validateEmptyField(text),
                        decoration: const InputDecoration(
                          hintText: 'Digite sua cidade',
                          labelText: "Cidade",
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),

                      //TODO - TELEFONE
                      //TODO - SEXO
                      //TODO - CNS

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
                  ))),
        ));
  }

  void salvarUsuario() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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

    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();

    final usuario = Pessoa(username: username, password: password, emailAddress: email);

    usuario.nomeCompleto = controllerNome.text.trim();
    usuario.cpf = controllerCPF.text.trim();
    usuario.rg = controllerRG.text.trim();
    usuario.dataNascimento = _dataNascimento;
    usuario.endereco = controllerEndereco.text.trim();

    var response = await usuario.signUp();

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
