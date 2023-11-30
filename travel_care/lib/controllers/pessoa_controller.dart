import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/components/myDialog.dart';
import 'package:travel_care/models/cidade.dart';
import 'package:travel_care/models/pessoa.dart';
import 'package:travel_care/models/sexo.dart';
import 'package:travel_care/pages/complete.dart';
import 'package:travel_care/pages/home.dart';
import 'package:travel_care/pages/login.dart';
import 'package:travel_care/pages/profile.dart';

class PessoaController {
  Future<Pessoa?> loggedUser() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      return Pessoa.fromParseUser(user);
    }
    return null;
  }

  Future<bool> checkIsLogged() async {
    var currentUser = await loggedUser();
    if (currentUser != null) {
      return true;
    }
    return false;
  }

  void login(BuildContext context, TextEditingController controllerUsername,
      TextEditingController controllerPassword) async {
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (!context.mounted) return;

    if (response.success) {
      response.result['cadastroCompleto']
          ? Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false)
          : Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const CompletePage()),
              (Route<dynamic> route) => false);
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

  Future<void> logout(BuildContext context) async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout(deleteLocalUserData: false);

    if (!context.mounted) return;

    if (response.success ||
        response.error!.message == "Invalid session token") {
      user.deleteLocalUserData();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog("Algo deu errado. Tente novamente.", () {
              Navigator.of(context).pop();
            });
          });
    }
  }

  Future<void> salvarUsuario(
      BuildContext context,
      TextEditingController? controllerPassword,
      TextEditingController? controllerPasswordConfirmation,
      TextEditingController? controllerEmail,
      TextEditingController? controllerNome,
      TextEditingController? controllerCPF,
      TextEditingController? controllerRG,
      TextEditingController? controllerCNS,
      DateTime? dataNascimento,
      TextEditingController? controllerTelefone,
      TextEditingController? controllerEndereco,
      Sexo? sexo,
      Cidade? cidade) async {
    final String? password = controllerPassword?.text.trim();

    final passwordConfirmation = controllerPasswordConfirmation?.text.trim();

    if (password != passwordConfirmation) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
                "As senhas não conferem.", () => Navigator.of(context).pop());
          });
    } else {
      String? username = controllerCPF?.text.trim();

      final email = controllerEmail?.text.trim();

      final pessoa =
          Pessoa(username: username, password: password, emailAddress: email);

      pessoa.nomeCompleto = controllerNome?.text.trim();
      pessoa.cpf = controllerCPF?.text.trim();
      pessoa.rg = controllerRG?.text.trim();
      pessoa.cns = controllerCNS?.text.trim();
      pessoa.dataNascimento = dataNascimento;
      pessoa.telefone = controllerTelefone?.text.trim();
      pessoa.endereco = controllerEndereco?.text.trim();
      pessoa.sexo = sexo;
      pessoa.cidade = cidade;
      pessoa.cadastroCompleto = true;

      ParseResponse? response = await pessoa.signUp();

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
        _createUserErrorMessage(context, response);
      }
    }
  }

  Future<void> salvarAcompanhante(
      BuildContext context,
      TextEditingController? controllerNome,
      TextEditingController? controllerCPF,
      TextEditingController? controllerRG,
      DateTime? dataNascimento,
      TextEditingController? controllerTelefone) async {
    final String? username = controllerCPF?.text.trim();

    final nomeCompleto = controllerNome?.text.trim();
    final cpf = controllerCPF?.text.trim();
    final rg = controllerRG?.text.trim();
    final telefone = controllerTelefone?.text.trim();

    String senha = controllerCPF!.text.replaceAll('.', '');
    senha = senha.replaceAll('-', '');
    final String? password = senha;

    final response =
        await ParseCloudFunction('salvarAcompanhante').execute(parameters: {
      'username': username,
      'password': password,
      'outrosCampos': {
        'nomeCompleto': nomeCompleto,
        'CPF': cpf,
        'RG': rg,
        'dataNascimento': dataNascimento.toString(),
        'telefone': telefone,
        'cadastroCompleto': false,
      },
    });

    if (!context.mounted) return;

    if (response.success) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog("Cadastro de acompanhante realizado com sucesso!",
                () => Navigator.of(context).pop());
          }).then((value) => Navigator.of(context).pop([
            response.result['objectId'].toString(),
            response.result['nomeAcompanhante'].toString()
          ]));
    } else {
      _createUserErrorMessage(context, response);
    }
  }

  void editarUsuario(
      BuildContext context,
      TextEditingController controllerEmail,
      TextEditingController controllerNome,
      TextEditingController controllerCPF,
      TextEditingController controllerRG,
      TextEditingController controllerCNS,
      DateTime? dataNascimento,
      TextEditingController controllerTelefone,
      TextEditingController controllerEndereco,
      Sexo? sexo,
      Cidade? cidade) async {
    final pessoa = await loggedUser();

    final bool? cadastroCompleto = pessoa?.cadastroCompleto;

    pessoa!.username = controllerCPF.text.trim();
    pessoa.emailAddress = controllerEmail.text.trim();
    pessoa.nomeCompleto = controllerNome.text.trim();
    pessoa.cpf = controllerCPF.text.trim();
    pessoa.rg = controllerRG.text.trim();
    pessoa.cns = controllerCNS.text.trim();
    pessoa.dataNascimento = dataNascimento ?? pessoa.dataNascimento;
    pessoa.telefone = controllerTelefone.text.trim();
    pessoa.endereco = controllerEndereco.text.trim();
    pessoa.sexo = sexo ?? pessoa.sexo;
    pessoa.cidade = cidade;
    pessoa.cadastroCompleto = true;

    var response = await pessoa.save();

    if (!context.mounted) return;

    if (response.success) {
      pessoa.getUpdatedUser();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
                "Dados atualizados com sucesso!",
                cadastroCompleto!
                    ? () => Navigator.pop(context)
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage())));
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
                response.error!.message ==
                        "Account already exists for this username."
                    ? "O CPF informado já existe."
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

  void recuperarSenha(BuildContext context,
      TextEditingController controllerEmail, bool edit) async {
    var email = controllerEmail.text.trim();

    var emailExiste = await _getByEmail(email);

    if (emailExiste) {
      ParseUser user = ParseUser(null, null, email);
      var response = await user.requestPasswordReset();

      if (!context.mounted) {
        return;
      }

      if (response.success) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog("E-mail enviado com sucesso.", () {
                if (edit) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              });
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog("Falha ao enviar email de redefinição de senha.",
                  () => Navigator.of(context).pop());
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
                "Usuário não encontrado.", () => Navigator.of(context).pop());
          });
    }
  }

  Future<Pessoa?> getPessoa(String? pessoaId) async {
    if (pessoaId == null) return null;

    final queryBuilder = QueryBuilder<Pessoa>(Pessoa())
      ..whereEqualTo('objectId', pessoaId);

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      return response.results!.first as Pessoa?;
    }
    return null;
  }

  Future<Pessoa?> getAcompanhante(String? pessoaCpf) async {
    if (pessoaCpf == null) return null;

    final queryBuilder = QueryBuilder<Pessoa>(Pessoa())
      ..whereEqualTo('CPF', pessoaCpf);

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      return response.results!.first as Pessoa?;
    }
    return null;
  }

  getAcompanhant(String? pessoaCpf) async {
    if (pessoaCpf == null) return null;

    final queryBuilder = QueryBuilder<Pessoa>(Pessoa())
      ..whereEqualTo('CPF', pessoaCpf);

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      return response.results!.first as Pessoa?;
    }
    return null;
  }

  void _createUserErrorMessage(BuildContext context, ParseResponse response) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog(
              response.error!.message ==
                      "Account already exists for this username."
                  ? "O CPF informado já existe. Se for o seu primeiro acesso tente entrar com CPF como login e senha."
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

  Future<bool> _getByEmail(String email) async {
    final queryBuilder = QueryBuilder<Pessoa>(Pessoa())
      ..whereEqualTo('email', email);

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      return true;
    }
    return false;
  }
}
