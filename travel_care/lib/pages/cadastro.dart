import 'package:flutter/material.dart';
import 'package:travel_care/components/myDialog.dart';
import 'package:travel_care/controllers/cidade_controller.dart';
import 'package:travel_care/models/cidade.dart';
import 'package:travel_care/models/pessoa.dart';
import 'package:travel_care/models/sexo.dart';
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
  final controllerCNS = TextEditingController();
  final controllerDataNascimento = TextEditingController();
  final controllerTelefone = TextEditingController();
  final controllerEndereco = TextEditingController();
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerPasswordConfirmation = TextEditingController();
  final controllerEmail = TextEditingController();

  late DateTime _dataNascimento;

  late Future<List<Cidade>?> cidadeList;
  final cidadeController = CidadeController();

  Cidade? _cidade;
  Sexo? _sexo;

  @override
  void initState() {
    super.initState();
    cidadeList = getCidades();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cidade>?>(
        future: cidadeList,
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
              final cidades = snapshot.data;
              return Scaffold(
                  appBar: AppBar(
                    title: const Text("Cadastro de Usuário"),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
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
                                  controller: controllerCNS,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'Digite seu CNS',
                                    labelText: "CNS",
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
                                  controller: controllerTelefone,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'Digite seu telefone',
                                    labelText: "Telefone",
                                  ),
                                  validator: (text) {
                                    return validateEmptyField(text);
                                  },
                                ),
                                DropdownButtonFormField<Sexo>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  //validator: (sexo) => validateNotNull(sexo),
                                  decoration: const InputDecoration(
                                    labelText: "Sexo",
                                  ),
                                  hint: const Text("Seleciona seu sexo"),
                                  onChanged: (Sexo? value) {
                                    setState(() {
                                      _sexo = value!;
                                    });
                                  },
                                  items: Sexo.values
                                      .toList()
                                      .map<DropdownMenuItem<Sexo>>(
                                          (Sexo value) {
                                    return DropdownMenuItem<Sexo>(
                                      value: value,
                                      child: Text(value.name.toUpperCase()),
                                    );
                                  }).toList(),
                                ),
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
                                ),
                                DropdownButtonFormField<Cidade>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  validator: (cidade) =>
                                      validateNotNull(cidade),
                                  decoration: const InputDecoration(
                                    labelText: "Cidade",
                                  ),
                                  hint: const Text("Selecione sua cidade"),
                                  onChanged: (Cidade? value) {
                                    setState(() {
                                      _cidade = value!;
                                    });
                                  },
                                  items: cidades!
                                      .map<DropdownMenuItem<Cidade>>(
                                          (Cidade value) {
                                    return DropdownMenuItem<Cidade>(
                                      value: value,
                                      child: Text(value.nome!),
                                    );
                                  }).toList(),
                                ),
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
        });
  }

  Future<List<Cidade>?> getCidades() async {
    return await cidadeController.getAllCidades();
  }

  void salvarUsuario() async {
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

    final pessoa =
        Pessoa(username: username, password: password, emailAddress: email);

    pessoa.nomeCompleto = controllerNome.text.trim();
    pessoa.cpf = controllerCPF.text.trim();
    pessoa.rg = controllerRG.text.trim();
    pessoa.cns = controllerCNS.text.trim();
    pessoa.dataNascimento = _dataNascimento;
    pessoa.telefone = controllerTelefone.text.trim();
    pessoa.endereco = controllerEndereco.text.trim();
    pessoa.sexo = _sexo;
    pessoa.cidade = _cidade;

    var response = await pessoa.signUp();

    if (!context.mounted) return;

    if (response.success) {
      pessoa.deleteLocalUserData();
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
